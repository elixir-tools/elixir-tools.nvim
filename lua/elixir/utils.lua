local Path = require("plenary.path")
local M = {}

---@param path string
function M.safe_path(path)
  return string.gsub(path, "/", "_")
end

---@param repo string
---@param ref string
---@return string
function M.repo_path(repo, ref)
  local x = M.safe_path(string.format("%s-%s", repo, ref or "HEAD"))

  return x
end

---@param fname string?
---@return string
function M.root_dir(fname)
  if not fname or fname == "" then
    fname = vim.fn.getcwd()
  end

  local matches = vim.fs.find({ "mix.exs" }, { upward = true, limit = 2, path = fname })
  local child_or_root_path, maybe_umbrella_path = unpack(matches)

  return vim.fs.dirname(maybe_umbrella_path or child_or_root_path)
end

local arch = {
  ["arm64"] = "arm64",
  ["aarch64"] = "arm64",
  ["amd64"] = "amd64",
  ["x86-64"] = "amd64",
}

function M.download_nextls(opts)
  opts = opts or {}
  local cache_dir = opts.cache_dir or vim.env.HOME .. "/.cache/elixir-tools/nextls/bin"
  local sys = vim.uv.os_uname()
  local curl = string.format(
    [[curl --fail --silent -L https://github.com/elixir-tools/next-ls/releases/latest/download/next_ls_%s_%s -o %s/nextls]],
    string.lower(sys.sysname),
    arch[string.lower(sys.machine)],
    cache_dir
  )
  vim.fn.mkdir(vim.fn.expand(cache_dir), "p")
  vim.fn.system(curl)

  assert(vim.uv.fs_chmod(cache_dir .. "/nextls", 755), "failed to make nextls executable")

  if not vim.v.shell_error == 0 then
    vim.notify(
      "Failed to fetch the latest release of Next LS from GitHub.\n\n" .. "Using the command `" .. curl .. "`"
    )
  end
end

---@param owner string
---@param repo string
---@param opts? table
---@return string?
function M.latest_release(owner, repo, opts)
  opts = opts or {}
  local github_host = opts.github_host or "api.github.com"
  local cache_dir = opts.cache_dir or "~/.cache/nvim/elixir-tools.nvim/"
  local curl = string.format(
    [[curl --fail --silent -L -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" https://%s/repos/%s/%s/releases/latest]],
    github_host,
    owner,
    repo
  )
  local invocation = vim.fn.system(curl)

  vim.fn.mkdir(vim.fn.expand(cache_dir), "p")

  local latest_version_file = Path:new(vim.fn.expand(cache_dir .. owner .. "-" .. repo .. ".txt")):absolute()

  if vim.v.shell_error == 0 then
    local resp = vim.json.decode(invocation)
    local version = resp and resp.tag_name and resp.tag_name:gsub("^v", "")

    assert(type(version) == "string")

    vim.fn.writefile({ version }, latest_version_file)

    return version
  elseif vim.fn.filereadable(latest_version_file) == 1 then
    return vim.fn.readfile(latest_version_file)[1]
  else
    vim.notify(
      "Failed to fetch the current "
        .. repo
        .. " version from GitHub or the cache.\n"
        .. "You most likely do not have an internet connection / exceeded\n"
        .. "the GitHub rate limit, and have no cached version of the language\n"
        .. "server."
    )

    return nil
  end
end

return M
