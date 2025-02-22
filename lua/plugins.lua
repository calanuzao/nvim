return {
  -- Theme Picker
{
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
      require("themery").setup({
        -- add the config here
      })
    end
},
  -- GitHub Copilot
{
  "github/copilot.vim",
  lazy = false,  -- loading immediately
  config = function()
    -- enable Copilot globally
    vim.g.copilot_enabled = true
    
    -- sisable the default key mappings for Tab and Shift-Tab
    vim.g.copilot_no_tab_map = true
    
    -- Optional: Custom key mappings
    vim.api.nvim_set_keymap('i', '<C-N>', 'copilot#Next()', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('i', '<C-P>', 'copilot#Previous()', { noremap = true, silent = true })

    -- additional behavior
    vim.g.copilot_auto_trigger = true  -- Automatically trigger suggestions as you type
    vim.g.copilot_accept_key = '<C-l>' -- Use <C-l> to accept suggestions
  end 
},
  -- LaTex Editor (VimTeX)
{
  "lervag/vimtex",
  lazy = false,
  config = function()
    -- Detect OS
    local system = vim.loop.os_uname().sysname

    -- Set PDF viewer based on OS
    if system == "Darwin" then  -- macOS
      vim.g.vimtex_view_method = 'skim'
      -- Forward search after compilation
      vim.g.vimtex_view_skim_sync = 1
      -- Focus Skim after forward search
      vim.g.vimtex_view_skim_activate = 1
    elseif system == "Linux" then
      vim.g.vimtex_view_method = 'zathura'
    elseif system == "Windows_NT" then
      vim.g.vimtex_view_method = 'sumatrapdf'
    end
    
    -- PDF Viewer settings
    vim.g.vimtex_quickfix_mode = 0
    
    -- Disable custom warnings
    vim.g.vimtex_quickfix_ignore_filters = {
      'Underfull',
      'Overfull',
      'specifier changed to',
    }

    -- Disable imaps (we'll use UltiSnips for this)
    vim.g.vimtex_imaps_enabled = 0
    
    -- Don't open pdfviwer on compile
    vim.g.vimtex_view_automatic = 0
    
    -- Disable conceal
    vim.g.vimtex_syntax_conceal = {
      accents = 1,
      ligatures = 1,
      cites = 1,
      fancy = 1,
      spacing = 0,  -- default: 1
      greek = 1,
      math_bounds = 1,
      math_delimiters = 1,
      math_fracs = 1,
      math_super_sub = 1,
      math_symbols = 1,
      sections = 0,
      styles = 1,
    } 

    -- Latex warnings to ignore
    vim.g.vimtex_quickfix_ignore_filters = {
      'Underfull \\hbox',
      'Overfull \\hbox',
      'LaTeX Warning: .*item may have changed',
      'LaTeX hooks Warning',
    }

    -- Set up autocommand for LaTeX files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "tex",
      callback = function()
        -- Spell checking
        vim.opt_local.spell = true
        vim.opt_local.spelllang = { 'en_us' }
        
        -- Spell correction mapping
        vim.keymap.set('i', '<C-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u', { buffer = true, silent = true })
        
        -- Set conceallevel
        vim.opt_local.conceallevel = 2
        
        -- Set text width for automatic wrapping
        vim.opt_local.textwidth = 80
        
        -- Enable word wrapping
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        
        -- Indentation settings
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
        
        -- Compile on save
        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = "*.tex",
          callback = function()
            vim.cmd("VimtexCompile")
          end,
          buffer = 0
        })
      end
    })
  end,
},

