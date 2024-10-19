local M = {}

M.setup = function()
    vim.keymap.set('n', '<leader>ha', function()
        M.runTests()
    end)

    vim.keymap.set('n', '<leader>hf', function()
        M.runFile()
    end)
end

M.runFile = function()
    local file = vim.fn.expand("%")

    vim.cmd('vsplit | terminal')
    vim.cmd('startinsert')


    -- close terminal on pressing enter
    vim.api.nvim_buf_set_keymap(0, 't', '<CR>', '<C-\\><C-n>:q<CR>', {
        noremap = true,
        silent = true
    })

    vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', 'A<CR>', {
        noremap = true,
        silent = true
    })

    local cmdBase = "./vendor/bin/phpunit"

    local cmd = cmdBase .. " " .. file

    vim.api.nvim_chan_send(vim.b.terminal_job_id, cmd .. "\n")

    vim.cmd('stopinsert')
end

M.runTests = function()
    vim.cmd('vsplit | terminal')
    vim.cmd('startinsert')

    -- close terminal on pressing enter
    vim.api.nvim_buf_set_keymap(0, 't', '<CR>', '<C-\\><C-n>:q<CR>', {
        noremap = true,
        silent = true
    })

    vim.api.nvim_buf_set_keymap(0, 't', 'k', '<C-\\><C-n><C-\\><C-n>', { noremap = true, silent = true })

    vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', ':q<CR>', { noremap = true, silent = true })

    local cmd = "php artisan test"
    -- local cmd = "./vendor/bin/phpunit"
    vim.api.nvim_chan_send(vim.b.terminal_job_id, cmd .. "\n")

    -- vim.cmd('stopinsert')
end

return M
