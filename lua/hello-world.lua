local M = {}

M.setup = function()
    vim.keymap.set('n', '<leader>hw', function()
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

    local cmdBase = "./vendor/bin/pest"

    local cmd = cmdBase .. " " .. file

    vim.api.nvim_chan_send(vim.b.terminal_job_id, cmd .. "\n")
end

M.runTests = function()
    vim.cmd('vsplit | terminal')
    vim.cmd('startinsert')

    -- close terminal on pressing enter
    vim.api.nvim_buf_set_keymap(0, 't', '<CR>', '<C-\\><C-n>:q<CR>', {
        noremap = true,
        silent = true
    })

    local cmd = "./vendor/bin/pest"
    vim.api.nvim_chan_send(vim.b.terminal_job_id, cmd .. "\n")
end

return M
