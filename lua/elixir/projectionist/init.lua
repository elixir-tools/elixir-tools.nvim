local M = {}

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
        "  embed_templates {basename|snake_case}_html/*",
        "end",
      },
    },
    ["test/**/controllers/*_html_test.exs"] = {
      type = "test",
      alternate = "lib/{dirname}/controllers/{basename}_html.ex",
      template = {
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}ControllerTest do",
        "  use {dirname|camelcase|capitalize}.ConnCase, async: true",
        "",
        "  alias {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}HTML",
        "end",
      },
    },
    ["lib/**/live/*_live.ex"] = {
      type = "liveview",
      alternate = "test/{dirname}/live/{basename}_live_test.exs",
      template = {
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}Live do",
        "  use {dirname|camelcase|capitalize}, :live_view",
        "end",
      },
    },
    ["test/**/live/*_live_test.exs"] = {
      type = "test",
      alternate = "lib/{dirname}/live/{basename}_live.ex",
      template = {
        "defmodule {dirname|camelcase|capitalize}.{basename|camelcase|capitalize}LiveTest do",
        "  use {dirname|camelcase|capitalize}.ConnCase, async: true",
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
        "defmodule {camelcase|capitalize|dot}Test do",
        "  use ExUnit.Case, async: true",
        "",
        "  alias {camelcase|capitalize|dot}",
        "end",
      },
    },
  },
}

function M.setup()
  local new_heuristics
  if vim.g.projectionist_heuristics then
    new_heuristics = vim.tbl_extend("force", vim.g.projectionist_heuristics, config)
  else
    new_heuristics = config
  end

  vim.g.projectionist_heuristics = new_heuristics
end

return M
