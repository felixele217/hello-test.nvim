local M                         = {}

-- local root_dir_cmd              = "./vendor/bin/phpunit"
local root_dir_cmd              = "php artisan test --parallel"
--
local ts_utils                  = require("nvim-treesitter.ts_utils")

local open_terminal             = function()
    vim.cmd('vsplit | terminal')
    vim.cmd('startinsert')
end

local register_terminal_keymaps = function()
    -- enter vim mode on pressing k
    vim.api.nvim_buf_set_keymap(0, 't', 'k', '<C-\\><C-n><C-\\><C-n>', { noremap = true, silent = true })

    -- close terminal from terminal mode pressing enter
    vim.api.nvim_buf_set_keymap(0, 't', '<CR>', '<C-\\><C-n>:q<CR>', { noremap = true, silent = true })

    -- close terminal from normal mode pressing enter
    vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', ':q<CR>', { noremap = true, silent = true })

    -- make terminal buffer big in terminal mode
    vim.api.nvim_buf_set_keymap(0, 't', "'", '<C-\\><C-n><C-\\><C-n><C-W>|', { noremap = true, silent = true })

    -- make terminal buffer big in vim mode
    vim.api.nvim_buf_set_keymap(0, 'n', "'", '<C-W>|', { noremap = true, silent = true })
end

local setup_terminal            = function()
    open_terminal()
    register_terminal_keymaps()
end


local register_keymaps = function()
    vim.keymap.set('n', '<leader>ta', function()
        M.run_tests()
    end)

    vim.keymap.set('n', '<leader>tf', function()
        M.run_file()
    end)

    vim.keymap.set('n', '<leader>tt', function()
        M.run_test_at_cursor()
    end)
end


local run_command        = function(cmd)
    vim.api.nvim_chan_send(vim.b.terminal_job_id, cmd .. "\n")
end

M.setup                  = function()
    register_keymaps()
end

M.run_file               = function()
    local file = vim.fn.expand("%")

    setup_terminal()

    local cmd = root_dir_cmd .. " " .. file

    run_command(cmd)
end

M.run_tests              = function()
    setup_terminal()

    run_command(root_dir_cmd)
end

local function_at_cursor = function()
    local node = ts_utils.get_node_at_cursor()

    if not node then
        return nil
    end

    while node do
        if node:type() == 'method_declaration' then
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

local save_to_register   = function(cmd)
    local escaped_cmd = vim.fn.escape(cmd, "'")
    vim.cmd("let @X = '" .. escaped_cmd .. "'")
end

M.run_test_at_cursor     = function(ta)
    local function_name = function_at_cursor()

    if function_name == nil then
        return
    end

    setup_terminal()

    local cmd = root_dir_cmd .. " --filter=" .. function_name

    run_command(cmd)

    save_to_register(cmd)
end

return M
