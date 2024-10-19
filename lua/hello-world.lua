local augroup = vim.api.nvim_create_augroup("HelloWorld", { clear = true })

local function main()
    print('hello world')
end

local function setup()
    vim.api.nvim_create_autocmd("VimEnter",
        {
            group = augroup,
            desc = "Print hello world",
            once = true,
            callback = main
        })
end

return { setup = setup }

