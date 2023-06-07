local M = {}

if not vim.uv then
  vim.uv = vim.loop
end

function M.setup(opts)
  local credo = vim.api.nvim_create_augroup("elixir-tools.credo", { clear = true })

  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = credo,
    pattern = { "elixir" },
    callback = function()
      local matches = vim.fs.find({ "mix.lock" }, {
        stop = vim.uv.os_homedir(),
        upward = true,
        path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
      })

      local file = nil

      local function read_file(path)
        local f = io.open(path, "rb")
        if not f then
          return nil
        end
        local content = f:read("*a")
        f:close()
        return content
      end

      for _, f in ipairs(matches) do
        if f and read_file(f):find([["credo": {]]) then
          file = f
          break
        end
      end

      if file then
        local cmd
        if type(opts.port) == "number" then
          cmd = vim.lsp.rpc.connect("127.0.0.1", opts.port)
        else
          cmd = { opts.cmd, "--stdio" }
        end

        vim.lsp.start {
          name = "Credo",
          cmd = cmd,
          cmd_env = {
            CREDO_LSP_VERSION = opts.version,
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
