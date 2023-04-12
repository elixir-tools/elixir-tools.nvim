local elixirls = require("elixir.elixirls")
local credo = require("elixir.credo")
local mix = require("elixir.mix")
local projectionist = require("elixir.projectionist")

local M = {}

M.elixirls = {}

M.elixirls.settings = elixirls.settings
M.elixirls.open_output_panel = elixirls.open_output_panel

function M.setup(opts)
  mix.setup()
  projectionist.setup()
  elixirls.setup(opts.elixirls or {})
  if opts.credo then
    credo.setup(opts.credo)
  end
end

return M
