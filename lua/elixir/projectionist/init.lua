local M = {}
if not vim.g.projectionist_transformations then
  vim.g.projectionist_transformations = vim.empty_dict()
end

ElixirToolsProjectionistElixirModule = function(input)
  return input:gsub("(%.%l)", string.upper)
end

vim.cmd([[
function! g:projectionist_transformations.elixir_module(input, o) abort
  return v:lua.ElixirToolsProjectionistElixirModule(a:input, a:o)
endfunction
]])

local config = {
  ["mix.exs"] = {
    ["lib/**/views/*_view.ex"] = {
      type = "view",
      alternate = "test/{dirname}/views/{basename}_view_test.exs",
      template = {
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}View do",
        "  use {dirname|camelcase|capitalize}, :view",
        "end",
      },
    },
    ["test/**/views/*_view_test.exs"] = {
      type = "test",
      alternate = "lib/{dirname}/views/{basename}_view.ex",
      template = {
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ViewTest do",
        "  use ExUnit.Case, async: true",
        "",
        "  alias {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}View",
        "end",
      },
    },
    ["lib/**/controllers/*_controller.ex"] = {
      type = "controller",
      alternate = "test/{dirname}/controllers/{basename}_controller_test.exs",
      template = {
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Controller do",
        "  use {dirname|camelcase|capitalize}, :controller",
        "end",
      },
    },
    ["test/**/controllers/*_controller_test.exs"] = {
      type = "test",
      alternate = "lib/{dirname}/controllers/{basename}_controller.ex",
      template = {
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ControllerTest do",
        "  use {dirname|camelcase|capitalize}.ConnCase, async: true",
        "end",
      },
    },
    ["lib/**/controllers/*_html.ex"] = {
      type = "html",
      alternate = "test/{dirname}/controllers/{basename}_html_test.exs",
      template = {
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}HTML do",
        "  use {dirname|camelcase|capitalize}, :html",
        "",
        [[  embed_templates "{basename|snakecase}_html/*"]],
        "end",
      },
    },
    ["test/**/controllers/*_html_test.exs"] = {
      type = "test",
      alternate = "lib/{dirname}/controllers/{basename}_html.ex",
      template = {
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}HTMLTest do",
        "  use {dirname|camelcase|capitalize}.ConnCase, async: true",
        "",
        "  alias {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}HTML",
        "end",
      },
    },
    ["lib/**/controllers/*_json.ex"] = {
      type = "json",
      alternate = "test/{dirname}/controllers/{basename}_json_test.exs",
      template = {
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}JSON do",
        "end",
      },
    },
    ["test/**/controllers/*_json_test.exs"] = {
      type = "test",
      alternate = "lib/{dirname}/controllers/{basename}_json.ex",
      template = {
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}JSONTest do",
        "  use {dirname|camelcase|capitalize}.ConnCase, async: true",
        "",
        "  alias {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}JSON",
        "end",
      },
    },
    ["lib/**/components/*.ex"] = {
      type = "component",
      alternate = "test/{dirname}/components/{basename}_test.exs",
      template = {
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize} do",
        "  use Phoenix.Component",
        "end",
      },
    },
    ["test/**/components/*_test.exs"] = {
      type = "test",
      alternate = "lib/{dirname}/components/{basename}.ex",
      template = {
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Test do",
        "  use {dirname|camelcase|capitalize}.ConnCase, async: true",
        "",
        "  alias {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}",
        "end",
      },
    },
    ["lib/**/live/*_component.ex"] = {
      type = "livecomponent",
      alternate = "test/{dirname}/live/{basename}_component_test.exs",
      template = {
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Component do",
        "  use {dirname|camelcase|capitalize}, :live_component",
        "end",
      },
    },
    ["test/**/live/*_component_test.exs"] = {
      type = "test",
      alternate = "lib/{dirname}/live/{basename}_component.ex",
      template = {
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ComponentTest do",
        "  use {dirname|camelcase|capitalize}.ConnCase",
        "",
        "  import Phoenix.LiveViewTest",
        "end",
      },
    },
    ["lib/**/live/*.ex"] = {
      type = "liveview",
      alternate = "test/{dirname}/live/{basename}_test.exs",
      template = {
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize} do",
        "  use {dirname|camelcase|capitalize}, :live_view",
        "end",
      },
    },
    ["test/**/live/*_test.exs"] = {
      type = "test",
      alternate = "lib/{dirname}/live/{basename}.ex",
      template = {
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Test do",
        "  use {dirname|camelcase|capitalize}.ConnCase",
        "",
        "  import Phoenix.LiveViewTest",
        "end",
      },
    },
    ["lib/**/channels/*_channel.ex"] = {
      type = "channel",
      alternate = "test/{dirname}/channels/{basename}_channel_test.exs",
      template = {
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Channel do",
        "  use {dirname|camelcase|capitalize}, :channel",
        "end",
      },
    },
    ["test/**/channels/*_channel_test.exs"] = {
      type = "test",
      alternate = "lib/{dirname}/channels/{basename}_channel.ex",
      template = {
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ChannelTest do",
        "  use {dirname|camelcase|capitalize}.ChannelCase, async: true",
        "",
        "  alias {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Channel",
        "end",
      },
    },
    ["test/**/features/*_test.exs"] = {
      type = "feature",
      template = {
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Test do",
        "  use {dirname|camelcase|capitalize}.FeatureCase, async: true",
        "end",
      },
    },
    ["lib/*.ex"] = {
      type = "source",
      alternate = "test/{}_test.exs",
      template = { "defmodule {camelcase|capitalize|dot} do", "end" },
    },
    ["test/*_test.exs"] = {
      type = "test",
      alternate = "lib/{}.ex",
      template = {
        "defmodule {camelcase|capitalize|dot|elixir_module}Test do",
        "  use ExUnit.Case, async: true",
        "",
        "  alias {camelcase|capitalize|dot|elixir_module}",
        "end",
      },
    },
    ["lib/mix/tasks/*.ex"] = {
      type = "task",
      alternate = "test/mix/tasks/{}_test.exs",
      template = {
        "defmodule Mix.Tasks.{camelcase|capitalize|dot|elixir_module} do",
        [[  use Mix.Task]],
        "",
        [[  @shortdoc "{}"]],
        "",
        [[  @moduledoc """]],
        [[  {}]],
        [[  """]],
        "",
        [[  @impl true]],
        [[  @doc false]],
        [[  def run(argv) do]],
        "",
        [[  end]],
        "end",
      },
    },
  },
}

function M.setup()
  local new_heuristics
  if vim.g.projectionist_heuristics then
    new_heuristics = vim.tbl_deep_extend("keep", vim.g.projectionist_heuristics, config)
  else
    new_heuristics = config
  end

  vim.g.projectionist_heuristics = new_heuristics
end

return M