-- Add UltiSnips configuration
{
  "SirVer/ultisnips",
  dependencies = {
    "honza/vim-snippets",
  },
  config = function()
    vim.g.UltiSnipsExpandTrigger = '<tab>'
    vim.g.UltiSnipsJumpForwardTrigger = '<tab>'
    vim.g.UltiSnipsJumpBackwardTrigger = '<s-tab>'
    vim.g.UltiSnipsSnippetDirectories = {
      vim.fn.stdpath('config') .. '/UltiSnips',
      'UltiSnips'
    }
  end,
},

  -- ChatGPT 
{
  "dreamsofcode-io/ChatGPT.nvim",
  event = "VeryLazy",
  dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
  },
  config = function()
      require("chatgpt").setup({
          api_key_cmd = "echo $API_KEY"
      })
  end,
  },
  -- File Explorer
  {
  'kyazdani42/nvim-tree.lua'
  }, 
  -- Add AsyncRun plugin
  {
    'skywind3000/asyncrun.vim',
    cmd = { 'AsyncRun', 'AsyncStop' }
  },
  {
    "ThePrimeagen/vim-be-good",
    config = function()
    end
  },
  {
    'akinsho/toggleterm.nvim',
    config = function()
        require("toggleterm").setup{
            size = 120,
            open_mapping = "<c-\\>",
            hide_numbers = true,
            shade_filetypes = {},
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = true,
            persist_size = true,
            direction = "float",
            close_on_exit = false,
            shell = vim.o.shell,
            float_opts = {
                border = "curved",
                winblend = 0,
                highlights = {
                    border = "Normal",
                    background = "Normal",
                },
            }
        }

        -- keymaps for toggleterm
        local keymap = vim.api.nvim_set_keymap
        local opts = { noremap = true, silent = true }

        keymap('t', '<esc>', '<C-\\><C-n>', opts)
    end
  },
  {
    "chentoast/marks.nvim",
    config = function()
      require("marks").setup({
        default_mappings = true,
      })
    end,
  },
  { "tpope/vim-projectionist" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = { "Neotree" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        filesystem = {
          follow_current_file = {
            enabled = true,
            leave_dirs_open = true,
          },
        },
      })
    end,
  },
  {
    "David-Kunz/gen.nvim",
    opts = {
      model = "llama3",
      display_mode = "float",
    }
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua",              -- optional
    },
    config = true,
  },
  { "mfussenegger/nvim-jdtls" },
  {
    "chrishrb/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,      -- default settings
    submodules = false, -- not needed, submodules are required only for tests
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        view_options = {
          show_hidden = true,
          natural_order = true,
          is_always_hidden = function(name, _)
            return name == ".." or name == ".git"
          end,
        },
        float = {
          padding = 2,
          max_width = 90,
          max_height = 0,
        },
        win_options = {
          wrap = true,
          winblend = 0,
        },
        keymaps = {
          ["<C-c>"] = false,
          ["q"] = "actions.close",
        },
      })
    end,
  },
  { 
    "preservim/vim-pencil" 
  },
  {
    "folke/zen-mode.nvim",
    opts = {
      on_open = function(_)
        vim.opt.nu = false
        vim.opt.relativenumber = false
        require("noice").disable()
        require("ufo").disable()
        vim.o.foldcolumn = "0"
        vim.o.foldenable = false
      end,
      on_close = function()
        vim.opt.nu = true
        vim.opt.relativenumber = true
        require("noice").enable()
        require("ufo").enable()
        vim.o.foldcolumn = "1"
        vim.o.foldenable = true
      end,
    },
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function()
      local logo = [[
                                                                               
   ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⣿⣿⣿⣿⣿⣿⡿⠟⠉⣹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠈⠼⢛⣩⣀⣨⣥⣶⣏⣀⠹⣿⣿⣿⡿⠟⢉⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⢸⣿⠟⠁⠼⣋⣴⣾⣾⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣤⣬⣀⠀⠛⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⣡⡆⠘⣡⣤⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣖⣀⢠⣍⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠸⡟⠀⣠⣿⣯⣾⣿⣿⣿⣿⣿⣿⡿⡿⢋⣴⣿⡿⢿⡿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣤⣤⡈⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⢰⣧⢀⣾⣿⣿⣿⣿⣿⣿⣿⣶⢐⠏⡜⢰⠟⣿⠟⡴⢋⣴⡿⢛⣽⣿⣿⣿⣿⣿⠛⣩⣿⣿⣿⣿⣿⣏⠐⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⢂⣿⣿⣿⣿⢿⡿⢸⣿⡿⢿⡟⡋⡿⢿⡿⢡⠆⣯⣼⣱⡟⠋⢀⣥⡾⠿⢿⣿⡟⣋⡾⢋⣽⣿⣿⣿⣿⣿⣧⡈⠻⣿⣿⣿⣿⣿⣿⣿⣿
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⣠⣾⣿⣿⣿⣿⡎⣰⡼⣿⣿⡌⢰⡇⠁⢸⠀⠛⢐⡉⣹⣿⡏⢀⡿⢁⠀⣴⣿⣿⠋⡩⢐⣽⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⢸⣿⣿⣿⣿⣿⣿
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⣘⠈⣻⡟⣿⡟⢹⡿⢁⠙⠀⠿⣿⠇⠘⢡⠇⡄⢂⣾⠟⠸⢟⣫⡖⢈⡴⢃⣈⣿⡷⢐⣣⠖⣘⡽⣛⣿⣿⣛⠟⣛⣻⣿⣿⣿⠦⠙⣿⣿⣿⣿⣿
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⣿⣿⣿⢡⠸⢣⠸⡇⣾⠀⣷⢠⡏⣤⢴⠟⢛⣡⣌⡉⠈⠛⠦⡉⣬⣭⣴⣶⣶⣤⣭⣭⣙⣛⠻⢟⣻⣯⣿⠟⢛⠟⣋⣿⣿⡦⠄⢛⣿⣿⣿⣿⣿
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠘⣿⠿⣇⠃⠸⣦⣇⠹⡦⠥⠿⠃⣈⡂⠨⣄⠙⣿⣿⣷⣮⣥⣦⡈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡘⢯⡭⢀⣼⠟⣚⣿⡿⣿⣄⠀⣿⣿⣿⣿⣿⣿
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⢉⡛⠀⢿⣄⡀⢀⡑⠆⣉⣴⣶⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⡇⠀⣤⣶⠾⠿⢟⣑⣊⠽⣿⣷⣌⠻⣿⣿⣿⣿
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⡌⣿⣿⣧⠹⡇⢠⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡙⢿⣿⣿⣿⠘⣷⡐⠾⣭⣍⣉⡴⢊⣭⣄⠲⢾⣿⣿⣿⣿
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠠⣸⣿⡇⠣⡁⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣯⢻⣿⣿⣿⣿⣿⣿⡿⢿⣿⡈⠻⣿⣿⡇⢻⠭⢅⠨⢛⣛⣷⣿⣿⡇⢸⣿⣿⣿⠿⠋
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡌⢿⡗⢤⣤⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⢸⢸⣿⣿⡿⣿⣿⣿⣷⡜⣿⣷⣤⣽⣿⡇⢸⣪⡥⢚⣿⣾⣿⡿⢟⠁⠈⠛⠛⠁⠀⠀
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡍⢁⣤⣮⡀⢬⠘⣿⡟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠘⣿⣿⣷⡌⣿⣿⣿⣷⠘⣿⣿⣿⣿⣷⣦⣍⠲⣿⣿⣿⡏⣴⢀⠉⢰⣦⡀⠀⠀⠀
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠻⣿⣿⣦⡀⢿⣇⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⢠⣿⣿⣿⡇⠈⣿⣿⣿⣇⠙⣛⣛⠻⢿⣿⣿⣧⠹⡿⠋⣸⢡⢸⡆⣾⣿⣿⣆⠀⠀
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡁⢈⣒⠲⠾⠈⠻⢸⠿⢛⣉⡙⢿⣿⣿⣿⣿⣿⣯⢻⣿⠞⣼⣿⣿⣿⣷⣾⣿⣿⡟⣡⠈⠿⠿⠿⢿⣿⣿⠿⠀⠴⠀⠇⠘⣾⡇⢿⣿⣿⣿⣦⠀
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡦⠙⣥⡀⣿⣧⡴⠎⣁⡙⠿⣿⣿⣿⣿⣿⣿⣿⡈⣯⢰⠘⣿⡿⠿⠟⠛⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡇⡒⠀⠀⡄⡿⠁⢚⣿⣿⣿⣿⡇
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⢸⣧⢹⣯⣴⡿⠿⠿⠶⠬⠍⠙⠛⠛⠛⠿⠇⣿⠨⡑⠈⠀⠀⠀⢀⡤⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⡇⠇⢰⡆⢰⠃⠀⢰⣿⣿⣿⣿⢃
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢀⡙⠌⠃⠀⠀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢀⣀⡀⠀⠀⠀𝖈𝖆𝖑𝖔𝖉𝖎𝖎✍⠀⠀⣼⣿⣿⡇⠁⠀⠀⠁⠀⠀⢺⣿⣿⣿⡿⣸
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠘⠆⠀⠀⠀⠛⠁⠀⠀⠀⠀⠀⠀⠀⢀⣶⠸⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⣿⣿⣿⠁⠀⠀⠀⠀⠐⢦⡍⣹⣿⣿⣇⣿
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢠⠢⡄⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⡀⢿⣿⣿⣿⣿⣷⣦⣤⡤⠄⢀⣂⣀⣙⡛⠿⣿⣿⣿⡀⠀⠀⢠⡘⣦⡱⣶⣿⣿⡟⣸⣿
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⢸⣧⡄⠀⠈⢶⣶⣶⣶⣶⣶⣶⣿⣿⣿⣿⡇⢸⣿⡿⢿⣿⡿⢛⣩⣶⣿⣿⣿⣿⣿⣿⣶⣌⢻⣿⡇⠀⠀⡆⠱⡌⣣⣿⣿⣿⣇⣿⣿
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠁⠀⢸⣿⣿⡌⠂⠀⢻⣿⡿⢛⣫⣭⣭⣭⣭⣿⣓⣌⣛⣥⣬⣵⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡘⠁⡄⠀⡇⡆⠀⣽⣿⣿⣿⣍⠻⣿
	 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠀⠀⠀⠀⢸⣿⣿⣄⣓⠀⠀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⡿⡿⠟⣿⡿⢿⣿⣿⣿⣿⣶⣤⣀⣁⣁⠸⢛⣿⣿⣿⠿⢓⣸
	 ⣿⣿⣿⣿⣿⣿⣿⠟⠋⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⡗⠄⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠉⠉⠉⠉⠻⠙⢷⢀⢌⠂⠻⣌⠂⠢⠙⢟⡻⣿⣿⣿⠿⠋⠀⣾⣿⣿⣷⣦⡍⠹
	 ⣿⣿⣿⡿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⠀⣼⣿⣿⣿⣿⣿⣿⡿⣿⡿⠁⠠⠤⠶⣒⣋⣥⣶⠷⢀⣤⠤⣌⣀⣉⠓⠀⠀⠀⠀⠀⡄⠀⠀⠈⢼⣿⣿⡿⠟⠋⠀⠀
	 ⡿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⠏⣴⣿⣿⠋⢹⣏⠇⠻⠇⠟⣁⡐⠒⠛⠛⢛⣋⣩⣤⠶⠛⣡⣴⣿⣿⣿⠏⡀⡀⢸⠀⠀⠁⠀⠀⢐⣿⠟⠁⠀⠀⠀⠀⠀
	 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢘⠛⢛⣋⣥⠞⡫⢐⠁⠂⡸⠃⠀⠂⠠⣾⣿⣍⠛⠛⣛⣛⣭⣭⣴⣶⣾⣿⣿⣿⡿⠃⠀⠃⠇⠈⠀⢀⠀⠰⢀⣾⡇⠀⠀⠀⠀⢀⣬⣶
	 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣷⣦⣬⣀⣈⠀⠕⢚⣈⠀⢴⡾⠁⣦⡙⢿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠟⠛⠉⠀⢠⠀⠀⠀⠀⢰⢸⠀⠀⣸⣿⣿⣶⣤⠀⢠⣾⣿⣿
	 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⢠⣿⣷⣄⠉⠉⢉⣉⡉⠁⠀⠀⠀⠀⢰⠀⠀⡄⠘⠀⠀⣦⠠⡈⠀⠀⣨⣿⣿⣿⡿⣡⣶⣶⣿⣿⡟
      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
          -- stylua: ignore
          center = {
            { action = "Telescope find_files", desc = " Find file", icon = " ", key = "f" },
            { action = "ene | startinsert", desc = " New file", icon = " ", key = "n" },
            { action = "Telescope oldfiles", desc = " Recent files", icon = " ", key = "r" },
            { action = "Telescope live_grep", desc = " Find text", icon = " ", key = "g" },
            --{
            --  action = [[lua require("lazyvim.util").telescope.config_files()()]],
            --  desc = " Config",
            --  icon = " ",
            --  key = "c"
            --},
            --{ action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
            --{ action = "LazyExtras", desc = " Lazy Extras", icon = " ", key = "x" },
            { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
            { action = "qa", desc = " Quit", icon = " ", key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      return opts
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      routes = {
        {
          filter = { event = "notify", find = "No information available" },
          opts = { skip = true },
        },
      },
      presets = {
        lsp_doc_border = true,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    "mfussenegger/nvim-lint",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        svelte = { "eslint_d" },
        kotlin = { "ktlint" },
        terraform = { "tflint" },
        ruby = { "standardrb" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      vim.keymap.set("n", "<leader>ll", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          lua = { "stylua" },
          svelte = { { "prettierd", "prettier" } },
          javascript = { { "prettierd", "prettier" } },
          typescript = { { "prettierd", "prettier" } },
          javascriptreact = { { "prettierd", "prettier" } },
          typescriptreact = { { "prettierd", "prettier" } },
          json = { { "prettierd", "prettier" } },
          graphql = { { "prettierd", "prettier" } },
          java = { "google-java-format" },
          kotlin = { "ktlint" },
          ruby = { "standardrb" },
          markdown = { { "prettierd", "prettier" } },
          erb = { "htmlbeautifier" },
          html = { "htmlbeautifier" },
          bash = { "beautysh" },
          proto = { "buf" },
          rust = { "rustfmt" },
          yaml = { "yamlfix" },
          toml = { "taplo" },
          css = { { "prettierd", "prettier" } },
          scss = { { "prettierd", "prettier" } },
          sh = { { "shellcheck" } },
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>l", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "Format file or range (in visual mode)" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup({
        max_lines = 5,
      })
    end,
  },
  {
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate")
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n" },           function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("octo").setup({
        enable_builtin = true,
        use_local_fs = true,
      })
      vim.cmd([[hi OctoEditable guibg=none]])
      vim.treesitter.language.register("markdown", "octo")
    end,
    keys = {
      { "<leader>O",  "<cmd>Octo<cr>",         desc = "Octo" },
      { "<leader>Op", "<cmd>Octo pr list<cr>", desc = "Octo pr list" },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-ts-autotag").setup({})
    end,
    lazy = true,
    event = "VeryLazy",
  },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          "javascript",
          "typescript",
          "c",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "elixir",
          "erlang",
          "heex",
          "eex",
          "java",
          "kotlin",
          "jq",
          "dockerfile",
          "json",
          "html",
          "terraform",
          "go",
          "tsx",
          "bash",
          "ruby",
          "markdown",
          "java",
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = "<C-CR>",
            node_decremental = "<bs>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>p"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>ps"] = "@parameter.inner",
            },
          },
        },
      })
    end,
  },
  { 
    "nvim-telescope/telescope-fzf-native.nvim",    build = "make" 
  },
  {
    "rose-pine/neovim", name = "rose-pine"
  },
  {
    'oneslash/helix-nvim', version = "*"
  },
  {
    url = "https://codeberg.org/jthvai/lavender.nvim",
    branch = "stable", -- versioned tags + docs updates from main
    lazy = false,
    priority = 1000,
  },


  -- THEMES
  {
    "folke/tokyonight.nvim",
  },
  {
  "rakr/vim-one",
  config = function()
      vim.cmd([[colorscheme one]])
      vim.opt.background = "light"  -- for the light version
      -- or vim.opt.background = "dark" for the dark version
      vim.opt.termguicolors = true
  end,
  },
  {
    "xiantang/darcula-dark.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "catppuccin/nvim",
  },
  {
    "ellisonleao/gruvbox.nvim",
  },
  {
    "exosyphon/telescope-color-picker.nvim",
    config = function()
      vim.keymap.set("n", "<leader>uC", "<cmd>Telescope colors<CR>", { desc = "Telescope Color Picker" })
    end,
  },
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<CR>", { desc = "Telescope Undo" })
    end,
  },
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Open Fugitive Panel" })
    end,
  },
  "tpope/vim-repeat",
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "olimorris/neotest-rspec",
      "haydenmeade/neotest-jest",
      "zidhuss/neotest-minitest",
      "mfussenegger/nvim-dap",
      "jfpedroza/neotest-elixir",
      "weilbith/neotest-gradle",
    },
    opts = {},
    config = function()
      local neotest = require("neotest")

      local neotest_jest = require("neotest-jest")({
        jestCommand = "npm test --",
      })
      neotest_jest.filter_dir = function(name)
        return name ~= "node_modules" and name ~= "__snapshots__"
      end

      neotest.setup({
        adapters = {
          require("neotest-gradle"),
          require("neotest-rspec")({
            rspec_cmd = function()
              return vim.tbl_flatten({
                "bundle",
                "exec",
                "rspec",
              })
            end,
          }),
          neotest_jest,
          require("neotest-minitest"),
          require("neotest-elixir"),
        },
        output_panel = {
          enabled = true,
          open = "botright split | resize 15",
        },
        quickfix = {
          open = false,
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        config = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open({})
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close({})
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close({})
          end
        end,
      },
      {
        "suketa/nvim-dap-ruby",
        config = function()
          require("dap-ruby").setup()
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          automatic_installation = true,
          handlers = {},
          ensure_installed = {},
        },
      },
      { "jbyuki/one-small-step-for-vimkind", module = "osv" },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = {
            { "fileformat", "filetype" },
            {
              require("noice").api.statusline.mode.get,
              cond = require("noice").api.statusline.mode.has,
              color = { fg = "#ff9e64" },
            },
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        extensions = { "fugitive", "quickfix", "fzf", "lazy", "mason", "nvim-dap-ui", "oil", "trouble" },
      })
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  {
    "junegunn/fzf",
    build = ":call fzf#install()",
  },
  "nanotee/zoxide.vim",
  "nvim-telescope/telescope-ui-select.nvim",
  "debugloop/telescope-undo.nvim",
  {
    "voldikss/vim-floaterm",
    config = function()
      vim.keymap.set(
        "n",
        "<leader>ft",
        "<cmd>:FloatermNew --height=0.7 --width=0.8 --wintype=float --name=floaterm1 --position=center --autoclose=2<CR>",
        { desc = "Open FloatTerm" }
      )
      vim.keymap.set("n", "<leader>flt", "<cmd>:FloatermToggle<CR>", { desc = "Toggle FloatTerm" })
      vim.keymap.set("t", "<leader>flt", "<cmd>:FloatermToggle<CR>", { desc = "Toggle FloatTerm" })
    end,
  },
  {
    "tummetott/unimpaired.nvim",
    config = function()
      require("unimpaired").setup()
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          -- Actions
          map("n", "<leader>hs", gs.stage_hunk, { desc = "GitSigns state hunk" })
          map("n", "<leader>hr", gs.reset_hunk, { desc = "GitSigns reset hunk" })
          map("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "GitSigns stage_hunk" })
          map("v", "<leader>hr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "GitSigns reset_hunk" })
          map("n", "<leader>hS", gs.stage_buffer, { desc = "GitSigns stage_buffer" })
          map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "GitSigns undo_stage_hunk" })
          map("n", "<leader>hR", gs.reset_buffer, { desc = "GitSigns reset_buffer" })
          map("n", "<leader>hp", gs.preview_hunk, { desc = "GitSigns preview_hunk" })
          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end, { desc = "GitSigns blame line" })
          map("n", "<leader>htb", gs.toggle_current_line_blame, { desc = "GitSigns toggle blame" })
          map("n", "<leader>hd", gs.diffthis, { desc = "GitSigns diffthis" })
          map("n", "<leader>hD", function()
            gs.diffthis("~")
          end, { desc = "GitSigns diffthis" })
          map("n", "<leader>htd", gs.toggle_deleted, { desc = "GitSigns toggle_deleted" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "GitSigns select hunk" })
        end,
      })
    end,
  },
  "mg979/vim-visual-multi",
  "tpope/vim-rails",
  {
    "williamboman/mason.nvim",
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      local mason = require("mason")

      local mason_tool_installer = require("mason-tool-installer")

      -- enable mason and configure icons
      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      mason_tool_installer.setup({
        ensure_installed = {
          "standardrb",
          "prettier",
          "prettierd",
          "ktlint",
          "eslint_d",
          "google-java-format",
          "htmlbeautifier",
          "beautysh",
          "buf",
          "rustfmt",
          "yamlfix",
          "taplo",
          "shellcheck",
        },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    opts = {},
  },
  { "nvim-telescope/telescope-live-grep-args.nvim" },
  {
    "aaronhallaert/advanced-git-search.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-fugitive",
      "tpope/vim-rhubarb",
    },
  },
}
