local mix_exs = require("elixir.mix.exs")
local utils = require("elixir.utils")

local M = {
  mix_exs_path_cache = nil,
}

function M.refresh_completions()
  local cmd = "mix help | awk -F ' ' '{printf \"%s\\n\", $2}' | grep -E \"[^-#]\\w+\""

  vim.g.mix_complete_list = vim.fn.system(cmd)
end

function M.load_completions(cli_input)
  local l = #(vim.split(cli_input, " "))

  -- Don't print if command already selected
  if l > 2 then
    return ""
  end

  -- Use cache if list has been already loaded
  if vim.g.mix_complete_list then
    return vim.g.mix_complete_list
  end

  M.refresh_completions()

  return vim.g.mix_complete_list
end

function M.run(action, args)
  local args_as_str = table.concat(args, " ")

  local cd_cmd = ""
  local mix_exs_path = utils.root_dir(vim.fn.expand("%:p"))

  if mix_exs_path then
    cd_cmd = table.concat({ "cd", mix_exs_path, "&&" }, " ")
  end

  local cmd = { cd_cmd, "mix", action, args_as_str }

  return vim.fn.system(table.concat(cmd, " "))
end

return M
