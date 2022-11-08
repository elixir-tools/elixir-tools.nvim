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

  local child_or_root_path =
    vim.fs.dirname(vim.fs.find({ "mix.exs", ".git" }, { upward = true, path = fname })[1])
  local maybe_umbrella_path =
    vim.fs.dirname(vim.fs.find({ "mix.exs" }, { upward = true, path = child_or_root_path })[1])

  if maybe_umbrella_path then
    if not vim.startswith(child_or_root_path, Path:joinpath(maybe_umbrella_path, "apps"):absolute()) then
      maybe_umbrella_path = nil
    end
  end

  local path = maybe_umbrella_path or child_or_root_path or vim.loop.os_homedir()

  return path
end

return M
