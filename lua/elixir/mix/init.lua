local mix = require("elixir.mix.wrapper")

local create_user_command = vim.api.nvim_create_user_command

local M = {}

function __Elixir_Mix_complete(_, line, _)
  return mix.load_completions(line)
end

function M.commands()
  for _, cmd in pairs { "M", "Mix" } do
    create_user_command(cmd, function(opts)
      M.load_command(opts.line1, opts.line2, opts.count, unpack(opts.fargs))
    end, { range = true, nargs = "*", complete = "custom,v:lua.__Elixir_Mix_complete" })
  end
end

function M.run(opts)
  local action = opts.cmd
  local args = opts.args

  local result = mix.run(action, args)
  print(result)
end

function M.load_command(start_line, end_line, count, cmd, ...)
  local args = { ... }

  if not cmd then
    return
  end

  local user_opts = {
    start_line = start_line,
    end_line = end_line,
    count = count,
    cmd = cmd,
    args = args,
  }

  M.run(user_opts)
end

function M.setup()
  M.commands()
end

return M
