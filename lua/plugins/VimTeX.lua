return {
  "lervag/vimtex",
  lazy = false,
  tag = "v2.17",
  init = function()
    vim.cmd('filetype plugin indent on')
    vim.cmd('syntax enable')
    
    -- PDF Viewer configuration - using zathura
    vim.g.vimtex_view_method = "zathura"
    
    -- Compiler configuration (disabled continuous - using auto-compile on save instead)
    vim.g.vimtex_compiler_method = 'latexmk'
    vim.g.vimtex_compiler_latexmk = {
      build_dir = '',
      callback = 1,
      continuous = 0,  -- Disabled: using autocommand for compilation on save
      executable = 'latexmk',
      options = {
        '-pdf',
        '-verbose',
        '-file-line-error',
        '-synctex=1',
        '-interaction=nonstopmode',
      },
    }
    
    -- Set local leader for VimTeX commands
    vim.g.maplocalleader = ","
    
    -- Disable overfull/underfull warnings
    vim.g.vimtex_quickfix_ignore_filters = {
      'Underfull',
      'Overfull',
    }
  end
}
