local M = {}

function M.setup(opts)
  local credo = vim.api.nvim_create_augroup("elixir-tools.credo", { clear = true })

  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = credo,
    pattern = { "elixir" },
    callback = function()
      local file =
        vim.fs.find({ "mix.exs" }, { upward = true, path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)) })[1]

      local function read_file(path)
        local f = io.open(path, "rb")
        if not f then
          return nil
        end
        local content = f:read("*a")
        f:close()
        return content
      end

      if file and not read_file(file):find("{:credo, ") then
        file = nil
      end

      vim.lsp.start {
        name = "Credo",
        -- cmd = vim.lsp.rpc.connect('127.0.0.1', 9000),
        cmd = { opts.bin, "--stdio" },
        settings = {},
        root_dir = vim.fs.dirname(file),
        on_attach = opts.on_attach or function() end,
      }
    end,
  })
end

return M
