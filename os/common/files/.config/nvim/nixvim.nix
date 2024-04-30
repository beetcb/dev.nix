enablePkgs: pkgs:
# see -> https://nix-community.github.io/nixvim/
{
  extraConfigLua = builtins.readFile ./extra.lua;
  extraPackages = [ pkgs.xclip ];
  extraPlugins = with pkgs.vimPlugins; [
    vim-sleuth
  ];
  globals.mapleader = " ";
  options = {
    shiftwidth = 2;
    smartindent = true;
    expandtab = true;

    smartcase = true;
    ignorecase = true;
    number = true;
  };
  plugins = enablePkgs {
    # Autocompletion
    nvim-cmp = {
      autoEnableSources = true;
      # see -> https://github.com/pta2002/nixvim/blob/main/plugins/completion/nvim-cmp/cmp-helpers.nix#L12
      # settings.sources = [
      #   { name = "luasnip"; }
      #   { name = "nvim_lsp"; }
      #   { name = "nvim_lua"; }
      #   { name = "path"; }
      #   { name = "buffer"; }
      # ];
      # see -> https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/mapping.lua#L36
      # mappingPresets = [ "insert" "cmdline" ];
      mapping = {
        "<C-b>" = ''cmp.mapping(cmp.mapping.scroll_docs(-1), { "i" })'';
        "<C-f>" = ''cmp.mapping(cmp.mapping.scroll_docs(1), { "i" })'';
        "<C-e>" = "cmp.mapping(cmp.mapping.abort())";
        "<C-l>" = "cmp.mapping(cmp.mapping.complete())";
        "<CR>" = "cmp.mapping.confirm { select = true }";
      };
      # snippet.expand = "luasnip";
      formatting.fields = [ "kind" "abbr" "menu" ];
      window.completion = {
        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None";
        border = "single";
      };

      window.documentation = {
        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None";
        border = "single";
      };
    };
    lspkind = { };
    # Highlight & TreeSitter
    treesitter = {
      ensureInstalled = [ "embedded_template" ];
    };
    # Git helpers
    gitsigns = {
      currentLineBlame = true;
    };
    # Status line
    lualine = { };
    # Fuzzy finder
    telescope = { };
    # Diagnostics panel
    trouble = { };
    # LSP
    lsp = {
      servers = enablePkgs {
        gopls = { };
        rnix-lsp = { };
        # rust-analyzer = { };
        html = { };
        cssls = { };
        eslint = { };
        tsserver = { };
        # lua-ls = { };
        jsonls = { };
      };
      onAttach = ''
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        
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
        vim.keymap.set('n', '<space>cf', vim.lsp.buf.format, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

        -- See `:help vim.diagnostic.*` for documentation on any of the below functions
        local opts = { noremap=true, silent=true }
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
      '';
    };

    lsp-lines = {
      enable = true;
      currentLine = true;
    };
    none-ls = {
      sources.formatting = {
        prettier = {
          enable = true;
          disableTsServerFormatter = true;
        };
        # eslint.enable = true;
        shfmt.enable = true;
        markdownlint.enable = true;
      };
      # sources.diagnostics.shellcheck.enable = true;
    };
    nix = { };
    nvim-autopairs = { };
    surround = { };
    nvim-tree = {
      updateFocusedFile = {
        enable = true;
      };
    };
  };
  colorschemes = enablePkgs {
    nord = {
      # disable_background = true; 
      italic = false;
    };
  };
}
