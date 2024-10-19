local M                         = {}

-- local root_dir_cmd = "./vendor/bin/phpunit"
local root_dir_cmd              = "php artisan test"

local open_terminal             = function()
    vim.cmd('vsplit | terminal')
    vim.cmd('startinsert')
end

local register_keymaps          = function()
    vim.keymap.set('n', '<leader>ha', function()
        M.run_tests()
    end)

    vim.keymap.set('n', '<leader>hf', function()
        M.run_file()
    end)
end

local register_terminal_keymaps = function()
    -- enter vim mode on pressing k
    vim.api.nvim_buf_set_keymap(0, 't', 'k', '<C-\\><C-n><C-\\><C-n>', { noremap = true, silent = true })

    -- close terminal from terminal mode pressing enter
    vim.api.nvim_buf_set_keymap(0, 't', '<CR>', '<C-\\><C-n>:q<CR>', { noremap = true, silent = true })

    -- close terminal from normal mode pressing enter
    vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', ':q<CR>', { noremap = true, silent = true })
end

local run_command               = function(cmd)
    vim.api.nvim_chan_send(vim.b.terminal_job_id, cmd .. "\n")
end

M.setup                         = function()
    register_keymaps()
end


M.run_file = function()
    local file = vim.fn.expand("%")

    open_terminal()
    register_terminal_keymaps()

    local cmd = root_dir_cmd .. " " .. file

    run_command(cmd)
end

M.run_tests = function()
    open_terminal()
    register_terminal_keymaps()

    run_command(root_dir_cmd)
end

return M
