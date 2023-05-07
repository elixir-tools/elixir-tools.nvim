local Path = require("plenary.path")
local M = {}

function M.safe_path(path)
  return string.gsub(path, "/", "_")
end

function M.repo_path(repo, ref)
  local x = M.safe_path(string.format("%s-%s", repo, ref or "HEAD"))

  return x
end

function M.root_dir(fname)
  if not fname or fname == "" then
    fname = vim.fn.getcwd()
  end

  local matches = vim.fs.find({ "mix.exs" }, { upward = true, limit = 2, path = fname })
  local child_or_root_path, maybe_umbrella_path = unpack(matches)

  return vim.fs.dirname(maybe_umbrella_path or child_or_root_path)
end

return M
