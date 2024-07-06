if not vim.iter then
  vim.iter = require("elixir.iter")
end

local elixirls = require("elixir.elixirls")
local credo = require("elixir.credo")
local nextls = require("elixir.nextls")
local mix = require("elixir.mix")
local projectionist = require("elixir.projectionist")
local utils = require("elixir.utils")

local M = {}

M.elixirls = {}

M.elixirls.settings = elixirls.settings
M.elixirls.open_output_panel = elixirls.open_output_panel

M.credo = {}

M.credo.default_bin = (
  vim.fn.fnamemodify(debug.getinfo(1).source, ":h") .. "/../../bin/credo-language-server"
):gsub("^@", "")

local enabled = function(value)
  return value == nil or value == true
end

local get_cursor_position = function()
  local rowcol = vim.api.nvim_win_get_cursor(0)
  local row = rowcol[1] - 1
  local col = rowcol[2]

  return row, col
end

local define_user_command = function()
  vim.api.nvim_create_user_command("Elixir", function(opts)
    local args = vim.iter(opts.fargs)
    local command = args:next()
    local not_found = false
    local workspace_commands = {
      ["to-pipe"] = true,
      ["from-pipe"] = true,
      ["alias-refactor"] = true,
    }

    if "nextls" == command then
      local subcommand = args:next()
      if "uninstall" == subcommand then
        vim.fn.delete(nextls.default_bin)
        vim.notify(
          string.format("[elixir-tools] Uninstalled Next LS from %s", nextls.default_bin),
          vim.lsp.log_levels.INFO
        )
      elseif workspace_commands[subcommand] then
        local row, col = get_cursor_position()
        local uri = vim.uri_from_bufnr(0)
        vim.lsp.buf.execute_command {
          command = subcommand,
          arguments = { { position = { line = row, character = col }, uri = uri } },
        }
      else
        not_found = true
      end
    else
      not_found = true
    end
    if not_found then
      vim.notify("[elixir-tools] Unknown command: " .. opts.name .. " " .. opts.args, vim.lsp.log_levels.WARN)
    end
  end, {
    desc = "elixir-tools main command",
    nargs = "+",
    complete = function(_, cmd_line)
      local cmd = vim.trim(cmd_line)
      if vim.startswith(cmd, "Elixir nextls") then
        return { "alias-refactor", "to-pipe", "from-pipe", "uninstall" }
      elseif vim.startswith(cmd, "Elixir") then
        return { "nextls" }
      end
    end,
  })
end

function M.setup(opts)
  opts = opts or {}

  opts.elixirls = opts.elixirls or {}
  opts.credo = opts.credo or {}
  opts.nextls = opts.nextls or {}
  opts.projectionist = opts.projectionist or {}

  define_user_command()

  if not opts.credo.cmd then
    opts.credo.cmd = M.credo.default_bin
  end

  if opts.credo.enable == true and not opts.credo.version then
    opts.credo.version = utils.latest_release("elixir-tools", "credo-language-server")
  end

  local nextls_auto_update
  if not opts.nextls.cmd then
    opts.nextls.cmd = nextls.default_bin
    nextls_auto_update = true
  end

  mix.setup()

  if enabled(opts.projectionist.enable) then
    projectionist.setup(opts.projectionist)
  end

  if enabled(opts.elixirls.enable) then
    elixirls.setup(opts.elixirls)
  end

  if opts.credo.version and opts.credo.enable == true then
    credo.setup(opts.credo)
  end

  if opts.nextls.enable == true then
    nextls.setup(vim.tbl_extend("force", opts.nextls, { auto_update = nextls_auto_update }))
  end
end

return M
