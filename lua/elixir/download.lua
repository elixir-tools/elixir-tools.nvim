local curl = require("plenary.curl")
local Path = require("plenary.path")
local Job = require("plenary.job")

local Utils = require("elixir.utils")

local M = {}

function M.stable(dir)
	vim.notify("Downloading ElixirLS")
	local made_path = Path:new(dir):mkdir({ parents = true, mode = 493 })
	assert(made_path)
	local loc = dir .. "/elixir-ls.tar.gz"
	local res = curl.get("https://github.com/elixir-lsp/elixir-ls/archive/refs/tags/v0.9.0.tar.gz", {
		output = loc,
	})

	if not res.status == 200 then
		return "Fail"
	end

	vim.fn.system("tar -xvf " .. loc .. " -C " .. dir)

	vim.notify("Downloaded ElixirLS!")

	return "elixir-ls-0.9.0"
end

function M.clone(dir, opts)
	opts = opts or {}
	local dir_identifier = Utils.repo_path(opts.repo, opts.ref)

	vim.notify(string.format("Cloning ref %s from repo %s", opts.ref or "default", opts.repo))

	local made_path = Path:new(dir):mkdir({ parents = true, mode = 493 })
	assert(made_path, "failed to make the path")

	local clone = Job:new({
		command = "git",
		args = { "-C", dir, "clone", string.format("https://github.com/%s.git", opts.repo), dir_identifier },
    enable_recording = true
	})

	clone:sync()

	assert(clone.code == 0, "Failed to clone")

	if opts.ref then
		local checkout = Job:new({
			command = "git",
			args = { "-C", Path:new(dir, dir_identifier).filename, "checkout", opts.ref },
		})
		checkout:sync()

		assert(checkout.code == 0, "Failed to checkout ref " .. opts.ref)
	end

	vim.notify("Downloaded ElixirLS!")

	return dir_identifier
end

return M
