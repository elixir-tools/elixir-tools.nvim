local Version = require("elixir.language_server.version")
local Path = require("plenary.path")
local Job = require("plenary.job")
local Utils = require("elixir.utils")

local __file = Path:new(debug.getinfo(1, "S").source:match("@(.*)$"))
assert(__file:exists())
local bin_dir = __file:parent():parent():parent():joinpath("bin")
local bin = { compile = tostring(bin_dir:joinpath("compile")) }

local M = {}

local p = function(x)
	io.stdout:write(x .. "\n")
	return x
end

function M.compile(source_path, install_path, opts)
	local do_sync = opts.sync or false
	local v = Version.get()

	local printer = function(err, line)
		if opts.bufnr then
			vim.api.nvim_buf_set_lines(opts.bufnr, -1, -1, false, { line })
			vim.api.nvim_buf_call(opts.bufnr, function()
				vim.api.nvim_command("normal G")
			end)
		else
			if err then
				p(err)
			else
				p(line)
			end
		end
	end

	local compile = Job:new({
		command = bin.compile,
		args = { install_path },
		cwd = source_path,
		on_start = function()
			vim.notify("Compiling ElixirLS...")
		end,
		on_stdout = do_sync and printer or vim.schedule_wrap(printer),
		on_stderr = do_sync and printer or vim.schedule_wrap(printer),
		on_exit = vim.schedule_wrap(function(_, code)
			if code == 0 then
				if opts.bufnr then
					vim.api.nvim_buf_call(opts.bufnr, function()
						vim.api.nvim_command("quit")
					end)
				end

				vim.notify("Finished compiling ElixirLS!")
				vim.notify("Reloading buffer")
				vim.api.nvim_command("edit")
				vim.notify("Restarting LSP client")
				vim.api.nvim_command("LspRestart")
			end
		end),
	})

	-- sync is just for testing
	if do_sync then
		compile:sync(60000)
	else
		compile:start()
	end

	return compile
end
return M
