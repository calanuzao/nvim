-- leader key is space bar (some keymappings need to be changed for better configuration)

return {
  -- indentation
  {
    'vidocqh/auto-indent.nvim',
    opts = {},
  },
  -- beeps sound effects (sound folder is required + plugin configuration)
{
    "EggbertFluffle/beepboop.nvim",
    max_sounds = 20,
    sound_map = {

    }
  },
  -- 8bit sound effects
{
  "jackplus-xyz/player-one.nvim",
  ---@type PlayerOne.Config
  opts = {
      master_volume = 0.06,
      theme = "chiptune",
    },
},
  -- homepage tips 
{
  "TobinPalmer/Tip.nvim",
  event = "VimEnter",
  init = function()
    -- Default config
    --- @type Tip.config
    require("tip").setup({
      seconds = 2,
      title = "Tip!",
      url = "https://vtip.43z.one", -- Or https://vimiscool.tech/neotip
    })
  end,
},
  -- scrollbar
{
    'Xuyuanp/scrollbar.nvim',
    -- no setup required
    init = function()
        local group_id = vim.api.nvim_create_augroup('scrollbar_init', { clear = true })

        vim.api.nvim_create_autocmd({ 'BufEnter', 'WinScrolled', 'WinResized' }, {
            group = group_id,
            desc = 'Show or refresh scrollbar',
            pattern = { '*' },
            callback = function()
                require('scrollbar').show()
            end,
        })
    end,
},
  -- finder window 
{
  'simonmclean/triptych.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'nvim-tree/nvim-web-devicons', -- optional for icons
    'antosha417/nvim-lsp-file-operations' -- optional LSP integration
  },
  opts = {}, -- config options here
  keys = {
    { '<leader>-', ':Triptych<CR>' },
  },
},
  -- transparent background warning fix
{
  "rcarriga/nvim-notify",
  config = function()
    require("notify").setup({
      background_colour = "#000000", -- prevent transparency-related warning
    })
  end,
},
{
  -- transparent background
  "xiyaowong/transparent.nvim",
  config = function()
     require("transparent").setup({
       enable = true,
       extra_groups = {
         "NormalFloat",
         "NvimTreeNormal",
         "TelescopeNormal",
       },
       exclude = {}, -- optional
     })
     vim.cmd("TransparentEnable")
   end
},
  -- icons
{
  'nvim-tree/nvim-web-devicons',
  lazy = true
},
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
  -- vim-matlab
{
  "daeyun/vim-matlab",
  dependencies = {
    "neovim/python-client",
  },
},
  -- Neoscroll
{
    "karb94/neoscroll.nvim",
    lazy = false,
    config = function()
      require('neoscroll').setup({
        -- Add your custom options here
      })
    end,
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
    vim.g.copilot_auto_trigger = false  -- Automatically trigger suggestions as you type
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
  -- Terminal Management
  {
    'akinsho/toggleterm.nvim',
    config = function()
      -- Store default cursor style on startup
      vim.g.default_guicursor = vim.opt.guicursor:get()
      
      require("toggleterm").setup{
        size = 120,
        open_mapping = [[<C-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float", -- "horizontal", "vertical", "tab", "float"
        close_on_exit = false,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
        -- Set line cursor for all modes when terminal opens
        on_open = function(term)
          -- This sets a vertical line cursor for ALL modes (a:ver25)
          vim.api.nvim_buf_set_option(term.bufnr, "guicursor", "a:ver25-Cursor")
        end,
        -- Reset cursor when terminal is hidden
        on_exit = function()
          vim.opt.guicursor = vim.g.default_guicursor
        end,
      }

      -- keymaps for toggleterm
      local keymap = vim.api.nvim_set_keymap
      local opts = { noremap = true, silent = true }

      -- Escape from terminal mode
      keymap('t', '<esc>', '<C-\\><C-n>', opts)

      -- Alternative approach: Use autocmd for ToggleTerm buffers
      vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
        pattern = "term://*toggleterm#*",
        callback = function()
          vim.opt_local.guicursor = "a:ver25-Cursor"
        end
      })

      -- Reset when leaving terminal buffer
      vim.api.nvim_create_autocmd("BufLeave", {
        pattern = "term://*toggleterm#*",
        callback = function()
          vim.opt.guicursor = vim.g.default_guicursor
        end
      })
    end
  },
  { 
    "tpope/vim-projectionist" 
  },
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
      -- vim.keymap.set('n', '<C-e>', ':Neotree toggle<CR>', { silent = true, noremap = true })
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
-- Alpha Dashboard with custom git contribution visualization
{
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { 
    "nvim-tree/nvim-web-devicons",
    "nvim-lua/plenary.nvim"  -- For async operations and path handling
  },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    local plenary_path = require("plenary.path")
    local Job = require("plenary.job")
    
    -- Define your custom logo
    dashboard.section.header.val = {
      [[⣿⣿⣿⣿⣿⣶⣄⣠⣴⣶⣶⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⡇⠀⣿⣿⠆⢰⣿⣷⠀ ]],
      [[⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⢀⣄⣀⠀⠀⠀⣀⣠⣄⣀⣀⣀⠀⠸⣿⣿⠀⠀⠀⢀⡀⠀⣀⡀⠀⠀⠀⠀⣀⣠⣄⣸⣿⡇⠀⢈⣉⡀⠀⣉⣁⠀ ]],
      [[⠛⠿⣿⣿⣿⣿⣿⣷⣹⣿⣿⣿⣧⠀⣰⣷⠀⠘⠿⣿⠇⠀⣾⣿⠿⠻⢿⣿⣿⠀⠀⣿⣿⠀⢀⣾⣿⡇⠀⢿⣿⣦⡀⢀⣾⣿⠟⠻⢿⣿⣿⠀⢸⣿⡇⠀⣿⣿⡆ ]],
      [[⠀⢸⣿⣿⣿⡛⣿⣿⣷⣿⣿⣿⠟⠀⣿⣿⠀⠀⠀⠀⠀⢸⣿⡏⠀⠀⠀⢻⣿⡆⠀⢹⣿⡇⢸⣿⡟⠀⠀⠀⠹⣿⣧⢸⣿⡏⠀⠀⠀⣿⣿⡄⠈⣿⣿⠀⢸⣿⡇ ]],
      [[⠀⠘⠿⣿⣿⣿⣾⣿⣿⣿⠏⠁⠀⠀⢻⣿⣧⡀⠀⠀⣀⠀⣿⣿⣄⠀⠀⢸⣿⣇⠀⢸⣿⣧⠘⣿⣿⣄⠀⠀⣠⣿⡟⠘⣿⣿⣄⠀⠀⢻⣿⡇⠀⣿⣿⡄⠘⣿⣧ ]],
      [[⠀⠀  ⢸⣿⣿⣿⡏⣿⠇⠀⠀⠀⠀⠙⠿⣿⣿⣿⡿⠆⠈⠻⢿⣿⠀⠘⣿⣿⣷⠘⣿⣿⠀⠘⠻⣿⡄⠀⣿⠿⠁⠀⠘⠿⣿⣿⠀⠸⣿⡷⠀⢻⣿⡇⠀⣿⣿⠀]],
      [[                                                            ]],
      [[                       𝒸𝒶𝓁𝑜𝒹𝒾𝒾 𝓈𝓉𝓊𝒹𝒾𝑜𝓈 🐝                   ]],
      [[                                                            ]],
    }
    
    -- Create a function to generate git contribution heatmap
    local function generate_git_heatmap()
      -- Define the characters for the heatmap
      local empty = "□"
      local filled = { "■", "■", "■", "■", "■" }
      local days = { "S", "M", "T", "W", "T", "F", "S" }
      local months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" }
      
      -- Function to get contribution data using git log
      local function get_contribution_data()
        local contributions = {}
        local today = os.date("*t")
        local one_year_ago = os.date("*t", os.time() - 365 * 24 * 60 * 60)
        
        -- Format dates for git command
        local start_date = string.format("%d-%02d-%02d", one_year_ago.year, one_year_ago.month, one_year_ago.day)
        local end_date = string.format("%d-%02d-%02d", today.year, today.month, today.day)
        
        -- Check if we're in a git repository
        local is_git_repo = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null")
        if vim.v.shell_error ~= 0 then
          return nil
        end
        
        -- Get git contributions for the past year
        local output = vim.fn.system(string.format(
          "git log --date=short --format=format:%%ad --after=%s --before=%s", 
          start_date, 
          end_date
        ))
        
        -- Count contributions by date
        for date in output:gmatch("%d%d%d%d%-%d%d%-%d%d") do
          contributions[date] = (contributions[date] or 0) + 1
        end
        
        return contributions
      end
      
      -- Get contributions or return nil if not in a git repo
      local contributions = get_contribution_data()
      if not contributions then
        return nil
      end
      
      -- Generate heatmap grid
      local grid = {}
      local current_date = os.date("*t")
      local date_iter = os.date("*t", os.time() - 365 * 24 * 60 * 60)
      local week_idx = 1
      local day_idx = tonumber(os.date("%w", os.time() - 365 * 24 * 60 * 60)) + 1
      
      -- Initialize grid with empty cells
      for i = 1, 53 do
        grid[i] = {}
        for j = 1, 7 do
          grid[i][j] = 0
        end
      end
      
      -- Fill grid with contribution data
      while os.time(date_iter) <= os.time(current_date) do
        local date_str = string.format("%d-%02d-%02d", date_iter.year, date_iter.month, date_iter.day)
        local count = contributions[date_str] or 0
        
        -- Normalize count to fit in our intensity levels (0-4)
        local intensity = 0
        if count > 0 then
          intensity = math.min(math.floor(count / 2) + 1, #filled)
        end
        
        grid[week_idx][day_idx] = intensity
        
        -- Move to next day
        date_iter.day = date_iter.day + 1
        if date_iter.day > os.date("*t", os.time({year=date_iter.year, month=date_iter.month+1, day=0})).day then
          date_iter.month = date_iter.month + 1
          date_iter.day = 1
          if date_iter.month > 12 then
            date_iter.year = date_iter.year + 1
            date_iter.month = 1
          end
        end
        
        -- Update grid indices
        day_idx = day_idx + 1
        if day_idx > 7 then
          day_idx = 1
          week_idx = week_idx + 1
        end
      end
      
      -- Render the heatmap as text
      local heatmap = {}
      
      -- Add day labels
      local days_line = "    "
      for i = 1, 7 do
        days_line = days_line .. days[i] .. " "
      end
      table.insert(heatmap, days_line)
      table.insert(heatmap, "")
      
      -- Add months label and grid
      local month_label = "    "
      local prev_month = 0
      
      for i = 1, 53 do
        local week_str = ""
        -- Add month labels where they start
        local first_day_of_week = os.date("*t", os.time() - (365 - (i-1)*7) * 24 * 60 * 60)
        if first_day_of_week.month ~= prev_month then
          month_label = month_label .. months[first_day_of_week.month] .. "                  "
          prev_month = first_day_of_week.month
        end
        
        -- Format week number
        local week_num = string.format("%2d", i)
        week_str = week_str .. week_num .. ": "
        
        -- Add cells for each day
        for j = 1, 7 do
          local intensity = grid[i][j] or 0
          if intensity == 0 then
            week_str = week_str .. empty .. " "
          else
            week_str = week_str .. filled[intensity] .. " "
          end
        end
        
        table.insert(heatmap, week_str)
      end
      
      -- Insert month labels at the top
      table.insert(heatmap, 2, month_label)
      
      -- Add a title
      table.insert(heatmap, 1, "")
      table.insert(heatmap, 1, "                Git Contributions")
      
      return heatmap
    end
    
    -- Set menu with styled icons
    dashboard.section.buttons.val = {
      dashboard.button("f", "⟦⟧     Find File",               ":Telescope find_files <CR>"),        
      dashboard.button("n", "Σ      New File",                ":ene <BAR> startinsert <CR>"),
      dashboard.button("r", "Ω      Recent Files",            ":Telescope oldfiles <CR>"),
      dashboard.button("t", "φ      Find Text",               ":Telescope live_grep <CR>"),
      dashboard.button("c", "∫      Configuration",           ":e $MYVIMRC <CR>"),
      dashboard.button("m", "⌨      Keymaps",                 ":e ~/.config/nvim/lua/calanuzao/remaps.lua <CR>"),
      dashboard.button("p", "π      Plugins",                 ":e ~/.config/nvim/lua/plugins.lua <CR>"),
      dashboard.button("g", "♾️     Git Profile",             ":lua ShowGitContributions()<CR>"),   
      dashboard.button("o", "💎     Obsidian Vault",          ":e ~/Documents/ObsidianVault/ <CR>"),
      dashboard.button("l", "💤     Lazy",                    ":Lazy<CR>"),                         
      dashboard.button("q", "🚪     Quit",                    ":qa<CR>"),                           
    }

    -- Create global function to show git contributions in a floating window
    _G.ShowGitContributions = function()
      local heatmap = generate_git_heatmap()
      if not heatmap then
        vim.notify("Not in a git repository or no contribution data available", vim.log.levels.WARN)
        return
      end
      
      -- Calculate window dimensions
      local width = 60
      local height = #heatmap + 2
      local row = math.floor((vim.o.lines - height) / 2)
      local col = math.floor((vim.o.columns - width) / 2)
      
      -- Create the floating window
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, heatmap)
      
      local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded"
      })
      
      -- Set buffer options
      vim.api.nvim_buf_set_option(buf, "modifiable", false)
      vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
      
      -- Set highlighting for the heatmap
      vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal")
      
      -- Add keymaps to close the window
      vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", {silent = true, noremap = true})
      vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", {silent = true, noremap = true})
    end

    -- Styling for the sections
    dashboard.section.header.opts.hl = "Comment"
    dashboard.section.buttons.opts.hl = "Keyword"
    dashboard.section.buttons.opts.hl_shortcut = "LineNr"

    -- Dynamic footer with stats
    local function footer()
      local stats = require("lazy").stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      
      local date = os.date("%a %d %b")
      local time = os.date("%H:%M:%S")

      return "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"
          .. "  |  " .. date .. "  |  " .. time
    end

    dashboard.section.footer.val = footer()
    dashboard.section.footer.opts.hl = "NonText"

    -- Layout with padding
    dashboard.config.layout = {
      { type = "padding", val = 3 },
      dashboard.section.header,
      { type = "padding", val = 1 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    -- Configure options
    dashboard.opts.opts.noautocmd = true
    alpha.setup(dashboard.opts)
    
    -- Create autocmd to set a darker background for the dashboard
    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaReady",
      callback = function()
        vim.cmd("hi DashboardHeader guifg=#5c6370")
        vim.cmd("hi DashboardButtons guifg=#5c6370")
        vim.cmd("hi DashboardFooter guifg=#5c6370")
      end,
    })
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
  -- GitHub themes
  {
  "cocopon/iceberg.vim",
  lazy = false,
  priority = 998,
  },
  {
    "sainnhe/edge",
    lazy = false,
    priority = 998,
  },
  {
    "folke/lsp-colors.nvim",
    lazy = false,
    priority = 998,
  },
  {
    "savq/melange-nvim",
    lazy = false,
    priority = 998,
  },
  {
    "EdenEast/nightfox.nvim",  
    lazy = false,
    priority = 999,
  },
  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 998,
  },
  {
    "arcticicestudio/nord-vim",
    lazy = false,
    priority = 998,
  },
  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 998,
  },
  {
    "lifepillar/vim-solarized8",
    lazy = false,
    priority = 999,
  },
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 999,
  },
  {
    "ayu-theme/ayu-vim",
    lazy = false,
    priority = 999,
  },
  {
    "marko-cerovac/material.nvim",
    lazy = false,
    priority = 999,
  },
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 999,
  },
  {
    "drewtempelmeyer/palenight.vim",
    lazy = false,
    priority = 999,
  },
  {
    "bluz71/vim-moonfly-colors",
    lazy = false,
    priority = 999,
  },
  {
    "bluz71/vim-nightfly-colors",
    lazy = false,
    priority = 999,
  },
  {
    "kdheepak/monochrome.nvim",
    lazy = false,
    priority = 999,
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    priority = 999,
  },
  {
    "chriskempson/tomorrow-theme",
    lazy = false,
    priority = 999,
  },
  {
    "jnurmine/Zenburn",
    lazy = false,
    priority = 999,
  },
  {
    "robertmeta/nofrils",
    lazy = false,
    priority = 999,
  },
  {
    "NTBBloodbath/doom-one.nvim",
    lazy = false,
    priority = 999,
  },
  {
    "NAlexPear/Spacegray.nvim",
    lazy = false,
    priority = 999,
  },
  {
    "shaunsingh/moonlight.nvim",
    lazy = false,
    priority = 999,
  },
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 999,
  },
  {
    "vim-scripts/wombat",
    lazy = false,
    priority = 998,
  },
  {
    "olivertaylor/vacme",
    lazy = false,
    priority = 998,
  },
  {
    "TroyFletcher/vim-colors-synthwave",
    lazy = false,
    priority = 998,
  },
  {
    "danilo-augusto/vim-afterglow",
    lazy = false,
    priority = 998,
  },
  {
    "p00f/alabaster.nvim",
    lazy = false,
    priority = 998,
  },
  {
    "pineapplegiant/spaceduck",
    lazy = false,
    priority = 998,
  },
  {
    "ntk148v/komau.vim",
    lazy = false,
    priority = 998,
  },
  {
    "lunarvim/horizon.nvim",
    lazy = false,
    priority = 998,
  },
  {
    "challenger-deep-theme/vim",
    name = "challenger-deep",
    lazy = false,
    priority = 998,
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 999,
  },
  {
    "rakr/vim-one",
    lazy = false,
    priority = 999,
  },
  {
    "xiantang/darcula-dark.nvim",
    lazy = false,
    priority = 999,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "catppuccin/nvim", 
    name = "catppuccin",
    lazy = false,
    priority = 999,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 999,
  },
  {
    "rose-pine/neovim", 
    name = "rose-pine",
    lazy = false,
    priority = 1000,
  },
  {
    "dracula/vim", 
    name = "dracula",
    lazy = false,
    priority = 999,
  },
  {
    "EdenEast/nightfox.nvim",  -- Contains nightfox, duskfox, nordfox, terafox, carbonfox
    lazy = false,
    priority = 999,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 999,
  },
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 999,
  },
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 999,
  },
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 999,
  },
  {
    "tanvirtin/monokai.nvim",
    lazy = false,
    priority = 999,
  },
  {
    "sainnhe/sonokai",
    lazy = false,
    priority = 999,
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
  -- debugging code
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- DAP UI
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        config = function()
          local dap = require("dap")
          local dapui = require("dapui")
          
          dapui.setup({
            -- ui setup customization
            layouts = {
              {
                elements = {
                  { id = "scopes", size = 0.25 },
                  { id = "breakpoints", size = 0.25 },
                  { id = "stacks", size = 0.25 },
                  { id = "watches", size = 0.25 },
                },
                size = 40,
                position = "left",
              },
              {
                elements = {
                  { id = "repl", size = 0.5 },
                  { id = "console", size = 0.5 },
                },
                size = 10,
                position = "bottom",
              },
            },
          })
          
          -- DAP listeners
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open({})
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close({})
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close({})
          end
          
          -- breakpoint icon
          vim.fn.sign_define("DapBreakpoint", { text = "🐝", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
        end,
      },
      
      -- DAP Virtual Text for better visualization
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          require("nvim-dap-virtual-text").setup({
            enabled = true,
            enabled_commands = true,
            highlight_changed_variables = true,
            highlight_new_as_changed = true,
            commented = false,
            show_stop_reason = true,
            virt_text_pos = 'eol',
          })
        end,
      },
      
      -- Mason DAP integration for auto-installing adapters
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        config = function()
          local mason_dap = require("mason-nvim-dap")
          
          mason_dap.setup({
            automatic_installation = true,
            ensure_installed = { "cppdbg" },
            handlers = {
              function(config)
                mason_dap.default_setup(config)
              end,
            },
          })
          
          -- C/C++ DAP configurations
          local dap = require("dap")
          dap.configurations.c = {
            {
              name = "Launch file",
              type = "cppdbg",
              request = "launch",
              program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
              end,
              cwd = "${workspaceFolder}",
              stopAtEntry = false,
              MIMode = "lldb",
            },
            {
              name = "Attach to lldbserver :1234",
              type = "cppdbg",
              request = "launch",
              MIMode = "lldb",
              miDebuggerServerAddress = "localhost:1234",
              miDebuggerPath = "/usr/bin/lldb",
              cwd = "${workspaceFolder}",
              program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
              end,
            },
          }
          
          -- same configurations for C++
          dap.configurations.cpp = dap.configurations.c
        end,
      },
      
      -- Ruby DAP integration
      {
        "suketa/nvim-dap-ruby",
        config = function()
          require("dap-ruby").setup()
        end,
      },
      
      -- Lua debugging
      { 
        "jbyuki/one-small-step-for-vimkind",
      },
    },
    
    -- Key Mappings for DAP
    keys = {
      -- Debugger group
      { "<leader>d", desc = "Debugger", mode = { "n" } },
      
      -- Toggle breakpoint
      { "<leader>dt", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      
      -- Continue/start debugging
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      
      -- Step into
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      
      -- Step over
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      
      -- Step out
      { "<leader>du", function() require("dap").step_out() end, desc = "Step Out" },
      
      -- Open REPL
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Open REPL" },
      
      -- Run last
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      
      -- Terminate debug session
      { "<leader>dq", function() 
          require("dap").terminate()
          require("dapui").close({})
        end, 
        desc = "Terminate" 
      },
      
      -- List breakpoints
      { "<leader>db", function() require("dap").list_breakpoints() end, desc = "List Breakpoints" },
      
      -- Set exception breakpoints
      { "<leader>de", function() require("dap").set_exception_breakpoints({"all"}) end, desc = "Exception Breakpoints" },
    },
    
    config = function()
      -- Any additional DAP configuration can go here
      local dap = require("dap")
      
      -- You can add custom adapters here if needed
    end,
  },
  -- Statusline
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
  -- Add/change/delete surrounding delimiter pairs 
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
  { 
    "nvim-telescope/telescope-live-grep-args.nvim" 
  },
  {
    "aaronhallaert/advanced-git-search.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-fugitive",
      "tpope/vim-rhubarb",
    },
  },
}
