local root_dir = vim.fn.getcwd()
local utils = require("elixir.utils")

describe("utils", function()
  after_each(function()
    vim.api.nvim_command("cd " .. root_dir)
  end)

  describe("root_dir", function()
    it("finds elixir project root dir without a filename", function()
      local project_dir = root_dir .. "/tests/fixtures/project_a"

      vim.api.nvim_command("cd " .. project_dir)
      local result = utils.root_dir()

      assert.are.equal(project_dir, result)
    end)

    it("finds elixir project root dir", function()
      local project_dir = root_dir .. "/tests/fixtures/project_a"
      local result = utils.root_dir(project_dir .. "/lib/module.ex")

      assert.are.equal(project_dir, result)
    end)

    it("finds elixir umbrella project root dir", function()
      local project_dir = root_dir .. "/tests/fixtures/project_b"
      local result = utils.root_dir(project_dir .. "/apps/app_a/lib/module.ex")

      assert.are.equal(project_dir, result)
    end)

    it("returns nil if no elixir project root dir is found", function()
      local result = utils.root_dir()

      assert.are.equal(nil, result)
    end)
  end)

  describe("latest_release", function()
    before_each(function()
      vim.fn.delete("./tmp/version-cache", "rf")
    end)

    it("returns the latest release for the repo", function()
      local result = utils.latest_release("elixir-tools", "next-ls", { cache_dir = "./tmp/version-cache/" })

      assert(type(result) == "string")
      assert.is.Truthy(string.match(result, "%d+%.%d+%.%d+"))
    end)

    it("returns nil if the command has a non zero exit code and no file in cache", function()
      vim.fn.delete("./tmp/elixir-tools-next-ls.txt")
      local result = utils.latest_release(
        "elixir-tools",
        "next-ls",
        { github_host = "localhost:9999", cache_dir = "./tmp/version-cache/" }
      )

      assert.is.Nil(result)
    end)

    it("returns nil if the command has a non zero exit code and no file in cache", function()
      vim.fn.mkdir("./tmp/version-cache", "p")
      vim.fn.writefile({ "0.2.2" }, "./tmp/version-cache/elixir-tools-next-ls.txt")
      local result = utils.latest_release(
        "elixir-tools",
        "next-ls",
        { github_host = "localhost:9999", cache_dir = "./tmp/version-cache/" }
      )

      assert.are.same(result, "0.2.2")
    end)
  end)
end)
