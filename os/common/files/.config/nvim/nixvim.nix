enablePkgs:
{
  extraConfigLua = builtins.readFile ./extra.lua;
  globals.mapleader = " ";
  plugins = enablePkgs {
    # Autocompletion
    nvim-cmp = {
      auto_enable_sources = true;
      # see -> https://github.com/pta2002/nixvim/blob/main/plugins/completion/nvim-cmp/cmp-helpers.nix#L12
      sources = [
        { name = "nvim_lsp"; }
        { name = "nvim_lua"; }
        { name = "lua"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
      mappingPresets = [ "insert" "cmdline" ];
    };
    lspkind = { };
    # Highlight & TreeSitter
    treesitter = { };
    # Git helpers
    fugitive = { };
    gitsigns = { };
    # Status line
    lualine = { };
    # Fuzzy finder
    telescope = {
      extensions.fzy-native = enablePkgs { };
    };
    # LSP
    lsp = {
      servers = enablePkgs {
        gopls = { };
        rnix-lsp = { };
        rust-analyzer = { };

        html = { };
        eslint = { };
        tsserver = { };
        sumneko-lua = { };

	jsonls = {};
      };
      onAttach = ''
                    -- Enable completion triggered by <c-x><c-o>
                    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        
                    -- Mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    local bufopts = { noremap=true, silent=true, buffer=bufnr }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
                    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
                    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
                    vim.keymap.set('n', '<space>wl', function()
                      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, bufopts)
                    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
                    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
                    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
                    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

                    -- Mappings.
                    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
                    local opts = { noremap=true, silent=true }
                    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
                    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
                    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
                    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
        	  '';
    };
  };
  colorschemes.nord.enable = true;
}
