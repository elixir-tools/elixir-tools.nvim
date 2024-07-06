deps:
  #!/usr/bin/env bash
  set -euo pipefail
  mkdir -p deps
  if [ ! -d "deps/plenary.nvim" ]; then
    git -C deps clone https://github.com/nvim-lua/plenary.nvim
  fi
  if [ ! -d "nvim-test" ]; then
    git clone https://github.com/lewis6991/nvim-test
  fi

init: deps
  #!/usr/bin/env bash
  nvim-test/bin/nvim-test --init

test nvim_version="v0.9.5": init
  #!/usr/bin/env bash
  nvim-test/bin/nvim-test --target_version {{nvim_version}} busted --lpath="$PWD/lua/?.lua"

format:
  #!/usr/bin/env bash
  stylua .
