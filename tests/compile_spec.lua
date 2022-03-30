local eq = assert.are.same
local shell = vim.fn.system
local Path = require("plenary.path")
local Compile = require("elixir.compile")

p = function(x)
	io.stdout:write(vim.inspect(x) .. "\n")
	return x
end

describe("compile", function()
	before_each(function()
		if not Path:new("tmp/clones/elixir-ls/mix.exs"):exists() then
			Path:new("tmp/clones"):mkdir({ mode = 493, parents = true })
			vim.fn.system("git -C tmp/clones clone https://github.com/elixir-lsp/elixir-ls.git")
		end
	end)

	it("can compile elixir ls", function()
    print("compiling spec")
		local source_path = "tmp/clones/elixir-ls"
		local install_path = "tmp/installs"
		local job = Compile.compile(source_path, install_path, { repo = "mhanberg/elixir-ls", sync = true })

    local output = vim.fn.system("cd tmp/installs && tree && cd -")

    io.stdout:write(output)

		eq(job.code, 0)
		assert.True(Path:new("tmp/installs/mhanberg_elixir-ls-HEAD/1.13.3-24/language_server.sh"):exists())
	end)
end)
