local elixirls = require("elixir.elixirls")
local credo = require("elixir.credo")
local mix = require("elixir.mix")
local projectionist = require("elixir.projectionist")

local M = {}

M.elixirls = {}

M.elixirls.settings = elixirls.settings
M.elixirls.open_output_panel = elixirls.open_output_panel

M.credo = {}

M.credo.default_bin = (
  vim.fn.fnamemodify(debug.getinfo(1).source, ":h") .. "/../../bin/credo-language-server"
):gsub("^@", "")

M.credo.default_version = "0.0.5"

local enabled = function(value)
  return value == nil or value == true
end

function M.setup(opts)
  opts = opts or {}

  opts.elixirls = opts.elixirls or {}
  opts.credo = opts.credo or {}

  if not opts.credo.cmd then
    opts.credo.cmd = M.credo.default_bin
  end

  if not opts.credo.version then
    opts.credo.version = M.credo.default_version
  end

  mix.setup()
  projectionist.setup()
  if enabled(opts.elixirls.enable) then
    elixirls.setup(opts.elixirls)
  end
  if enabled(opts.credo.enable) then
    credo.setup(opts.credo)
  end
end

return M
