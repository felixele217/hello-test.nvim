local augroup = vim.api.nvim_create_augroup("HelloWorld", { clear = true })

local function main()
    print('hello world')
end

local function setup()
    main()
end

return { setup = setup }

