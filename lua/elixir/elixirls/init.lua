local Path = require("plenary.path")
local popup = require("plenary.popup")

local Version = require("elixir.elixirls.version")
local Download = require("elixir.elixirls.download")
local Compile = require("elixir.elixirls.compile")
local Utils = require("elixir.utils")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local default_install_tag = "tags/v0.22.0"

local elixir_nvim_output_bufnr

local M = {}

local get_cursor_position = function()
  local rowcol = vim.api.nvim_win_get_cursor(0)
  local row = rowcol[1] - 1
  local col = rowcol[2]

  return row, col
end

function M.open_floating_window(buf)
  local columns = vim.o.columns
  local lines = vim.o.lines
  local width = math.ceil(columns * 0.8)
  local height = math.ceil(lines * 0.8 - 4)

  local bufnr = buf or vim.api.nvim_create_buf(false, true)

  popup.create(bufnr, {
    line = 0,
    col = 0,
    minwidth = width,
    minheight = height,
    border = false,
    padding = { 2, 2, 2, 2 },
    zindex = 10,
  })

  return bufnr
end

local manipulate_pipes = function(direction, client)
  local row, col = get_cursor_position()

  client.request_sync("workspace/executeCommand", {
    command = "manipulatePipes:serverid",
    arguments = { direction, "file://" .. vim.api.nvim_buf_get_name(0), row, col },
  }, nil, 0)
end

function M.from_pipe(client)
  return function()
    manipulate_pipes("fromPipe", client)
  end
end

function M.to_pipe(client)
  return function()
    manipulate_pipes("toPipe", client)
  end
end

function M.restart(client)
  return function()
    client.request_sync("workspace/executeCommand", {
      command = "restart:serverid",
      arguments = {},
    }, nil, 0)

    vim.cmd([[w | edit]])
  end
end

function M.expand_macro(client)
  return function()
    local params = vim.lsp.util.make_given_range_params()

    local text = vim.api.nvim_buf_get_text(
      0,
      params.range.start.line,
      params.range.start.character,
      params.range["end"].line,
      params.range["end"].character,
      {}
    )

    local resp = client.request_sync("workspace/executeCommand", {
      command = "expandMacro:serverid",
      arguments = { params.textDocument.uri, vim.fn.join(text, "\n"), params.range.start.line },
    }, nil, 0)

    local content = {}
    if resp["result"] then
      for k, v in pairs(resp.result) do
        vim.list_extend(content, { "# " .. k, "" })
        vim.list_extend(content, vim.split(v, "\n"))
      end
    else
      table.insert(content, "Error")
    end

    -- not sure why i need this here
    vim.schedule(function()
      vim.lsp.util.open_floating_preview(vim.lsp.util.trim_empty_lines(content), "elixir", {})
    end)
  end
end

local nil_buf_id = 999999
local term_buf_id = nil_buf_id

local function test(command)
  local row, _col = get_cursor_position()
  local args = command.arguments[1]

  -- delete the current buffer if it's still open
  if vim.api.nvim_buf_is_valid(term_buf_id) then
    vim.api.nvim_buf_delete(term_buf_id, { force = true })
    term_buf_id = nil_buf_id
  end

  vim.cmd("botright new | lua vim.api.nvim_win_set_height(0, 15)")
  term_buf_id = vim.api.nvim_get_current_buf()
  vim.opt_local.number = false
  vim.opt_local.cursorline = false

  local cmd = "mix test " .. args.filePath

  -- add the line number if it's for a specific describe/test block
  if args.describe or args.testName then
    cmd = cmd .. ":" .. (row + 1)
  end

  vim.fn.termopen(cmd, {
    on_exit = function(_jobid, exit_code, _event)
      if exit_code == 0 then
        vim.api.nvim_buf_delete(term_buf_id, { force = true })
        term_buf_id = nil_buf_id
        vim.notify("[elixir-tools] Success: " .. cmd, vim.log.levels.INFO)
      else
        vim.notify("[elixir-tools] Fail: " .. cmd, vim.log.levels.ERROR)
      end
    end,
  })

  vim.cmd([[wincmd p]])
end

M.settings = function(opts)
  return {
    elixirLS = vim.tbl_extend("force", {
      dialyzerEnabled = true,
      fetchDeps = false,
      enableTestLenses = false,
      suggestSpecs = false,
    }, opts),
  }
end

function M.command(params)
  local install_path =
    Path:new(params.path, params.repo, Utils.safe_path(params.ref), params.versions, "language_server.sh")

  return install_path
end

function M.open_output_panel(opts)
  local options = opts or { window = "split" }

  local window = {
    split = function()
      vim.cmd("sp")
      vim.api.nvim_win_set_buf(0, elixir_nvim_output_bufnr)
      vim.api.nvim_win_set_height(0, 30)
    end,
    vsplit = function()
      vim.cmd("vs")
      vim.api.nvim_win_set_buf(0, elixir_nvim_output_bufnr)
      vim.api.nvim_win_set_width(0, 80)
    end,
    float = function()
      M.open_floating_window(elixir_nvim_output_bufnr)
    end,
  }

  window[options.window]()
end

