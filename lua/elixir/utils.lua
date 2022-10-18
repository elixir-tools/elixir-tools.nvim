local lspconfig = require("lspconfig")
local lsputil = require("lspconfig.util")

local uv = vim.loop

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

  local path = lsputil.path
  local child_or_root_path = lsputil.root_pattern { "mix.exs", ".git" }(fname)
  local maybe_umbrella_path =
    lsputil.root_pattern { "mix.exs" }(uv.fs_realpath(path.join { child_or_root_path, ".." }))

  local has_ancestral_mix_exs_path =
    vim.startswith(child_or_root_path, path.join { maybe_umbrella_path, "apps" })
  if maybe_umbrella_path and not has_ancestral_mix_exs_path then
    maybe_umbrella_path = nil
  end

  local path = maybe_umbrella_path or child_or_root_path or vim.loop.os_homedir()

  return path
end

return M
