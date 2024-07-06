<!-- panvimdoc-ignore-start -->
# elixir-tools.nvim
<!-- panvimdoc-ignore-end -->

# Overview

[![Discord](https://img.shields.io/badge/Discord-5865F3?style=flat&logo=discord&logoColor=white&link=https://discord.gg/nNDMwTJ8)](https://discord.gg/6XdGnxVA2A)
[![GitHub Discussions](https://img.shields.io/github/discussions/elixir-tools/discussions)](https://github.com/orgs/elixir-tools/discussions)

`elixir-tools.nvim` provides a nice experience for writing Elixir applications with [Neovim](https://github.com/neovim/neovim).

> **Note**
> This plugin does not provide autocompletion, I recommend using [nvim-cmp](https://github.com/hrsh7th/nvim-cmp).

> **Note**
> This plugin does not provide syntax highlighting, I recommend using [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter).

## Features

- [Next LS](https://github.com/elixir-tools/next-ls) installation and configuration.
- [ElixirLS](https://github.com/elixir-lsp/elixir-ls) installation and configuration.
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
      nextls = {enable = true},
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
      },
      projectionist = {
        enable = true
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

The minimal setup will configure both ElixirLS but not Next LS.

```lua
require("elixir").setup()
```

Next LS, ElixirLS, and Projectionist can be enabled/disabled by setting the `enable` flag in the respective options table.

The defaults are shown below.

```lua
require("elixir").setup({
  nextls = {enable = false},
  elixirls = {enable = true},
  projectionist = {enable = true},
})
```

## Advanced Setup

While the plugin works with a minimal setup, it is much more useful if you add some personal configuration.

> **Note**
> For ElixirLS, not specifying the `repo`, `branch`, or `tag` options will default to the latest release.

```lua
local elixir = require("elixir")
local elixirls = require("elixir.elixirls")

elixir.setup {
  nextls = {
    enable = false, -- defaults to false
    port = 9000, -- connect via TCP with the given port. mutually exclusive with `cmd`. defaults to nil
    cmd = "path/to/next-ls", -- path to the executable. mutually exclusive with `port`
    init_options = {
      mix_env = "dev",
      mix_target = "host",
      experimental = {
        completions = {
          enable = false -- control if completions are enabled. defaults to false
        }
      }
    },
    on_attach = function(client, bufnr)
      -- custom keybinds
    end
  },
  ,
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

## Commands

:Elixir {command} [{subcommand}]

: The main elixir-tools command

      ```vim
      :Elixir nextls uninstall
      ```
### Full List

| Command | Subcommand     | Description                                                                                          |
|---------|----------------|------------------------------------------------------------------------------------------------------|
| nextls  | alias-refactor | Aliases the module under the cursor, refactoring similar calls as well                                |
| nextls  | to-pipe        | Extracts the first argument to a pipe call                                                           |
| nextls  | from-pipe      | Inlines the pipe call to a function call inlining the first argument                                 |
| nextls  | uninstall      | Removes the `nextls` executable from the default location: `~/.cache/elixir-tools/nextls/bin/nextls` |

## Next LS

> **Note**
> Next LS is **disabled** by default. Once it reaches feature parity with ElixirLS, it will switch to enabled by default.

> **Note**
> Next LS creates a `.elixir-tools` directory in your project root, but it's automatically ignored by git.

The language server for Elixir that just works. 😎

You can read more about it at https://www.elixir-tools.dev/next-ls.

### Automatic Installation

Next LS is distributed as pre-compiled binaries, which are available from the Next LS GitHub releases page. elixir-tools.nvim will prompt you to install it if it is not found, and then
will consequently download it from GitHub.

If you are using a package manager like [Mason](https://github.com/williamboman/mason.nvim), you can set the `cmd` property of the `nextls` setup table
and it will not prompt you to install and use it from there.

### Commands

Next LS command are available as subcommands of the `:Elixir` command

## ElixirLS

### Automatic Installation

When a compatible installation of ElixirLS is not found, you will be prompted to install it. The plugin will download the source code to the `.elixir_ls` directory and compile it using the Elixir and OTP versions used by your current project.

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

## Contributing

### Setup

elixir-tools.nvim uses a combination of [Nix](https://nixos.org) and [just](https://github.com/casey/just) to provide the development tooling, but you can also install all of this manually.

#### Nix + just

```bash
# enter a nix shell, provides language deps and just
$ nix develop

# install test runner and plugin dependencies
$ just init

# run tests, optionally include the Neovim version to test
$ just test
$ just test 0.8.3

# format the code
$ just format
```

#### Manually

Install the following software:

- [Neovim](https://neovim.io)
- [Lua 5.1](https://sourceforge.net/projects/luabinaries/files/5.1.5/)
- [Luarocks](https://github.com/luarocks/luarocks/wiki/Download)
- [nvim-test](https://github.com/lewis6991/nvim-test)
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) (into the folder "deps")
- [stylua](https://github.com/JohnnyMorganz/StyLua)

To run the tests, you can reference the commands run in the justfile
