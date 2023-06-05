local Path = require("plenary.path")
local eq = assert.are.same
local Download = require("elixir.elixirls.download")
vim.notify = function(thing)
  io.stdout:write(thing .. "\n")
end

describe("download", function()
  before_each(function()
    vim.fn.system([[rm -rf tmp/downloads]])

    assert(not Path:new("tmp/downloads"):exists(), "tmp/downloads was not deleted")
  end)

  it("can git clone HEAD of the source code", function()
    local download_dir = "tmp/downloads"

    local result = Download.clone(download_dir, { repo = "elixir-lsp/elixir-ls", ref = "HEAD" })

    eq("elixir-lsp/elixir-ls/HEAD", result)
    assert.True(Path:new(download_dir, "elixir-lsp/elixir-ls/HEAD", "mix.exs"):exists())
  end)

  it("can clone from a different repository", function()
    local download_dir = "tmp/downloads"

    local result = Download.clone(download_dir, { repo = "mhanberg/elixir-ls", ref = "HEAD" })

    eq("mhanberg/elixir-ls/HEAD", result)
    assert.True(Path:new(download_dir, "mhanberg/elixir-ls/HEAD", "mix.exs"):exists())
  end)

  it("can checkout a different branch", function()
    local download_dir = "tmp/downloads"

    local result =
      Download.clone(download_dir, { repo = "mhanberg/elixir-ls", ref = "mh/all-workspace-symbols" })

    eq("mhanberg/elixir-ls/mh_all-workspace-symbols", result)
    assert.True(Path:new(download_dir, "mhanberg/elixir-ls/mh_all-workspace-symbols", "mix.exs"):exists())
  end)

  it("can checkout a different tag", function()
    local download_dir = "tmp/downloads"

    local result = Download.clone(download_dir, { repo = "elixir-lsp/elixir-ls", ref = "tags/v0.14.6" })

    eq("elixir-lsp/elixir-ls/tags_v0.14.6", result)
    assert.True(Path:new(download_dir, "elixir-lsp/elixir-ls/tags_v0.14.6", "mix.exs"):exists())
  end)
end)
