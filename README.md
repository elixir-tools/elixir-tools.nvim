<!-- panvimdoc-ignore-start -->
# elixir-tools.nvim
<!-- panvimdoc-ignore-end -->

# Overview

[![Discord](https://img.shields.io/badge/Discord-5865F3?style=flat&logo=discord&logoColor=white&link=https://discord.gg/nNDMwTJ8)](https://discord.gg/6XdGnxVA2A)
[![GitHub Discussions](https://img.shields.io/github/discussions/elixir-tools/discussions)](https://github.com/orgs/elixir-tools/discussions)

`elixir-tools.nvim` provides a nice experience for writing Elixir applications with [Neovim](https://github.com/neovim/neovim).

> Note: This plugin does not provide autocompletion, I recommend using [nvim-cmp](https://github.com/hrsh7th/nvim-cmp).

> Note: This plugin does not provide syntax highlighting, I recommend using [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter).

## Features

- [ElixirLS](https://github.com/elixir-lsp/elixir-ls) installation and configuration (uses the Neovim built-in LSP client)
- [credo-language-server](https://github.com/elixir-tools/credo-language-server) integration.
- `:Mix` command with autocomplete
- [vim-projectionist](https://github.com/tpope/vim-projectionist) support

# Install

Requires 0.8

## lazy.nvim

```lua
{
  "elixir-tools/elixir-tools.nvim",
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local elixir = require("elixir")
    local elixirls = require("elixir.elixirls")

    elixir.setup {
      credo = {},
      elixirls = {
        enable = true,
        settings = elixirls.settings {
          dialyzerEnabled = false,
          enableTestLenses = false,
        },
        on_attach = function(client, bufnr)
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

## packer.nvim

```lua
use({ "elixir-tools/elixir-tools.nvim", tag = "stable", requires = { "nvim-lua/plenary.nvim" }})
```

# Getting Started

## Minimal Setup

The minimal setup will configure both ElixirLS and credo-language-server.

```lua
require("elixir").setup()
```

ElixirLS and credo-language-server can be disabled by setting the `enable` flag in the respective options table.

```lua
require("elixir").setup({
  credo = {enable = false},
  elixirls = {enable = false},
})
```

## Advanced Setup

While the plugin works with a minimal setup, it is much more useful if you add some personal configuration.

Note: For ElixirLS, not specifying the `repo`, `branch`, or `tag` options will default to the latest release.

```lua
local elixir = require("elixir")
local elixirls = require("elixir.elixirls")

elixir.setup {
  credo = {
    port = 9000, -- connect via TCP with the given port. mutually exclusive with `cmd`
    cmd = "path/to/credo-language-server", -- path to the executable. mutually exclusive with `port`
    version = "0.1.0-rc.3", -- version of credo-language-server to install and use. defaults to the latest release
    on_attach = function(client, bufnr)
      -- custom keybinds
    end
  },
  elixirls = {
    -- specify a repository and branch
    repo = "mhanberg/elixir-ls", -- defaults to elixir-lsp/elixir-ls
    branch = "mh/all-workspace-symbols", -- defaults to nil, just checkouts out the default branch, mutually exclusive with the `tag` option
    tag = "v0.14.6", -- defaults to nil, mutually exclusive with the `branch` option

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
      vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
      vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
      vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
    end
  }
}
```

# Features

## ElixirLS

### Automatic Installation

When a compatible installation of ELixirLS is not found, you will be prompted to install it. The plugin will download the source code to the `.elixir_ls` directory and compile it using the Elixir and OTP versions used by your current project.

Caveat: This assumes you are developing your project locally (outside of something like Docker) and they will be available.

Caveat: This currently downloads the language server into the `.elixir_ls` directory in your repository, but it does install it into `~/.cache` and will re-use it when needed.

![auto-install-elixirls](https://user-images.githubusercontent.com/5523984/160333851-94d448d9-5c80-458c-aa0d-4c81528dde8f.gif)

### Root Path Detection

`elixir-tools.nvim` should be able to properly set the root directory for umbrella and non-umbrella apps. The nvim-lspconfig project's root detection doesn't properly account for umbrella projects.

### Run Tests

ElixirLS provides a codelens to identify and run your tests. If you configure `enableTestLenses = true` in the settings table, you will see the codelens as virtual text in your editor and can run them with `vim.lsp.codelens.run()`.

![elixir-test-lens](https://user-images.githubusercontent.com/5523984/159722637-ef1586d5-9d47-4e1a-b68b-6a90ad744098.gif)

### Commands

:ElixirFromPipe

: Convert pipe operator to nested expressions.

:ElixirToPipe

: Convert nested expressions to the pipe operator.

![manipulate_pipes](https://user-images.githubusercontent.com/5523984/160508641-cedb6ebf-3ec4-4229-9708-aa360b15a2d5.gif)

:[range]ElixirExpandMacro

: For the given [range], expand any macros and display it in a floating window.

![expand_macro](https://user-images.githubusercontent.com/5523984/162372669-4782baba-1889-4145-8a4f-e3bf13a6450d.gif)

:ElixirRestart

: Restart ElixirLS, you must then reconnect your buffer with `:edit`.

:ElixirOutputPanel

: Open the output panel that displays logs and compiler information from the server.

```lua
require("elixir.elixirls").open_output_panel()
require("elixir.elixirls").open_output_panel({ window = "split" })
require("elixir.elixirls").open_output_panel({ window = "vsplit" })
require("elixir.elixirls").open_output_panel({ window = "float" })
```

## credo-language-server

> Note: The credo-language-server integration utilizes `Mix.install/2`, so you must be running Elixir >= 1.12

- Uses your project's Credo version.
- Full project diagnostics
- Code Actions

## Mix

You can run any `mix` command in your project, complete with... autocomplete!

:Mix {args}

: Run any mix command.

![elixir-nvim-mix-demo](https://user-images.githubusercontent.com/5523984/181859468-19d47a55-3f63-4af5-8698-4b5dd3459141.gif)

## Projectionist

[vim-projectionist](https://github.com/tpope/vim-projectionist) integration!

:Esource {args}

: Create or edit a regular source module.

    ```vim
    Esource my_app/accounts/team
    ```

:Etest {args}

: Create or edit a regular test module.

    ```vim
    Etest my_app/accounts/team
    ```

:Etask {args}

: Create or edit a Mix task module.

    ```vim
    Etask server.start
    ```

:Econtroller {args}

: Create or edit a Phoenix controller module.

    ```vim
    Econtroller my_project_web/users
    ```

:Eview {args}

: Create or edit a Phoenix view module.

    ```vim
    Eview my_project_web/users
    ```

:Ehtml {args}

: Create or edit a Phoenix HTML module.

    ```vim
    Ehtml my_project_web/users
    ```

:Ejson {args}

: Create or edit a Phoenix JSON module.

    ```vim
    Ejson my_project_web/users
    ```

:Ecomponent {args}

: Create or edit a Phoenix.Component module.

    ```vim
    Ecomponent my_project_web/users
    ```

:Eliveview {args}

: Create or edit a Phoenix.LiveView module.

    ```vim
    Eliveview my_project_web/users
    ```

:Elivecomponent {args}

: Create or edit a Phoenix.LiveComponent module.

    ```vim
    Elivecomponent my_project_web/users
    ```

:Echannel {args}

: Create or edit a Phoenix channel module.

:Efeature {args}

: Create or edit a Wallaby test module.
