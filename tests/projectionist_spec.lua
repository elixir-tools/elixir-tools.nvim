describe("projectionist", function()
  before_each(function()
    local tmp_dir = [[./tmp/fixtures]]
    vim.fn.system([[rm -rf ]] .. tmp_dir)
    vim.fn.system([[mkdir -p ]] .. tmp_dir)
    vim.fn.system([[cp -r tests/fixtures/ ]] .. tmp_dir)
    vim.print(vim.fn.system([[ls tmp]]))
    vim.print("===========")
    vim.print(vim.fn.system([[ls tmp/fixtures]]))
    vim.print("===========")
    vim.print(vim.opt.cdpath:get())
    vim.print("===========")
    vim.cmd.cd(tmp_dir .. "/project_a")
    require("elixir.projectionist").setup()
    vim.cmd.edit("project_a/lib/module.ex")
  end)

  after_each(function()
    vim.cmd.cd("../../../")
  end)

  it("Eview", function()
    vim.cmd.Eview("project_a_web/user")
    vim.cmd.write()

    assert.are.same(
      vim.fn.readfile("lib/project_a_web/views/user_view.ex"),
      { "defmodule ProjectAWeb.UserView do", "  use ProjectAWeb, :view", "end" }
    )
  end)

  it("Econtroller", function()
    vim.cmd.Econtroller("project_a_web/user")
    vim.cmd.write()

    assert.are.same(
      vim.fn.readfile("lib/project_a_web/controllers/user_controller.ex"),
      { "defmodule ProjectAWeb.UserController do", "  use ProjectAWeb, :controller", "end" }
    )
  end)

  it("Ehtml", function()
    vim.cmd.Ehtml("project_a_web/user")
    vim.cmd.write()

    assert.are.same(vim.fn.readfile("lib/project_a_web/controllers/user_html.ex"), {
      "defmodule ProjectAWeb.UserHTML do",
      "  use ProjectAWeb, :html",
      "",
      [[  embed_templates "user_html/*"]],
      "end",
    })
  end)

  it("Ecomponent", function()
    vim.cmd.Ecomponent("project_a_web/user")
    vim.cmd.write()

    assert.are.same(
      vim.fn.readfile("lib/project_a_web/components/user.ex"),
      { "defmodule ProjectAWeb.User do", "  use Phoenix.Component", "end" }
    )
  end)

  it("Eliveview", function()
    vim.cmd.Eliveview("project_a_web/user")
    vim.cmd.write()

    assert.are.same(
      vim.fn.readfile("lib/project_a_web/live/user_live.ex"),
      { "defmodule ProjectAWeb.UserLive do", "  use ProjectAWeb, :live_view", "end" }
    )
  end)
end)
