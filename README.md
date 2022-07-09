# elixir.nvim

`elixir.nvim` provides a nice experience for writing Elixir applications with [Neovim](https://github.com/neovim/neovim).

> Note: This plugin does not provide autocompletion, I recommend using [nvim-cmp](https://github.com/hrsh7th/nvim-cmp).

## Install

Requires 0.7+.

```lua
use({ "mhanberg/elixir.nvim", requires = { "nvim-lua/plenary.nvim" }})
```

## Getting Started

### Minimal Setup

```lua
require("elixir").setup()
```

### Advanced Setup

While the plugin works with a minimal setup, it is much more useful if you add some personal configuration.

```lua
local elixir = require("elixir")

elixir.setup({
  -- specify a repository and branch
  repo = "mhanberg/elixir-ls", -- defaults to elixir-lsp/elixir-ls
  branch = "mh/all-workspace-symbols", -- defaults to nil, just checkouts out the default branch, mutually exclusive with the `tag` option
  tag = "v0.10.0", -- defaults to nil, mutually exclusive with the `branch` option

  -- default settings, use the `settings` function to override settings
  settings = elixir.settings({
    dialyzerEnabled = true,
    fetchDeps = false,
    enableTestLenses = false,
    suggestSpecs = false,
  }),

  on_attach = function(client, bufnr)
    local map_opts = { buffer = true, noremap = true}

    -- run the codelens under the cursor
    vim.keymap.set("n", "<space>r",  vim.lsp.codelens.run, map_opts)
    -- remove the pipe operator
    vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", map_opts)
    -- add the pipe operator
    vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", map_opts)
    vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", map_opts)

    -- standard lsp keybinds
    vim.keymap.set("n", "df", "<cmd>lua vim.lsp.buf.formatting_seq_sync()<cr>", map_opts)
    vim.keymap.set("n", "gd", "<cmd>lua vim.diagnostic.open_float()<cr>", map_opts)
    vim.keymap.set("n", "dt", "<cmd>lua vim.lsp.buf.definition()<cr>", map_opts)
    vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", map_opts)
    vim.keymap.set("n", "gD","<cmd>lua vim.lsp.buf.implementation()<cr>", map_opts)
    vim.keymap.set("n", "1gD","<cmd>lua vim.lsp.buf.type_definition()<cr>", map_opts)
    -- keybinds for fzf-lsp.nvim: https://github.com/gfanto/fzf-lsp.nvim
    -- you could also use telescope.nvim: https://github.com/nvim-telescope/telescope.nvim
    -- there are also core vim.lsp functions that put the same data in the loclist
    vim.keymap.set("n", "gr", ":References<cr>", map_opts)
    vim.keymap.set("n", "g0", ":DocumentSymbols<cr>", map_opts)
    vim.keymap.set("n", "gW", ":WorkspaceSymbols<cr>", map_opts)
    vim.keymap.set("n", "<leader>d", ":Diagnostics<cr>", map_opts)


    -- keybinds for vim-vsnip: https://github.com/hrsh7th/vim-vsnip
    vim.cmd([[imap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']])
    vim.cmd([[smap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']])

    -- update capabilities for nvim-cmp: https://github.com/hrsh7th/nvim-cmp
    require("cmp_nvim_lsp").update_capabilities(capabilities)
  end
})
```

## Features

### Automatic ElixirLS Installation

When a compatible installation of ELixirLS is not found, you will be prompted to install it. The plugin will download the source code to the `.elixir_ls` directory and compile it using the Elixir and OTP versions used by your current project.

Caveat: This assumes you are developing your project locally (outside of something like Docker) and they will be available.

Caveat: This currently downloads the language server into the `.elixir_ls` directory in your repository, but it does install it into `~/.cache` and will re-use it  when needed.

![auto-install-elixirls](https://user-images.githubusercontent.com/5523984/160333851-94d448d9-5c80-458c-aa0d-4c81528dde8f.gif)

### Root Path Detection

`elixir.nvim` should be able to properly set the root directory for umbrella and non-umbrella apps. The nvim-lspconfig project's root detection doesn't properly account for umbrella projects.

### Run Tests

ElixirLS provides a codelens to identify and run your tests. If you configure `enableTestLenses = true` in the settings table, you will see the codelens as virtual text in your editor and can run them with `vim.lsp.codelens.run()`.

![elixir-test-lens](https://user-images.githubusercontent.com/5523984/159722637-ef1586d5-9d47-4e1a-b68b-6a90ad744098.gif)

### Manipulate Pipes

The LS has the ability to convert the expression under the cursor form a normal function call to a "piped" function all (and vice versa).

`:ElixirFromPipe`
`:ElixirToPipe`

![manipulate_pipes](https://user-images.githubusercontent.com/5523984/160508641-cedb6ebf-3ec4-4229-9708-aa360b15a2d5.gif)

### Expand Macro

You can highlight a macro call in visual mode and "expand" the macro, opening a floating window with the results.

`:'<,'>ElixirExpandMacro`

![expand_macro](https://user-images.githubusercontent.com/5523984/162372669-4782baba-1889-4145-8a4f-e3bf13a6450d.gif)

## Restart

You can restart the LS by using the restart command. This is useful if you think the LS has gotten into a weird state. It will send the restart command and then save and reload your current buffer to re-attach the client.

`:ElixirRestart`

### Debugger

TODO: make it work

TODO: gif
