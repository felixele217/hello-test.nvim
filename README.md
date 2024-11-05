# hello-test.nvim

Plugin to enable simple and fast testing development workflow.  

All keybindings run the tests in a new terminal that can be closed pressing Enter (can be configured) and navigated with VIM keybindings
once you press 'k' to enter VIM-Mode.

## Features
Currently only supports Test Suites that utilize 
```
'./vendor/bin/phpunit'
```

## Installation
lazyvim
```
return {
    'felixele217/hello-test.nvim',
}
```

## Configuration
lazyvim
```
return {
    'felixele217/hello-test.nvim',
    config = function()
        require('hello-test').setup({
            close_terminal_key = "<CR>" -- specify key that closes terminal
        })
    end
}
```

## Keymaps
`<leader>`tt - run test under cursor  
`<leader>`tl - run last test  
`<leader>`tf - run current test file  
`<leader>`ta - run all tests  

## Ideas and Contribution
Feel free to open PRs or Issues! :)

