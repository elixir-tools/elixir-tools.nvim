local _version = [[
  Erlang/OTP 24 [erts-12.1] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1]

  Elixir 1.13.3 (compiled with Erlang/OTP 22)
]]

local M = {}

function M.erlang_version(version_string)
  return string.match(version_string, "Erlang/OTP (%d+)")
end

function M.elixir_version(version_string)
  return string.match(version_string, "Elixir (%d+%.%d+%.%d+)")
end

function M.get()
  local version_string = vim.fn.system("elixir --version")
  return string.format("%s-%s", M.elixir_version(version_string), M.erlang_version(version_string))
end

return M
