local utils = require("elixir.utils")
local M = {}

if not vim.uv then
  vim.uv = vim.loop
end

M.default_bin = vim.g.next_ls_default_bin or (vim.env.HOME .. "/.cache/elixir-tools/nextls/bin/nextls")
M.default_data = vim.g.next_ls_data_dir or (vim.env.HOME .. "/.data/elixir-tools/nextls")

function M.setup(opts)
  vim.print(opts)
  local nextls_group = vim.api.nvim_create_augroup("elixir-tools.nextls", { clear = true })

  vim.api.nvim_create_autocmd("User", {
    pattern = "ElixirToolsNextLSActivate",
    group = nextls_group,
    callback = function(event)
      local cmd = event.data.cmd
      local auto_update = event.data.auto_update
      local options = event.data.opts
      local workspace_folders = event.data.workspace_folders

      vim.lsp.start({
        name = "NextLS",
        cmd = cmd,
        cmd_env = {
          NEXTLS_VERSION = options.version,
          NEXTLS_SPITFIRE_ENABLED = options.spitfire and 1 or 0,
          NEXTLS_AUTO_UPDATE = auto_update,
        },
        init_options = options.init_options or vim.empty_dict(),
        settings = {},
        capabilities = options.capabilities or vim.lsp.protocol.make_client_capabilities(),
        workspace_folders = workspace_folders,
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
      local lock_matches
      local mix_exs_matches
      local workspace_folders
      if vim.g.workspace then
        local uri = vim.uri_from_bufnr(0)
        if
          vim.iter(vim.g.workspace.folders):any(function(folder)
            return vim.startswith(uri, folder.uri)
          end)
        then
          workspace_folders = vim.g.workspace.folders
        end
      else
        lock_matches = vim.fs.find({ "mix.lock" }, {
          stop = vim.uv.os_homedir(),
          upward = true,
          path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
        })

        mix_exs_matches = vim.fs.find({ "mix.exs" }, {
          stop = vim.uv.os_homedir(),
          upward = true,
          path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
        })
        local file = lock_matches[1] or mix_exs_matches[1]

        if file then
          local root_dir = vim.fs.dirname(file)
          assert(type(root_dir) == "string", "expected root_dir to be a string")
          workspace_folders = {
            { name = vim.fs.basename(root_dir), uri = vim.uri_from_fname(root_dir) },
          }
        end
      end

      if workspace_folders then
        local cmd
        if type(opts.port) == "number" then
          cmd = vim.lsp.rpc.connect("127.0.0.1", opts.port)
        else
          cmd = { opts.cmd, "--stdio" }
        end
        local activate = function()
          vim.api.nvim_exec_autocmds("User", {
            pattern = "ElixirToolsNextLSActivate",
            data = {
              workspace_folders = workspace_folders,
              cmd = cmd,
              auto_update = opts.auto_update,
              opts = opts,
            },
          })
        end

        local force_download = not vim.uv.fs_stat(M.default_data .. "/.next-ls-force-update-v1")

        if
          (force_download and opts.auto_update)
          or (
            not vim.b.elixir_tools_prompted_nextls_install
            and type(opts.port) ~= "number"
            and (opts.auto_update and not vim.uv.fs_stat(opts.cmd))
          )
        then
          vim.ui.select({ "Yes", "No" }, { prompt = "Install Next LS?" }, function(choice)
            if choice == "Yes" then
              utils.download_nextls()
              activate()
            else
              vim.b["elixir_tools_prompted_nextls_install"] = true
            end
          end)
        else
          vim.schedule_wrap(activate)()
        end
      end
    end,
  })
  return opts
end

return M
