-- TODOS
-- write tests :D

local M = {}

M.config = {
	register_of_last_cmd = "z",
	root_dir_cmd = "./vendor/bin/phpunit",
	close_terminal_key = "q",
}

local ts_utils = require("nvim-treesitter.ts_utils")

local open_terminal = function()
	vim.cmd("vsplit | vertical resize " .. math.floor(vim.o.columns * 0.45) .. " | terminal")
	vim.cmd("startinsert")
end

local close_terminal = function()
	local buffer_id = vim.api.nvim_get_current_buf()
	local job_id = vim.b.terminal_job_id

	if job_id then
		vim.fn.jobstop(job_id)
	end

	vim.api.nvim_buf_delete(buffer_id, { force = true })
end

local register_terminal_keymaps = function()
	-- enter vim mode on pressing k
	vim.api.nvim_buf_set_keymap(0, "t", "k", "<C-\\><C-n><C-\\><C-n>", { noremap = true, silent = true })

	-- close terminal from terminal mode pressing close key
	vim.api.nvim_buf_set_keymap(
		0,
		"t",
		M.config.close_terminal_key,
		'<C-\\><C-n>:lua require("hello-test").close_terminal()<CR>',
		{ noremap = true, silent = true }
	)

	-- close terminal from normal mode pressing close key
	vim.api.nvim_buf_set_keymap(
		0,
		"n",
		M.config.close_terminal_key,
		':lua require("hello-test").close_terminal()<CR>',
		{ noremap = true, silent = true }
	)

	-- make terminal buffer big in terminal mode
	vim.api.nvim_buf_set_keymap(0, "t", "'", "<C-\\><C-n><C-\\><C-n><C-W>|", { noremap = true, silent = true })

	-- make terminal buffer big in vim mode
	vim.api.nvim_buf_set_keymap(0, "n", "'", "<C-W>|", { noremap = true, silent = true })
end

local setup_terminal = function()
	open_terminal()
	register_terminal_keymaps()
end

local run_command = function(cmd)
	vim.api.nvim_chan_send(vim.b.terminal_job_id, cmd .. "\n")
	vim.fn.setreg(M.config.register_of_last_cmd, cmd)
end

M.run_last = function()
	setup_terminal()

	local cmd = vim.fn.getreg(M.config.register_of_last_cmd)

	run_command(cmd)
end

M.run_file = function()
	local file = vim.fn.expand("%")

	setup_terminal()

	local cmd = M.config.root_dir_cmd .. " " .. file

	run_command(cmd)
end

M.run_tests = function()
	setup_terminal()

	run_command(M.config.root_dir_cmd)
end

local function_at_cursor = function()
	local node = ts_utils.get_node_at_cursor()

	if not node then
		return nil
	end

	while node do
		if node:type() == "method_declaration" then
			break
		end

		node = node:parent()
	end

	if node ~= nil then
		local child = node:child(2)
		local child_text = vim.treesitter.get_node_text(child, 0)

		return child_text
	end
end

M.run_test_at_cursor = function()
	local function_name = function_at_cursor()

	if function_name == nil then
		return
	end

	local file = vim.fn.expand("%")

	setup_terminal()

	local cmd = M.config.root_dir_cmd .. " --filter=" .. function_name .. " " .. file

	run_command(cmd)
end

local register_keymaps = function()
	vim.keymap.set("n", "<leader>ta", function()
		M.run_tests()
	end)

	vim.keymap.set("n", "<leader>tl", function()
		M.run_last()
	end)

	vim.keymap.set("n", "<leader>tf", function()
		M.run_file()
	end)

	vim.keymap.set("n", "<leader>tt", function()
		M.run_test_at_cursor()
	end)
end

M.setup = function(opts)
	M.config = vim.tbl_extend("force", M.config, opts or {})
	register_keymaps()
end

M.close_terminal = close_terminal

return M
