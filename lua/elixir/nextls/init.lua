local M = {}

if not vim.uv then
  vim.uv = vim.loop
end

function M.setup(opts)
  local nextls_group = vim.api.nvim_create_augroup("elixir-tools.nextls", { clear = true })

  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = nextls_group,
    pattern = { "elixir" },
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

        vim.lsp.start {
          name = "NextLS",
          cmd = cmd,
          cmd_env = {
            NEXTLS_VERSION = opts.version,
          },
          settings = {},
          root_dir = vim.fs.dirname(file),
          on_attach = opts.on_attach or function() end,
        }
      end
    end,
  })
end

return M
