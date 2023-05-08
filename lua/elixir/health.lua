local V = require("elixir.elixirls.version")
local M = {}

function M.check()
  vim.health.start("elixir-tools.nvim report")

  local version_string = vim.fn.system("elixir --version")
  local ex_version = V.elixir_version(version_string)
  local otp_version = V.erlang_version(version_string)

  if type(ex_version) == "string" then
    vim.health.ok("Elixir v" .. ex_version)
  else
    vim.health.error("couldn't figure out elixir version")
  end

  if type(otp_version) == "string" then
    vim.health.ok("OTP " .. otp_version)
  else
    vim.health.error("couldn't figure out OTP version")
  end
end

return M
