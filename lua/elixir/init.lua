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

M.nextls = {}

M.nextls.default_bin = (vim.fn.fnamemodify(debug.getinfo(1).source, ":h") .. "/../../bin/nextls"):gsub(
  "^@",
  ""
)

local enabled = function(value)
  return value == nil or value == true
end

function M.setup(opts)
  opts = opts or {}

  opts.elixirls = opts.elixirls or {}
  opts.credo = opts.credo or {}
  opts.nextls = opts.nextls or {}

  if not opts.credo.cmd then
    opts.credo.cmd = M.credo.default_bin
  end

  if enabled(opts.credo.enable) and not opts.credo.version then
    opts.credo.version = utils.latest_release("elixir-tools", "credo-language-server")
  end

  if not opts.nextls.cmd then
    opts.nextls.cmd = M.nextls.default_bin
  end

  if opts.nextls.enable and not opts.nextls.version then
    opts.nextls.version = utils.latest_release("elixir-tools", "next-ls")
  end

  mix.setup()
  projectionist.setup()
  if enabled(opts.elixirls.enable) then
    elixirls.setup(opts.elixirls)
  end

  if opts.credo.version and enabled(opts.credo.enable) then
    credo.setup(opts.credo)
  end

  if opts.nextls.version and opts.nextls.enable == true then
    nextls.setup(opts.nextls)
  end
end

return M
