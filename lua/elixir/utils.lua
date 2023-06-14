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

function M.latest_release(owner, repo)
  local curl = string.format(
    [[curl --silent -L -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/%s/%s/releases/latest]],
    owner,
    repo
  )
  local resp = vim.json.decode(vim.fn.system(curl))

  return resp and resp.tag_name and resp.tag_name:gsub("^v", "") or nil
end

return M
