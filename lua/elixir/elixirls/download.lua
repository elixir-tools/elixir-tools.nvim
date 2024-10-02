local Path = require("plenary.path")
local Job = require("plenary.job")

local Utils = require("elixir.utils")

local M = {}

function M.clone(dir, opts)
  opts = opts or {}
  local r = opts.repo
  local rr = Utils.safe_path(opts.ref or "HEAD")
  local dir_identifier = Path:new(r, rr).filename

  vim.notify(string.format("[elixir-tools] Cloning ref %s from repo %s", opts.ref or "default", opts.repo))

  local made_path = Path:new(dir):mkdir { parents = true, mode = 493 }
  assert(made_path, "failed to make the path")

  local clone = Job:new {
    command = "git",
    args = { "-C", dir, "clone", string.format("https://github.com/%s.git", opts.repo), dir_identifier },
    enable_recording = true,
  }

  clone:sync(60000)

  assert(clone.code == 0, string.format("Failed to clone %s", opts.repo))

  if opts.ref ~= "HEAD" then
    local checkout = Job:new {
      command = "git",
      args = { "-C", Path:new(dir, dir_identifier).filename, "checkout", opts.ref },
    }
    checkout:sync()

    assert(checkout.code == 0, "Failed to checkout ref " .. opts.ref)
  end

  vim.notify("[elixir-tools] Downloaded ElixirLS!")

  return dir_identifier
end

return M
