describe("projectionist", function()
  before_each(function()
    local tmp_dir = [[./tmp/fixtures]]
    vim.fn.system([[rm -rf ]] .. tmp_dir)
    vim.fn.system([[mkdir -p ]] .. tmp_dir)
    vim.fn.system([[cp -R tests/fixtures/. ]] .. tmp_dir)
    vim.cmd.cd(tmp_dir .. "/project_a")
    require("elixir.projectionist").setup()
    vim.cmd.edit("project_a/lib/module.ex")
  end)

  after_each(function()
    vim.cmd.cd("../../../")
    vim.g.projectionist_heuristics = {}
  end)

  it("does not overwrite existing projections", function()
    vim.g.projectionist_heuristics = {
      ["mix.exs"] = {
        ["lib/*_test.ex"] = {
          type = "test",
          alternate = "lib/{}.ex",
        },
      },
    }

    local test_projection_before_setup = vim.g.projectionist_heuristics["mix.exs"]["lib/*_test.ex"]

    require("elixir.projectionist").setup()

    local test_projection_after_setup = vim.g.projectionist_heuristics["mix.exs"]["lib/*_test.ex"]

    -- existing projections not overwritten
    assert.are.same(test_projection_before_setup, test_projection_after_setup)

    -- new projections added
    assert.not_nil(vim.g.projectionist_heuristics["mix.exs"]["lib/*.ex"])
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

  it("Ejson", function()
    vim.cmd.Ejson("project_a_web/user")
    vim.cmd.write()

    assert.are.same(
      vim.fn.readfile("lib/project_a_web/controllers/user_json.ex"),
      { "defmodule ProjectAWeb.UserJSON do", "end" }
    )
  end)

  it("Ecomponent", function()
    vim.cmd.Ecomponent("project_a_web/user")
    vim.cmd.write()

    assert.are.same(
      vim.fn.readfile("lib/project_a_web/components/user.ex"),
      { "defmodule ProjectAWeb.User do", "  use Phoenix.Component", "end" }
    )
  end)

  describe("Eliveview", function()
    it("root path", function()
      vim.cmd.Eliveview("project_a_web/user_live")
      vim.cmd.write()

      assert.are.same(
        vim.fn.readfile("lib/project_a_web/live/user_live.ex"),
        { "defmodule ProjectAWeb.UserLive do", "  use ProjectAWeb, :live_view", "end" }
      )
    end)

    -- TODO: i think we need a more specific projection transformer here to convert
    -- `project_a_web/user_live_index` into the correct module name.
    pending("with action", function()
      vim.cmd.Eliveview("project_a_web/user_live/index")
      vim.cmd.write()

      assert.are.same(
        vim.fn.readfile("lib/project_a_web/live/user_live/index.ex"),
        { "defmodule ProjectAWeb.UserLive.Index do", "  use ProjectAWeb, :live_view", "end" }
      )
    end)
  end)

  it("Elivecomponent", function()
    vim.cmd.Elivecomponent("project_a_web/user")
    vim.cmd.write()

    assert.are.same(
      vim.fn.readfile("lib/project_a_web/live/user_component.ex"),
      { "defmodule ProjectAWeb.UserComponent do", "  use ProjectAWeb, :live_component", "end" }
    )
  end)

  it("Etask", function()
    vim.cmd.Etask("foo.bar")
    vim.cmd.write()

    assert.are.same(vim.fn.readfile("lib/mix/tasks/foo.bar.ex"), {
      "defmodule Mix.Tasks.Foo.Bar do",
      [[  use Mix.Task]],
      "",
      [[  @shortdoc "foo.bar"]],
      "",
      [[  @moduledoc """]],
      [[  foo.bar]],
      [[  """]],
      "",
      [[  @impl true]],
      [[  @doc false]],
      [[  def run(argv) do]],
      "",
      [[  end]],
      "end",
    })

    vim.cmd([[call feedkeys("1\<cr>", "t") | A | write]])

    assert.are.same(vim.fn.readfile("test/mix/tasks/foo.bar_test.exs"), {
      "defmodule Mix.Tasks.Foo.BarTest do",
      [[  use ExUnit.Case, async: true]],
      "",
      [[  alias Mix.Tasks.Foo.Bar]],
      "end",
    })
  end)
end)
