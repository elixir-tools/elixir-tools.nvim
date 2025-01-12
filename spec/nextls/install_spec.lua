local helpers = require("nvim-test.helpers")
local Screen = require("nvim-test.screen")
local exec_lua = helpers.exec_lua
local luv = vim.loop
local eq = assert.equal

describe("install", function()
  before_each(function()
    helpers.clear()
    helpers.fn.delete("./spec/fixtures/basic/bin", "rf")
    helpers.fn.delete("./spec/fixtures/basic/data", "rf")
    helpers.fn.mkdir("./spec/fixtures/basic/data", "p")
    helpers.fn.mkdir("./spec/fixtures/basic/bin", "p")
    -- Make plugin available
    exec_lua([[vim.opt.rtp:append'.']])
    exec_lua([[vim.opt.rtp:append'./deps/plenary.nvim/']])
  end)

  it("installs nextls when you open an elixir file and nextls isn't downloaded", function()
    helpers.fn.writefile({ "" }, "./spec/fixtures/basic/data/.next-ls-force-update-v1")
    exec_lua([[
    vim.g.next_ls_cache_dir = "./spec/fixtures/basic/bin"
    vim.g.next_ls_data_dir = "./spec/fixtures/basic/data"
    vim.g.next_ls_default_bin = "./spec/fixtures/basic/bin/nextls"
    require("elixir.nextls").setup({auto_update = true, cmd = "./spec/fixtures/basic/bin/nextls" })
    vim.cmd.edit("./spec/fixtures/basic/lib/basic.ex")
    ]])

    eq(luv.fs_stat("./spec/fixtures/basic/bin/nextls").mode, 33523)
  end)

  it("forces an install if the flag is not set", function()
    helpers.fn.mkdir("./spec/fixtures/basic/bin", "p")
    helpers.fn.writefile({ "foobar" }, "./spec/fixtures/basic/bin/nextls")
    exec_lua([[
    vim.g.next_ls_cache_dir = "./spec/fixtures/basic/bin"
    vim.g.next_ls_data_dir = "./spec/fixtures/basic/data"
    vim.g.next_ls_default_bin = "./spec/fixtures/basic/bin/nextls"
    require("elixir.nextls").setup({auto_update = true, cmd = "./spec/fixtures/basic/bin/nextls" })
    vim.cmd.edit("./spec/fixtures/basic/lib/basic.ex")
    ]])

    assert.error(function()
      helpers.fn.readfile("./spec/fixtures/basic/bin/nextls", "b")
    end)
    eq(luv.fs_stat("./spec/fixtures/basic/bin/nextls").mode, 33523)
  end)

  it("doesnt force an install if the flag is set", function()
    helpers.fn.writefile({ "" }, "./spec/fixtures/basic/data/.next-ls-force-update-v1")
    helpers.fn.mkdir("./spec/fixtures/basic/bin", "p")
    helpers.fn.writefile({ "foobar" }, "./spec/fixtures/basic/bin/nextls")
    local screen = Screen.new()
    screen:attach()
    exec_lua([[
    vim.g.next_ls_cache_dir = "./spec/fixtures/basic/bin"
    vim.g.next_ls_data_dir = "./spec/fixtures/basic/data"
    vim.g.next_ls_default_bin = "./spec/fixtures/basic/bin/nextls"
    require("elixir.nextls").setup({auto_update = true, cmd = "./spec/fixtures/basic/bin/nextls" })
    vim.cmd.edit("./spec/fixtures/basic/lib/basic.ex")
    ]])

    helpers.feed("<cr>")
    -- screen:snapshot_util()
    eq(helpers.fn.readfile("./spec/fixtures/basic/bin/nextls", "b")[1], "foobar")
    screen:expect {
      grid = [[
      ^defmodule Basic do                                   |
        def run do                                         |
          Enum.map([:one, :two], &Function.identity/1)     |
        end                                                |
      end                                                  |
      {1:~                                                    }|
      {1:~                                                    }|
      {1:~                                                    }|
      {1:~                                                    }|
      {1:~                                                    }|
      {1:~                                                    }|
      {1:~                                                    }|
      {1:~                                                    }|
                                                           |
    ]],
      attr_ids = {
        [1] = { foreground = Screen.colors.NvimLightGrey4 },
      },
    }
  end)
end)
