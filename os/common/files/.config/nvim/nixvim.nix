enablePkgs:
{
  extraConfigLua = builtins.readFile ./extra.lua;
  globals.mapleader = " ";
  options = {
    number = true;
  };
  plugins = enablePkgs {
    # Autocompletion
    nvim-cmp = {
      auto_enable_sources = true;
      # see -> https://github.com/pta2002/nixvim/blob/main/plugins/completion/nvim-cmp/cmp-helpers.nix#L12
      sources = [
        { name = "luasnip"; }
        { name = "nvim_lsp"; }
        { name = "nvim_lua"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
      # see -> https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/mapping.lua#L36
      mappingPresets = [ "insert" "cmdline" ];
      mapping = {
        "<C-b>" = ''cmp.mapping(cmp.mapping.scroll_docs(-1), { "i" })'';
        "<C-f>" = ''cmp.mapping(cmp.mapping.scroll_docs(1), { "i" })'';
        "<C-e>" = "cmp.mapping(cmp.mapping.abort())";
        "<CR>" = "cmp.mapping.confirm { select = true }";
      };
      snippet.expand = ''
        function(args)
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end
      '';
      window.documentation.max_width = 48;
    };
    lspkind = { };
    # Highlight & TreeSitter
    treesitter = { };
    # Git helpers
    fugitive = { };
    gitsigns = { };
    # Status line
    lualine = { };
    # Indent
    indent-blankline = {
      useTreesitter = true;
      showCurrentContext = true;
      showEndOfLine = true;
    };
    # Fuzzy finder
    telescope = { };
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
        jsonls = { };
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
        vim.keymap.set('n', '<space>cf', function() vim.lsp.buf.format {
          filter = function(client)
          -- Disable tsserver format
            if client.name == "tsserver" then
              return false
            end
            return true
          end,
          bufnr = bufnr, 
        } end, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

        -- Mappings.
        -- See `:help vim.diagnostic.*` for documentation on any of the below functions
        local opts = { noremap=true, silent=true }
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
      '';
    };
    null-ls = {
      sources.formatting.prettier.enable = true;
      sources.diagnostics.shellcheck.enable = true;
    };
  };
  colorschemes = enablePkgs {
    nord = {
      contrast = true;
      disable_background = true;
      italic = false;
    };
  };
}
