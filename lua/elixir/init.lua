local uv = vim.loop

local Job = require("plenary.job")
local Path = require("plenary.path")
local popup = require("plenary.popup")

local Version = require("elixir.version")
local Download = require("elixir.download")
local Compile = require("elixir.compile")
local Utils = require("elixir.utils")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local M = {}

local get_cursor_position = function()
	local rowcol = vim.api.nvim_win_get_cursor(0)
	local row = rowcol[1] - 1
	local col = rowcol[2]

	return row, col
end

function M.open_floating_window()
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
		zindex = 10,
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

function M.restart(client)
	return function()
		client.request_sync("workspace/executeCommand", {
			command = "restart:serverid",
			arguments = {},
		}, nil, 0)

		vim.cmd([[w | edit]])
	end
end

function M.expand_macro(client)
	return function()
		local params = vim.lsp.util.make_given_range_params()

		local text = vim.api.nvim_buf_get_text(
			0,
			params.range.start.line,
			params.range.start.character,
			params.range["end"].line,
			params.range["end"].character,
			{}
		)

		local resp = client.request_sync("workspace/executeCommand", {
			command = "expandMacro:serverid",
			arguments = { params.textDocument.uri, vim.fn.join(text, "\n"), params.range.start.line },
		}, nil, 0)

		local content = {}
		if resp["result"] then
			for k, v in pairs(resp.result) do
				vim.list_extend(content, { "# " .. k, "" })
				vim.list_extend(content, vim.split(v, "\n"))
			end
		else
			table.insert(content, "Error")
		end

		-- not sure why i need this here
		vim.schedule(function()
			vim.lsp.util.open_floating_preview(vim.lsp.util.trim_empty_lines(content), "elixir", {})
		end)
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
	local child_or_root_path = vim.fs.dirname(vim.fs.find({ "mix.exs", ".git" }, { upward = true, path = fname })[1])
	local maybe_umbrella_path =
		vim.fs.dirname(vim.fs.find({ "mix.exs" }, { upward = true, path = child_or_root_path })[1])

	if maybe_umbrella_path then
		if not vim.startswith(child_or_root_path, Path:joinpath(maybe_umbrella_path, "apps"):absolute()) then
			maybe_umbrella_path = nil
		end
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
	local install_path =
		Path:new(params.path, params.repo, Utils.safe_path(params.ref), params.versions, "language_server.sh")

	return install_path
end

M.on_attach = function(client, bufnr)
	local add_user_cmd = vim.api.nvim_buf_create_user_command
	vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
		buffer = bufnr,
		callback = vim.lsp.codelens.refresh,
	})
	vim.lsp.codelens.refresh()
	add_user_cmd(bufnr, "ElixirFromPipe", M.from_pipe(client), {})
	add_user_cmd(bufnr, "ElixirToPipe", M.to_pipe(client), {})
	add_user_cmd(bufnr, "ElixirRestart", M.restart(client), {})
	add_user_cmd(bufnr, "ElixirExpandMacro", M.expand_macro(client), { range = true })
end

local cache_dir = Path:new(vim.fn.getcwd(), ".elixir_ls", "elixir.nvim")
local download_dir = cache_dir:joinpath("downloads")
local install_dir = Path:new(vim.fn.expand("~/.cache/nvim/elixir.nvim/installs"))

local function install_elixir_ls(opts)
	local source_path = Download.clone(tostring(download_dir:absolute()), opts)
	local bufnr = M.open_floating_window()

	local result = Compile.compile(
		download_dir:joinpath(source_path):absolute(),
		opts.install_path:absolute(),
		vim.tbl_extend("force", opts, { bufnr = bufnr })
	)
end

local function make_opts(opts)
	local repo = opts.repo or "elixir-lsp/elixir-ls"
	local ref
	if opts.branch then
		ref = opts.branch
	elseif opts.tag then
		ref = "tags/" .. opts.tag
	else
		if opts.repo then -- if we specified a repo in our conifg, then let's default to HEAD
			ref = "HEAD"
		else -- else, let's checkout the latest stable release
			ref = "tags/v0.10.0"
		end
	end

	return {
		repo = repo,
		ref = ref,
	}
end

function M.setup(opts)
	opts = opts or {}
	local elixir_group = vim.api.nvim_create_augroup("elixirnvim", { clear = true })

	local start_elixir_ls = function(arg)
		fname = Path.new(arg.file):absolute()

		local root_dir = opts.root_dir and opts.root_dir(fname) or root_dir(fname)
		local new_opts = make_opts(opts)

		local cmd = M.command({
			path = tostring(install_dir),
			repo = new_opts.repo,
			ref = new_opts.ref,
			versions = Version.get(),
		})

		if not cmd:exists() then
			vim.ui.select({ "Yes", "No" }, { prompt = "Install ElixirLS" }, function(choice)
				if choice == "Yes" then
					install_elixir_ls(vim.tbl_extend("force", new_opts, { install_path = cmd:parent() }))
				end
			end)

			return
		elseif root_dir then
			vim.lsp.start(vim.tbl_extend("keep", {
				name = "ElixirLS",
				cmd = { tostring(cmd) },
				commands = {
					["elixir.lens.test.run"] = test,
				},
				settings = opts.settings or settings,
				capabilities = opts.capabilities or capabilities,
				root_dir = root_dir,
				on_attach = function(...)
					if opts.on_attach then
						opts.on_attach(...)
					end

					M.on_attach(...)
				end,
			}, opts))
		end
	end

	vim.api.nvim_create_autocmd({ "FileType" }, {
		group = elixir_group,
		pattern = { "elixir" },
		callback = start_elixir_ls,
	})
end

return M
