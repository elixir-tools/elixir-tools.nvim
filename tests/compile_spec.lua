local eq = assert.are.same
local Path = require("plenary.path")
local Compile = require("elixir.elixirls.compile")

local versions = require("elixir.elixirls.version").get()

describe("compile", function()
  before_each(function()
    if not Path:new("tmp/clones/elixir-ls/mix.exs"):exists() then
      Path:new("tmp/clones"):mkdir { mode = 493, parents = true }
      vim.fn.system("git -C tmp/clones clone https://github.com/elixir-lsp/elixir-ls.git")
    end

    vim.fn.system("rm -rf tmp/installs")
    vim.fn.system("mkdir -p tmp/installs")
  end)

  it("can compile elixir ls", function()
    local source_path = "tmp/clones/elixir-ls"
    local install_path = Path:new("tmp/installs/mhanberg/elixir-ls/HEAD", versions):absolute()
    local job = Compile.compile(source_path, install_path, { sync = true })

    eq(job.code, 0)

    assert.True(Path:new("tmp/installs/mhanberg/elixir-ls/HEAD", versions, "language_server.sh"):exists())
  end)
end)
