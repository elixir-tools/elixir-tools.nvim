local language_server = require("elixir.language_server")
local mix = require("elixir.mix")
local projectionist = require("elixir.projectionist")

local M = {}

M.settings = language_server.settings
M.open_output_panel = language_server.open_output_panel

function M.setup(opts)
  mix.setup()
  projectionist.setup()
  language_server.setup(opts)
end

return M
