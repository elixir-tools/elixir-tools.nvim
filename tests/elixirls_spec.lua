local shell = vim.fn.system
local elixirls = require("elixir.elixirls")

describe("elixir", function()
  describe("command", function()
    after_each(function()
      shell("rm -rf tmp/fake_install")
    end)

    it("returns false when it's not installed", function()
      local install_path = "tmp/fake_install"
      local result = elixirls.command {
        path = install_path,
        repo = "foo/biz",
        ref = "bar/baz",
        versions = "foobarbaz",
      }

      assert.are.same("tmp/fake_install/foo/biz/bar_baz/foobarbaz/language_server.sh", tostring(result))
      assert.False(result:exists())
    end)

    it("returns true when it is installed", function()
      local install_path = "tmp/fake_install"
      shell("mkdir -p tmp/fake_install/foo/biz/bar_baz/foobarbaz")
      shell("touch tmp/fake_install/foo/biz/bar_baz/foobarbaz/language_server.sh")

      local result = elixirls.command {
        path = install_path,
        repo = "foo/biz",
        ref = "bar/baz",
        versions = "foobarbaz",
      }

      assert.True(result:exists())
    end)
  end)
end)
