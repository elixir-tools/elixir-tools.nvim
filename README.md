# elixir-tools.nvim

[![Discord](https://img.shields.io/badge/Discord-5865F3?style=flat&logo=discord&logoColor=white&link=https://discord.gg/nNDMwTJ8)](https://discord.gg/nNDMwTJ8)

`elixir-tools.nvim` provides a nice experience for writing Elixir applications with [Neovim](https://github.com/neovim/neovim).

> Note: This plugin does not provide autocompletion, I recommend using [nvim-cmp](https://github.com/hrsh7th/nvim-cmp).

## Features

- [ElixirLS](https://github.com/elixir-lsp/elixir-ls) installation and configuration (uses the Neovim built-in LSP client)
- [credo-language-server](https://github.com/elixir-tools/credo-language-server) integration.
- `:Mix` command with autocomplete
- [vim-projectionist](https://github.com/tpope/vim-projectionist) support

## Install

Requires 0.8

### lazy.nvim

```lua
{
  "elixir-tools/elixir-tools.nvim",
  ft = { "elixir", "eex", "heex", "surface" },
  config = function()
    local elixir = require("elixir")
    local elixirls = require("elixir.elixirls")

    elixir.setup {
      credo = {},
      elixirls = {
        enabled = true,
        settings = elixirls.settings {
          dialyzerEnabled = false,
          enableTestLenses = false,
        },
        on_attach = function(client, bufnr)
          -- whatever keybinds you want, see below for more suggestions
          vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
          vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
          vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
        end,
      }
    }
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}
```

### packer.nvim

```lua
use({ "elixir-tools/elixir-tools.nvim", requires = { "nvim-lua/plenary.nvim" }})
```

## Getting Started

### Minimal Setup

The minimal setup will configure both ElixirLS and credo-langauge-server.

```lua
require("elixir").setup()
```

ElixirLS and credo-language-server can be disabled by setting the `enabled` flag in the respective options table.

```lua
require("elixir").setup({
  credo = {enable = false},
  elixirls = {enable = false},
})
```

### Advanced Setup

While the plugin works with a minimal setup, it is much more useful if you add some personal configuration.

Note: For ElixirLS, not specifying the `repo`, `branch`, or `tag` options will default to the latest release.

```lua
local elixir = require("elixir")
local elixirls = require("elixir.elixirls")

elixir.setup {
  credo = {
    cmd = "path/to/credo-language-server",
    on_attach = function(client, bufnr)
      -- custom keybinds
    end
  },
  elixirls = {
    -- specify a repository and branch
    repo = "mhanberg/elixir-ls", -- defaults to elixir-lsp/elixir-ls
    branch = "mh/all-workspace-symbols", -- defaults to nil, just checkouts out the default branch, mutually exclusive with the `tag` option
    tag = "v0.13.0", -- defaults to nil, mutually exclusive with the `branch` option

    -- alternatively, point to an existing elixir-ls installation (optional)
    -- not currently supported by elixirls, but can be a table if you wish to pass other args `{"path/to/elixirls", "--foo"}`
    cmd = "/usr/local/bin/elixir-ls.sh",

    -- default settings, use the `settings` function to override settings
    settings = elixirls.settings {
      dialyzerEnabled = true,
      fetchDeps = false,
      enableTestLenses = false,
      suggestSpecs = false,
    },

    on_attach = function(client, bufnr)
      local map_opts = { buffer = true, noremap = true}

      -- run the codelens under the cursor
      vim.keymap.set("n", "<space>r",  vim.lsp.codelens.run, map_opts)
      -- remove the pipe operator
      vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", map_opts)
      -- add the pipe operator
      vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", map_opts)
      vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", map_opts)

      -- bindings for standard LSP functions.
      vim.keymap.set("n", "<space>df", "<cmd>lua vim.lsp.buf.format()<cr>", map_opts)
      vim.keymap.set("n", "<space>gd", "<cmd>lua vim.diagnostic.open_float()<cr>", map_opts)
      vim.keymap.set("n", "<space>dt", "<cmd>lua vim.lsp.buf.definition()<cr>", map_opts)
      vim.keymap.set("n", "<space>K", "<cmd>lua vim.lsp.buf.hover()<cr>", map_opts)
      vim.keymap.set("n", "<space>gD","<cmd>lua vim.lsp.buf.implementation()<cr>", map_opts)
      vim.keymap.set("n", "<space>1gD","<cmd>lua vim.lsp.buf.type_definition()<cr>", map_opts)
      -- keybinds for fzf-lsp.nvim: https://github.com/gfanto/fzf-lsp.nvim
      -- you could also use telescope.nvim: https://github.com/nvim-telescope/telescope.nvim
      -- there are also core vim.lsp functions that put the same data in the loclist
      vim.keymap.set("n", "<space>gr", ":References<cr>", map_opts)
      vim.keymap.set("n", "<space>g0", ":DocumentSymbols<cr>", map_opts)
      vim.keymap.set("n", "<space>gW", ":WorkspaceSymbols<cr>", map_opts)
      vim.keymap.set("n", "<leader>d", ":Diagnostics<cr>", map_opts)
    end
  }
}
```

## Features

### ElixirLS

#### Automatic Installation

When a compatible installation of ELixirLS is not found, you will be prompted to install it. The plugin will download the source code to the `.elixir_ls` directory and compile it using the Elixir and OTP versions used by your current project.

Caveat: This assumes you are developing your project locally (outside of something like Docker) and they will be available.

Caveat: This currently downloads the language server into the `.elixir_ls` directory in your repository, but it does install it into `~/.cache` and will re-use it when needed.

![auto-install-elixirls](https://user-images.githubusercontent.com/5523984/160333851-94d448d9-5c80-458c-aa0d-4c81528dde8f.gif)

#### Root Path Detection

`elixir-tools.nvim` should be able to properly set the root directory for umbrella and non-umbrella apps. The nvim-lspconfig project's root detection doesn't properly account for umbrella projects.

#### Run Tests

ElixirLS provides a codelens to identify and run your tests. If you configure `enableTestLenses = true` in the settings table, you will see the codelens as virtual text in your editor and can run them with `vim.lsp.codelens.run()`.

![elixir-test-lens](https://user-images.githubusercontent.com/5523984/159722637-ef1586d5-9d47-4e1a-b68b-6a90ad744098.gif)

#### Manipulate Pipes

The LS has the ability to convert the expression under the cursor form a normal function call to a "piped" function all (and vice versa).

`:ElixirFromPipe`
`:ElixirToPipe`

![manipulate_pipes](https://user-images.githubusercontent.com/5523984/160508641-cedb6ebf-3ec4-4229-9708-aa360b15a2d5.gif)

#### Expand Macro

You can highlight a macro call in visual mode and "expand" the macro, opening a floating window with the results.

`:'<,'>ElixirExpandMacro`

![expand_macro](https://user-images.githubusercontent.com/5523984/162372669-4782baba-1889-4145-8a4f-e3bf13a6450d.gif)

#### Restart

You can restart the LS by using the restart command. This is useful if you think the LS has gotten into a weird state. It will send the restart command and then save and reload your current buffer to re-attach the client.

`:ElixirRestart`

#### OutputPanel

You can see the logs for ElixirLS via the output panel. By default opens the buffer in a horizontal split window.

```
:ElixirOutputPanel
:lua require("elixir").open_output_panel()
:lua require("elixir").open_output_panel({ window = "split" })
:lua require("elixir").open_output_panel({ window = "vsplit" })
:lua require("elixir").open_output_panel({ window = "float" })
```

### credo-language-server

> Note: The credo-language-server integration utilizes `Mix.install/2`, so you must be running Elixir >= 1.12

- Uses your project's Credo version.
- Full project diagnostics
- Code Actions

### Mix

You can run any `mix` command in your project, complete with... autocomplete!

`:Mix compile --force`

![elixir-nvim-mix-demo](https://user-images.githubusercontent.com/5523984/181859468-19d47a55-3f63-4af5-8698-4b5dd3459141.gif)

### Projectionist

[vim-projectionist](https://github.com/tpope/vim-projectionist) definitions are provided for:

- Elixir files
- Phoenix Views
- Phoenix Controllers
- Phoenix Channels
- Wallaby/Hound Feature tests
