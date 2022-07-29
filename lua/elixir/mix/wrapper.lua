local mix_exs = require("elixir.mix.exs")

local M = {
	mix_exs_path_cache = nil,
}

local function run_command(cmd)
	local result = vim.fn.system(cmd)
	return result
end

function M.refresh_completions()
	local cmd = "mix help | awk -F ' ' '{printf \"%s\\n\", $2}' | grep -E \"[^-#]\\w+\""
	vim.g.mix_complete_list = run_command(cmd)
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
	local mix_exs_path = M.mix_exs()
	if mix_exs_path then
		cd_cmd = table.concat({ "cd", mix_exs_path, "&&" }, " ")
	end

	local cmd = { cd_cmd, "mix", action, args_as_str }

	return run_command(table.concat(cmd, " "))
end

function M.mix_exs()
	if not M.mix_exs_path_cache then
		local mix_ops = mix_exs.path_mix_exs()
		if mix_ops.file_exists then
			M.mix_exs_path_cache = mix_ops.mix_dir
		end
	end

	return M.mix_exs_path_cache
end

return M
