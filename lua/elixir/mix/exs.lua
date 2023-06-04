local git = require("elixir.mix.git")

if not vim.uv then
  vim.uv = vim.loop
end

local M = {}

function M.path_mix_exs()
  local git_workdir_path = git.workdir_path()
  local git_mix_exs_path = git.find_file("mix.exs")
  local mix_exs_fullpath = table.concat({ git_workdir_path, git_mix_exs_path }, "/")

  local file_exists = not vim.tbl_isempty(vim.uv.fs_stat(mix_exs_fullpath) or {})
  return {
    mix_file = mix_exs_fullpath,
    mix_dir = vim.fn.fnamemodify(mix_exs_fullpath, ":p:h"),
    file_exists = file_exists,
  }
end

return M
