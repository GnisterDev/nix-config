-- Language servers, completion, formatting and linting. 
-- Binaries come from Nix (modules/dev/language-servers.nix)
local servers = {
  nil_ls = {
    cmd = "nil",
    settings = {
      ["nil"] = {
        formatting = { command = { "nixfmt" } },
        nix = { flake = { autoArchive = false } },
      },
    },
  },
  lua_ls = {
    cmd = "lua-language-server",
    settings = { Lua = { workspace = { checkThirdParty = false }, telemetry = { enable = false } } },
  },
  ts_ls = { cmd = "typescript-language-server" },
  basedpyright = { cmd = "basedpyright-langserver" },
  ruff = { cmd = "ruff" },
  rust_analyzer = { cmd = "rust-analyzer" },
  gopls = { cmd = "gopls" },
  clangd = { cmd = "clangd" },
  bashls = { cmd = "bash-language-server" },
  yamlls = { cmd = "yaml-language-server" },
  taplo = { cmd = "taplo" },
  marksman = { cmd = "marksman" },
}

local function installed(linters)
  local lint = require("lint")
  return vim.tbl_filter(function(name)
    local linter = lint.linters[name]
    if type(linter) == "function" then
      linter = linter()
    end
    local cmd = linter and linter.cmd
    if type(cmd) == "function" then
      cmd = cmd()
    end
    return cmd ~= nil and vim.fn.executable(cmd) == 1
  end, linters)
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "saghen/blink.cmp" },
    config = function()
      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
      for name, server in pairs(servers) do
        if server.settings then
          vim.lsp.config(name, { settings = server.settings })
        end
        if vim.fn.executable(server.cmd) == 1 then
          vim.lsp.enable(name)
        end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-keys", { clear = true }),
        callback = function(ev)
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>uh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
          end, "Toggle inlay hints")
        end,
      })
    end,
  },

  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = { preset = "default" },
      appearance = { nerd_font_variant = "mono" },
      completion = { documentation = { auto_show = true, auto_show_delay_ms = 300 } },
      signature = { enabled = true },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      -- The Rust fuzzy matcher is prebuilt by Nix.
      fuzzy = { implementation = "prefer_rust_with_warning", prebuilt_binaries = { download = false } },
    },
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } },
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        desc = "Format buffer",
      },
      {
        "<leader>uf",
        function()
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          vim.notify("Format on save " .. (vim.g.disable_autoformat and "off" or "on"))
        end,
        desc = "Toggle format on save",
      },
    },
    opts = {
      formatters_by_ft = {
        nix = { "nixfmt" },
        lua = { "stylua" },
        python = { "ruff_organize_imports", "ruff_format" },
        rust = { "rustfmt" },
        go = { "gofmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        toml = { "taplo" },
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
      format_on_save = function(buf)
        if vim.g.disable_autoformat or vim.b[buf].disable_autoformat then
          return
        end
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
    },
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        nix = { "statix", "deadnix" },
      }
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("lint", { clear = true }),
        callback = function()
          local linters = installed(lint.linters_by_ft[vim.bo.filetype] or {})
          if #linters > 0 then
            lint.try_lint(linters)
          end
        end,
      })
    end,
  },
}