M.on_attach = function(client, bufnr)
  local add_user_cmd = vim.api.nvim_buf_create_user_command
  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
    buffer = bufnr,
    callback = function()
      vim.lsp.codelens.refresh { bufnr = bufnr }
    end,
  })
  vim.lsp.codelens.refresh { bufnr = bufnr }
  add_user_cmd(bufnr, "ElixirFromPipe", M.from_pipe(client), {})
  add_user_cmd(bufnr, "ElixirToPipe", M.to_pipe(client), {})
  add_user_cmd(bufnr, "ElixirRestart", M.restart(client), {})
  add_user_cmd(bufnr, "ElixirExpandMacro", M.expand_macro(client), { range = true })
  add_user_cmd(bufnr, "ElixirOutputPanel", function()
    M.open_output_panel()
  end, {})
end

local cache_dir = Path:new(vim.fn.getcwd(), ".elixir_ls", "elixir-tools.nvim")
local download_dir = cache_dir:joinpath("downloads")
local install_dir = Path:new(vim.fn.expand("~/.cache/nvim/elixir-tools.nvim/installs"))

local function install_elixir_ls(opts)
  local source_path = Download.clone(tostring(download_dir:absolute()), opts)
  local bufnr = M.open_floating_window()

  Compile.compile(
    download_dir:joinpath(source_path):absolute(),
    opts.install_path:absolute(),
    vim.tbl_extend("force", opts, {
      bufnr = bufnr,
      on_exit = function(_, compile_code)
        if compile_code == 0 then
          if bufnr then
            vim.api.nvim_buf_call(bufnr, function()
              vim.api.nvim_command("quit")
            end)
          end

          vim.notify("[elixir-tools] Finished compiling ElixirLS!")
          vim.notify("[elixir-tools] Reloading buffer")
          vim.api.nvim_command("edit")
          vim.notify("[elixir-tools] Restarting LSP client")
          vim.api.nvim_command("LspRestart")
          vim.fn.jobstart({ "rm", "-rf", download_dir:absolute() }, {
            on_exit = vim.schedule_wrap(function(_, rm_code)
              if rm_code == 0 then
                vim.notify("[elixir-tools] Cleaned up elixir-tools.nvim download directory")
              else
                vim.api.nvim_err_writeln("Failed to clean up elixir-tools.nvim download directory")
              end
            end),
          })
        end
      end,
    })
  )
end

local function repo_opts(opts)
  local repo = opts.repo or "elixir-lsp/elixir-ls"
  local ref
  if opts.branch then
    ref = opts.branch
  elseif opts.tag then
    ref = "tags/" .. opts.tag
  else
    if opts.repo then -- if we specified a repo in our conifg, then let's default to HEAD
      ref = "HEAD"
    else -- else, let's checkout the latest stable release
      ref = default_install_tag
    end
  end

  return {
    repo = repo,
    ref = ref,
  }
end

local function wrap_in_table(maybe_string)
  if type(maybe_string) == "string" then
    return { maybe_string }
  else
    return maybe_string
  end
end

function M.setup(opts)
  opts = opts or {}

  if not elixir_nvim_output_bufnr then
    elixir_nvim_output_bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(elixir_nvim_output_bufnr, "ElixirLS Output Panel")
  end

  local elixir_group = vim.api.nvim_create_augroup("elixir-tools.elixirls", { clear = true })

  local start_elixir_ls = function(arg)
    local fname = Path.new(arg.file):absolute()

    local root_dir = opts.root_dir and opts.root_dir(fname) or Utils.root_dir(fname)
    local repo_options = repo_opts(opts)

    local cmd = M.command {
      path = tostring(install_dir),
      repo = repo_options.repo,
      ref = repo_options.ref,
      versions = Version.get(),
    }

    if not opts.cmd and not cmd:exists() then
      if vim.g.elixirnvim_has_prompted_for_install ~= true then
        vim.ui.select({ "Yes", "No" }, { prompt = "Install ElixirLS" }, function(choice)
          if choice == "Yes" then
            install_elixir_ls(vim.tbl_extend("force", repo_options, { install_path = cmd:parent() }))
          end

          vim.g.elixirnvim_has_prompted_for_install = true
        end)
      end

      return
    end

    if root_dir then
      local log_message = vim.lsp.handlers["window/logMessage"]
      vim.lsp.start(vim.tbl_extend("keep", {
        name = "ElixirLS",
        cmd = opts.cmd and wrap_in_table(opts.cmd) or { tostring(cmd) },
        commands = {
          ["elixir.lens.test.run"] = test,
        },
        settings = opts.settings or M.settings {},
        capabilities = opts.capabilities or capabilities,
        root_dir = root_dir,
        handlers = vim.tbl_extend("keep", {
          ["window/logMessage"] = function(err, result, ...)
            log_message(err, result, ...)

            local message =
              vim.split("[" .. vim.lsp.protocol.MessageType[result.type] .. "] " .. result.message, "\n")

            pcall(vim.api.nvim_buf_set_lines, elixir_nvim_output_bufnr, -1, -1, false, message)
          end,
        }, opts.handlers or {}),
        on_attach = function(...)
          if opts.on_attach then
            opts.on_attach(...)
          end

          M.on_attach(...)
        end,
      }, opts))
    end
  end

  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = elixir_group,
    pattern = { "elixir", "eelixir", "heex", "surface" },
    callback = vim.schedule_wrap(start_elixir_ls),
  })
end

return M
