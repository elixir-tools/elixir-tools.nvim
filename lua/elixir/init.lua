local uv = vim.loop

local lspconfig = require("lspconfig")
local lsputil = require("lspconfig.util")

local Job = require("plenary.job")
local Path = require("plenary.path")
local popup = require("plenary.popup")

local versions = require("elixir.version")

local __file = Path:new(debug.getinfo(1, "S").source:match("@(.*)$"))
assert(__file:exists())
local bin_dir = __file:parent():parent():parent():joinpath("bin")
local bin = { compile = tostring(bin_dir:joinpath("compile")) }

local default_config = require("lspconfig.server_configurations.elixirls").default_config
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local M = {}

local get_cursor_position = function()
	local rowcol = vim.api.nvim_win_get_cursor(0)
	local row = rowcol[1] - 1
	local col = rowcol[2]

	return row, col
end

function M.floater()
	local columns = vim.o.columns
	local lines = vim.o.lines
	local width = math.ceil(columns * 0.8)
	local height = math.ceil(lines * 0.8 - 4)
	-- local left = math.ceil((columns - width) * 0.5)
	-- local top = math.ceil((lines - height) * 0.5 - 1)

	local bufnr = vim.api.nvim_create_buf(false, true)
	local win_id = popup.create(bufnr, {
		line = 0,
		col = 0,
		minwidth = width,
		minheight = height,
		border = {},
		padding = { 2, 2, 2, 2 },
	})

	return bufnr
end

local manipulate_pipes = function(direction, client)
	local row, col = get_cursor_position()

	client.request_sync("workspace/executeCommand", {
		command = "manipulatePipes:serverid",
		arguments = { direction, "file://" .. vim.api.nvim_buf_get_name(0), row, col },
	}, nil, 0)
end

function M.from_pipe(client)
	return function()
		manipulate_pipes("fromPipe", client)
	end
end

function M.to_pipe(client)
	return function()
		manipulate_pipes("toPipe", client)
	end
end

local nil_buf_id = 999999
local term_buf_id = nil_buf_id

local function test(command)
	local row, col = get_cursor_position()
	local args = command.arguments[1]
	local current_buf_id = vim.api.nvim_get_current_buf()

	-- delete the current buffer if it's still open
	if vim.api.nvim_buf_is_valid(term_buf_id) then
		vim.api.nvim_buf_delete(term_buf_id, { force = true })
		term_buf_id = nil_buf_id
	end

	vim.cmd("botright new | lua vim.api.nvim_win_set_height(0, 15)")
	term_buf_id = vim.api.nvim_get_current_buf()
	vim.opt_local.number = false
	vim.opt_local.cursorline = false

	local cmd = "mix test " .. args.filePath

	-- add the line number if it's for a specific describe/test block
	if args.describe or args.testName then
		cmd = cmd .. ":" .. (row + 1)
	end

	vim.fn.termopen(cmd, {
		on_exit = function(_jobid, exit_code, _event)
			if exit_code == 0 then
				vim.api.nvim_buf_delete(term_buf_id, { force = true })
				term_buf_id = nil_buf_id
				vim.notify("Success: " .. cmd, vim.log.levels.INFO)
			else
				vim.notify("Fail: " .. cmd, vim.log.levels.ERROR)
			end
		end,
	})

	vim.cmd([[wincmd p]])
end

local root_dir = function(fname)
	local path = lsputil.path
	local child_or_root_path = lsputil.root_pattern({ "mix.exs", ".git" })(fname)
	local maybe_umbrella_path = lsputil.root_pattern({ "mix.exs" })(
		uv.fs_realpath(path.join({ child_or_root_path, ".." }))
	)

	local has_ancestral_mix_exs_path = vim.startswith(child_or_root_path, path.join({ maybe_umbrella_path, "apps" }))
	if maybe_umbrella_path and not has_ancestral_mix_exs_path then
		maybe_umbrella_path = nil
	end

	local path = maybe_umbrella_path or child_or_root_path or vim.loop.os_homedir()

	return path
