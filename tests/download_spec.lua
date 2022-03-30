local Path = require("plenary.path")
local eq = assert.are.same
local Download = require("elixir.download")
vim.notify = function(thing)
	io.stdout:write(thing .. "\n")
end

describe("download", function()
	before_each(function()
		vim.fn.system([[rm -rf tmp/downloads]])

		assert(not Path:new("tmp/downloads"):exists(), "tmp/downloads was not deleted")
	end)

	it("can downloads the stable tarball of the source code", function()
		local download_dir = "tmp/downloads"

		local result = Download.stable(download_dir)

		eq(result, "elixir-ls-0.9.0")
		assert.True(Path:new(download_dir, "elixir-ls-0.9.0", "mix.exs"):exists())
	end)

	it("can git clone HEAD of the source code", function()
		local download_dir = "tmp/downloads"

		local result = Download.clone(download_dir, { repo = "elixir-lsp/elixir-ls" })

		eq("elixir-lsp_elixir-ls-HEAD", result)
		assert.True(Path:new(download_dir, "elixir-lsp_elixir-ls-HEAD", "mix.exs"):exists())
	end)

	it("can clone from a different repository", function()
		local download_dir = "tmp/downloads"

		local result = Download.clone(download_dir, { repo = "mhanberg/elixir-ls" })

		eq("mhanberg_elixir-ls-HEAD", result)
		assert.True(Path:new(download_dir, "mhanberg_elixir-ls-HEAD", "mix.exs"):exists())
	end)

	it("can checkout a different branch", function()
		local download_dir = "tmp/downloads"

		local result = Download.clone(
			download_dir,
			{ repo = "mhanberg/elixir-ls", branch = "mh/all-workspace-symbols" }
		)

		eq("mhanberg_elixir-ls-mh_all-workspace-symbols", result)
		assert.True(Path:new(download_dir, "mhanberg_elixir-ls-mh_all-workspace-symbols", "mix.exs"):exists())
	end)
end)
