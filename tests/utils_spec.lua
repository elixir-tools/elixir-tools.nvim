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
end)

