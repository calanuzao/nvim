--[[
================================================================================
LSP (Language Server Protocol) CONFIGURATION
================================================================================

This file configures the complete LSP setup including:
- Language servers for multiple programming languages
- Auto-completion with nvim-cmp
- Code snippets with LuaSnip
- Mason for LSP server management
- Custom keybindings for LSP features

Languages supported:
- Frontend: TypeScript, JavaScript, HTML, CSS, Tailwind
- Backend: Rust, Python, Java, Kotlin, Elixir  
- Systems: Bash, Docker, Terraform
- Markup: Markdown, JSON, Lua

This configuration is well-organized and documented while preserving all
existing functionality.
================================================================================
--]]

return {
  "VonHeikemen/lsp-zero.nvim",
  branch = "v2.x",
  dependencies = {
    --[[
    ============================================================================
    LSP SUPPORT PLUGINS
    ============================================================================
    --]]
    { "neovim/nvim-lspconfig" }, -- Core LSP configuration
    { 
      "williamboman/mason.nvim", -- LSP server installer
      build = function()
        pcall(vim.cmd, "MasonUpdate")
      end,
    },
    { "williamboman/mason-lspconfig.nvim" }, -- Mason <-> lspconfig integration

    --[[
    ============================================================================
    AUTOCOMPLETION PLUGINS
    ============================================================================
    --]]
    { "hrsh7th/nvim-cmp" },       -- Completion engine
    { "hrsh7th/cmp-nvim-lsp" },   -- LSP source for nvim-cmp
    { "L3MON4D3/LuaSnip" },       -- Snippet engine
    { "rafamadriz/friendly-snippets" }, -- Collection of snippets
    { "hrsh7th/cmp-buffer" },     -- Buffer completions
    { "hrsh7th/cmp-path" },       -- Path completions
    { "hrsh7th/cmp-cmdline" },    -- Command line completions
    { "saadparwaiz1/cmp_luasnip" }, -- Snippet completions
  },
  config = function()
    local lsp = require("lsp-zero")

    --[[
    ========================================================================
    LSP KEYBINDINGS
    ========================================================================
    
    These keybindings are automatically applied to all LSP-enabled buffers.
    All existing keybindings are preserved with better documentation.
    ========================================================================
    --]]
    lsp.on_attach(function(client, bufnr)
      local opts = { buffer = bufnr, remap = false }

      -- Navigation
      vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, 
        vim.tbl_deep_extend("force", opts, { desc = "LSP: Go to references" }))
      vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, 
        vim.tbl_deep_extend("force", opts, { desc = "LSP: Go to definition" }))
      
      -- Information
      vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, 
        vim.tbl_deep_extend("force", opts, { desc = "LSP: Show hover information" }))
      vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, 
        vim.tbl_deep_extend("force", opts, { desc = "LSP: Signature help" }))
      
      -- Workspace
      vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, 
        vim.tbl_deep_extend("force", opts, { desc = "LSP: Workspace symbols" }))
      
      -- Diagnostics
      vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.setloclist() end, 
        vim.tbl_deep_extend("force", opts, { desc = "LSP: Show diagnostics in location list" }))
      vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, 
        vim.tbl_deep_extend("force", opts, { desc = "LSP: Next diagnostic" }))
      vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, 
        vim.tbl_deep_extend("force", opts, { desc = "LSP: Previous diagnostic" }))
      
      -- Code Actions
      vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, 
        vim.tbl_deep_extend("force", opts, { desc = "LSP: Show code actions" }))
      vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, 
        vim.tbl_deep_extend("force", opts, { desc = "LSP: Show references" }))
      vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, 
        vim.tbl_deep_extend("force", opts, { desc = "LSP: Rename symbol" }))
    end)

    --[[
    ========================================================================
    MASON LSP SERVER SETUP
    ========================================================================
    
    Mason automatically installs and manages LSP servers.
    All existing servers are preserved with documentation.
    ========================================================================
    --]]
    require("mason").setup({})
    require("mason-lspconfig").setup({
      ensure_installed = {
        -- Web Development
        -- "tsserver",           -- TypeScript (commented out - may be deprecated)
        "eslint",                -- JavaScript/TypeScript linting
        "html",                  -- HTML language server
        "tailwindcss",           -- Tailwind CSS
        "jsonls",                -- JSON language server
        
        -- Systems Programming
        "rust_analyzer",         -- Rust language server
        "bashls",               -- Bash language server
        "dockerls",             -- Docker language server
        
        -- JVM Languages
        "kotlin_language_server", -- Kotlin
        "jdtls",                -- Java
        
        -- Scripting Languages
        "lua_ls",               -- Lua language server
        "pylsp",                -- Python language server
        "elixirls",             -- Elixir language server
        
        -- DevOps & Infrastructure
        "tflint",               -- Terraform linting
        
        -- Documentation
        "marksman",             -- Markdown language server
        
        -- Other Languages
        "solargraph",           -- Ruby language server
        "cucumber_language_server", -- Cucumber/Gherkin
      },
      handlers = {
        lsp.default_setup,
        
        -- Special configuration for Lua language server
        lua_ls = function()
          local lua_opts = lsp.nvim_lua_ls()
          require("lspconfig").lua_ls.setup(lua_opts)
        end,
      },
    })

    --[[
    ========================================================================
    COMPLETION CONFIGURATION
    ========================================================================
    
    Configures nvim-cmp for intelligent code completion with multiple sources.
    All existing completion settings are preserved.
    ========================================================================
    --]]
    local cmp_action = require("lsp-zero").cmp_action()
    local cmp = require("cmp")
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    -- Load VSCode-style snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Command line completion for search
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- Command line completion for commands
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })

    -- Main completion setup
    cmp.setup({
      -- Snippet engine configuration
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      
      -- Completion sources (in order of priority)
      sources = {
        { name = "nvim_lsp" },                    -- LSP completions
        { name = "luasnip", keyword_length = 2 }, -- Snippet completions
        { name = "buffer", keyword_length = 3 },  -- Buffer text completions
        { name = "path" },                        -- File path completions
      },
      
      -- Key mappings for completion
      mapping = cmp.mapping.preset.insert({
        -- Navigation
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        
        -- Confirmation
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        
        -- Snippet navigation
        ["<C-f>"] = cmp_action.luasnip_jump_forward(),
        ["<C-b>"] = cmp_action.luasnip_jump_backward(),
        
        -- Smart tab completion
        ["<Tab>"] = cmp_action.luasnip_supertab(),
        ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
      }),
    })
  end,
}
