local M = {}

local function run_command(cmd)
  return vim.fn.system(table.concat(cmd, " "))
end

function M.workdir_path()
  local output = run_command {
    "git",
    "worktree",
    "list",
    "|",
    "awk",
    "-F",
    "' '",
    "'{ print $1 }'",
  }
  return vim.fn.trim(output)
end

function M.find_file(filename)
  local output = run_command {
    "git",
    "ls-tree",
    "--full-tree",
    "-r",
    "--full-name",
    "--name-only",
    "HEAD",
    "|",
    "grep",
    filename,
  }
  return vim.fn.trim(output)
end

return M
