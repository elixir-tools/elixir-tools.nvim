local eq = assert.are.same
local shell = vim.fn.system
local curl = require("plenary.curl")
local elixir = require("elixir")

describe("elixir", function()
	describe("cmd", function()
		after_each(function()
			shell("rm -rf tmp/fake_install")
		end)

		it("returns false when it's not installed", function()
			local install_path = "tmp/fake_install"
			local result = elixir.command({ path = install_path, version = "foobarbaz" })

			assert.False(result:exists())
		end)

		it("returns true when it is installed", function()
			local install_path = "tmp/fake_install"
			shell("mkdir -p tmp/fake_install/foobarbaz/release")
			shell("touch tmp/fake_install/foobarbaz/release/language_server.sh")

			local result = elixir.command({ path = install_path, version = "foobarbaz" })

			assert.True(result:exists())
		end)
	end)
end)