end

M.settings = function(opts)
	return {
		elixirLS = vim.tbl_extend("force", {
			dialyzerEnabled = true,
			fetchDeps = false,
			enableTestLenses = false,
			suggestSpecs = false,
		}, opts),
	}
end

function M.command(params)
	local install_path = Path:new(params.path, params.versions, "language_server.sh")

	return install_path
end

local on_attach = function(client, bufnr)
	vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
		buffer = bufnr,
		callback = vim.lsp.codelens.refresh,
	})
	vim.lsp.codelens.refresh()
end

local cache_dir = Path:new(vim.fn.getcwd(), ".elixir_ls", "elixir.nvim")
local download_dir = cache_dir:joinpath("downloads")
local install_dir = cache_dir:joinpath("installs")

function M.setup(opts)
	lspconfig.elixirls.setup(vim.tbl_extend("keep", {
		on_init = lsputil.add_hook_after(default_config.on_init, function(client)
			client.commands["elixir.lens.test.run"] = test
		end),
		on_new_config = function(new_config, new_root_dir)
			local cmd = M.command({ path = tostring(install_dir), versions = versions.versions() })

			if not cmd:exists() then
				vim.ui.select({ "Yes", "No" }, { prompt = "Install ElixirLS" }, function(choice)
					if choice == "Yes" then
						M.download_ls(tostring(download_dir:absolute()))
						local bufnr = M.floater()
						local result = M.compile_ls(
							tostring(download_dir:joinpath("elixir-ls-0.9.0"):absolute()),
							tostring(install_dir:absolute()),
							{ bufnr = bufnr }
						)
					end
				end)
			else
				local updated_config = new_config
				updated_config.cmd = { tostring(cmd) }

				return updated_config
			end
		end,
		settings = opts.settings or settings,
		capabilities = opts.capabilities or capabilities,
		root_dir = opts.root_dir or root_dir,
		on_attach = lsputil.add_hook_before(opts.on_attach, on_attach),
	}, opts))
end

local curl = require("plenary.curl")
function M.download_ls(dir)
	vim.notify("Downloading ElixirLS")
	local made_path = Path:new(dir):mkdir({ parents = true, mode = 493 })
	assert(made_path)
	local loc = dir .. "/elixir-ls.tar.gz"
	local res = curl.get("https://github.com/elixir-lsp/elixir-ls/archive/refs/tags/v0.9.0.tar.gz", {
		output = loc,
	})

	if not res.status == 200 then
		return "Fail"
	end

	vim.fn.system("tar -xvf " .. loc .. " -C " .. dir)

	vim.notify("Downloaded ElixirLS!")

	return nil
end

function M.compile_ls(source_path, install_path, opts)
	local do_sync = opts.sync or false
	local v = versions.versions()
	local release_path = Path:new(install_path, v)

	local printer = vim.schedule_wrap(function(err, line)
		if opts.bufnr then
			vim.api.nvim_buf_set_lines(opts.bufnr, -1, -1, false, { line })
			vim.api.nvim_buf_call(opts.bufnr, function()
				vim.api.nvim_command("normal G")
			end)
		end
	end)

	local compile = Job:new({
		command = bin.compile,
		args = { tostring(release_path:absolute()) },
		cwd = source_path,
		on_stdout = printer,
		on_stderr = printer,
		on_exit = vim.schedule_wrap(function(_, code)
			if code == 0 then
				if opts.bufnr then
					vim.api.nvim_buf_call(opts.bufnr, function()
						vim.api.nvim_command("quit")
					end)

					vim.api.nvim_command("edit")
					vim.api.nvim_command("LspRestart")
				end
			end
		end),
	})

	-- sync is just for testing
	if do_sync then
		compile:sync(60000)
	else
		compile:start()
	end

	return compile
end

return M
