local utils = require("elixir.utils")
local M = {}

if not vim.uv then
  vim.uv = vim.loop
end

M.default_bin = vim.env.HOME .. "/.cache/elixir-tools/nextls/bin/nextls"

function M.setup(opts)
  local nextls_group = vim.api.nvim_create_augroup("elixir-tools.nextls", { clear = true })

  vim.api.nvim_create_autocmd("User", {
    pattern = "ElixirToolsNextLSActivate",
    group = nextls_group,
    callback = function(event)
      local cmd = event.data.cmd
      local auto_update = event.data.auto_update
      local options = event.data.opts
      local root_dir = event.data.root_dir
      vim.lsp.start({
        name = "NextLS",
        cmd = cmd,
        cmd_env = {
          NEXTLS_VERSION = options.version,
          NEXTLS_AUTO_UPDATE = auto_update,
        },
        init_options = options.init_options or vim.empty_dict(),
        settings = {},
        capabilities = options.capabilities or vim.lsp.protocol.make_client_capabilities(),
        workspace_folders = {
          { name = root_dir, uri = vim.uri_from_fname(root_dir) },
        },
        on_attach = options.on_attach or function() end,
      }, {
        bufnr = 0,
        reuse_client = function(client, config)
          return client.name == config.name
            and vim.iter(client.workspace_folders or {}):any(function(client_wf)
              return vim.iter(config.workspace_folders):any(function(new_config_wf)
                return new_config_wf.name == client_wf.name and new_config_wf.uri == client_wf.uri
              end)
            end)
        end,
      })
    end,
  })

  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = nextls_group,
    pattern = { "elixir", "eelixir", "heex", "surface" },
    callback = function()
      local lock_matches = vim.fs.find({ "mix.lock" }, {
        stop = vim.uv.os_homedir(),
        upward = true,
        path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
      })

      local mix_exs_matches = vim.fs.find({ "mix.exs" }, {
        stop = vim.uv.os_homedir(),
        upward = true,
        path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
      })

      local file = lock_matches[1] or mix_exs_matches[1]

      if file then
        local cmd
        if type(opts.port) == "number" then
          cmd = vim.lsp.rpc.connect("127.0.0.1", opts.port)
        else
          cmd = { opts.cmd, "--stdio" }
        end

        local root_dir = vim.fs.dirname(file)
        assert(type(root_dir) == "string", "expected root_dir to be a string")
        local activate = function()
          vim.api.nvim_exec_autocmds("User", {
            pattern = "ElixirToolsNextLSActivate",
            data = {
              root_dir = root_dir,
              cmd = cmd,
              auto_update = opts.auto_update,
              opts = opts,
            },
          })
        end

        if
          not vim.b.elixir_tools_prompted_nextls_install
          and type(opts.port) ~= "number"
          and (opts.auto_update and not vim.uv.fs_stat(opts.cmd))
        then
          vim.ui.select({ "Yes", "No" }, { prompt = "Install Next LS?" }, function(choice)
            if choice == "Yes" then
              utils.download_nextls()
              activate()
            else
              vim.b.elixir_tools_prompted_nextls_install = true
            end
          end)
        else
          vim.schedule_wrap(activate)()
        end
      end
    end,
  })
end

return M
