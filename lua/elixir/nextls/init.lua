local M = {}

if not vim.uv then
  vim.uv = vim.loop
end

if not vim.iter then
  vim.iter = require("elixir.iter")
end

function M.setup(opts)
  local nextls_group = vim.api.nvim_create_augroup("elixir-tools.nextls", { clear = true })

  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = nextls_group,
    pattern = { "elixir", "eelixir", "heex", "surface" },
    callback = function()
      local matches = vim.fs.find({ "mix.lock" }, {
        stop = vim.uv.os_homedir(),
        upward = true,
        path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
      })

      local file = matches[1]

      if file then
        local cmd
        if type(opts.port) == "number" then
          cmd = vim.lsp.rpc.connect("127.0.0.1", opts.port)
        else
          cmd = { opts.cmd, "--stdio" }
        end

        local root_dir = vim.fs.dirname(file)
        assert(type(root_dir) == "string", "expected root_dir to be a string")

        vim.lsp.start({
          name = "NextLS",
          cmd = cmd,
          cmd_env = {
            NEXTLS_VERSION = opts.version,
          },
          settings = {},
          workspace_folders = {
            { name = root_dir, uri = vim.uri_from_fname(root_dir) },
          },
          on_attach = opts.on_attach or function() end,
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
      end
    end,
  })
end

return M
