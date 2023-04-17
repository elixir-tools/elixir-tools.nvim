local elixirls = require("elixir.elixirls")
local credo = require("elixir.credo")
local mix = require("elixir.mix")
local projectionist = require("elixir.projectionist")

local M = {}

M.elixirls = {}

M.elixirls.settings = elixirls.settings
M.elixirls.open_output_panel = elixirls.open_output_panel

M.credo = {}

M.credo.default_bin = vim.fn.fnamemodify(debug.getinfo(1).short_src, ":h")
  .. "/../../bin/credo-language-server"

function M.setup(opts)
  opts = opts or {}

  if opts.credo and not opts.credo.bin then
    opts.credo.bin = M.credo.default_bin
  end

  mix.setup()
  projectionist.setup()
  elixirls.setup(opts.elixirls or {})
  if opts.credo then
    credo.setup(opts.credo)
  end
end

return M
