deps:
  #!/usr/bin/env bash
  set -euo pipefail
  if [ ! -d "nvim-test" ]; then
    git clone --depth 1 --branch v1.1.1 https://github.com/lewis6991/nvim-test
  fi

init: deps
  #!/usr/bin/env bash
  nvim-test/bin/nvim-test --init

test nvim_version="v0.10.4": init
  #!/usr/bin/env bash
  nvim-test/bin/nvim-test --target_version {{nvim_version}}

format:
  #!/usr/bin/env bash
  stylua .
