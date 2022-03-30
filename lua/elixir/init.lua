local uv = vim.loop

local lspconfig = require("lspconfig")
local lsputil = require("lspconfig.util")

local Job = require("plenary.job")
local Path = require("plenary.path")
local popup = require("plenary.popup")

local Version = require("elixir.version")
local Download = require("elixir.download")
local Compile = require("elixir.compile")
local Utils = require("elixir.utils")

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
    zindex = 10
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
	local repo_path = Utils.repo_path(params.repo, params.branch)
	local install_path = Path:new(params.path, repo_path, params.versions, "language_server.sh")

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

local function install_elixir_ls(opts)
	local download_opts = {
		repo = opts.repo,
		branch = opts.branch,
	}
	local downloader = (opts.repo or opts.branch) and "clone" or "stable"
	local source_path = Download[downloader](tostring(download_dir:absolute()), download_opts)
	local bufnr = M.open_floating_window()

	local result = Compile.compile(
		tostring(download_dir:joinpath(source_path):absolute()),
		tostring(install_dir:absolute()),
		vim.tbl_extend("force", opts, { bufnr = bufnr })
	)
end

local function make_opts(opts)
	local repo = opts.repo or "elixir-lsp/elixir-ls"
	local branch = opts.branch or nil

	return {
		repo = repo,
		branch = branch,
	}
end

function M.setup(opts)
	lspconfig.elixirls.setup(vim.tbl_extend("keep", {
		on_init = lsputil.add_hook_after(default_config.on_init, function(client)
			client.commands["elixir.lens.test.run"] = test
		end),
		on_new_config = function(new_config, new_root_dir)
			opts = make_opts(opts)

			local cmd = M.command({
				path = tostring(install_dir),
				repo = opts.repo,
				branch = opts.branch,
				versions = Version.get(),
			})

			if not cmd:exists() then
				vim.ui.select({ "Yes", "No" }, { prompt = "Install ElixirLS" }, function(choice)
					if choice == "Yes" then
						install_elixir_ls(opts)
					end
				end)

				return
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

return M
