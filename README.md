# copilot-client.lua
**Client for [copilot.lua](https://github.com/zbirenbaum/copilot.lua) that utilizes GitHub Copilot as a tool, not a co-pilot.**

<p align="center">
  <img src="https://user-images.githubusercontent.com/44208530/185738152-60d9fe4f-b786-4791-a703-99c1f1500cab.gif" alt="animated" />
</p>

## Pitch
GitHub Copilot is great, but it can be obtrusive. After using it for almost a year, I can predict when it's going to give me a great suggestion, and when not. It can be very annoying how it tries to give suggestions after almost every keystroke even though all of them are wrong. That's why I came up with this plugin. GitHub Copilot will give you suggestions only when you tell it to. In the demo above you can see the ghost text after pressing `Ctrl+c` and waiting for the result.

NOTE: The only other way of using Copilot as a [cmp source](https://github.com/zbirenbaum/copilot-cmp) didn't work well for me either. Cmp panel was too cluttered and having to scroll through suggestions slowed me down in my workflow.

## Setup (IMPORTANT)
This plugin doesn't start the Copilot server on it's own (hence the name copilot-client). Follow instructions and install [copilot.lua](https://github.com/zbirenbaum/copilot.lua) in order to have Copilot start as a Language Server. (Verify with `:LspInfo`)  

Neovim 0.7+ required

## Install
With packer
```lua
use {
  'samodostal/copilot-client.lua',
  requires = {
    'zbirenbaum/copilot.lua', -- requires copilot.lua and plenary.nvim
    'nvim-lua/plenary.nvim'
  },
},
```
With vim.plug
```lua
Plug 'samodostal/copilot-client.lua'
Plug 'zbirenbaum/copilot.lua', -- requires copilot.lua and plenary.nvim
Plug 'nvim-lua/plenary.nvim'
```

## Usage
```lua
-- Require and call setup functions somewhere in your init.lua
require('copilot').setup {
  cmp = {
    enabled = false, -- no need for cmp
  },
}

require('copilot-client').setup {
  mapping = {
    accept = '<CR>',
    -- Next and previos suggestions to be added
    -- suggest_next = '<C-n>',
    -- suggest_prev = '<C-p>',
  },
}

-- Create a keymap that triggers the suggestion. To accept suggestion press <CR> as set in the setup.
vim.api.nvim_set_keymap('i', '<C-c>', '<cmd>lua require("copilot-client").suggest()<CR>', { noremap = true, silent = true })
```

## Plans for the future / TODO
- [ ] Client that requests suggestions from the Language Server periodically like the standard [Github Copilot](https://github.com/github/copilot.vim) plugin. (Maybe not because it looks like [copilot.lua](https://github.com/zbirenbaum/copilot.lua) is going to [implement it](https://github.com/zbirenbaum/copilot.lua/issues/19) and I think that is a good idea)
- [ ] Multiple suggestions, `suggest_next` and `suggest_prev` functions
- [ ] 'Waiting for copilot' as virtual dots instead of printing to the command line
