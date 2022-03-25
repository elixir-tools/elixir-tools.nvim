local eq = assert.are.same
local shell = vim.fn.system
local curl = require("plenary.curl")
local Path = require("plenary.path")
local elixir = require("elixir")

describe("elixirls", function()
	before_each(function()
		Path:new("tmp/downloads"):rmdir()
		Path:new("tmp/installs"):rmdir()
	end)

	it("can download the elixir ls source code", function()
		local download_dir = "tmp/downloads"

		local err = elixir.download_ls(download_dir)

		eq(err, nil)
		assert.True(Path:new(download_dir, "elixir-ls-0.9.0/mix.exs"):exists())
	end)

	it("can compile elixir ls", function()
		local source_path = "tmp/downloads"
		local err = elixir.download_ls(source_path)
		assert.Nil(err)

		local source_path = "tmp/downloads/elixir-ls-0.9.0"
		local install_path = "tmp/installs"
		local job = elixir.compile_ls(source_path, install_path, { sync = true })

		eq(job.code, 0)
		assert.True(Path:new("tmp/installs/1.13.3-24/language_server.sh"):exists())
	end)
end)
