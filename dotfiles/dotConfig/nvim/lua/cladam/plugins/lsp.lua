local function get_keys(t)
  local keys = {}
  for key, _ in pairs(t) do
    table.insert(keys, key)
  end
  return keys
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = { ensure_installed = {} },
        config = function(_, opts)
          require("mason-tool-installer").setup(opts)
        end,
      },
      { "j-hui/fidget.nvim", tag = "legacy", opts = {}, event = "LspAttach" },
      { "antosha417/nvim-lsp-file-operations", config = true },
    },
    opts = {
      servers = {},
    },
    config = function(_, opts)
      vim.lsp.config(
        "*",
        ---@type vim.lsp.Config
        {
          capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()),
          root_markers = { ".git", "Config" },
        }
      )
      for server, settings in pairs(opts.servers) do
        vim.lsp.config(server, { settings = settings })
      end
      vim.lsp.enable(get_keys(opts.servers))

      local U = require("cladam.utils")
      U.on_attach(function(_, bufnr)
        -- NOTE: Remember that lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself
        -- many times.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local nmap = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end

        nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

        nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
        nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
        nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
        nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

        -- See `:help K` for why this keymap
        nmap("K", vim.lsp.buf.hover, "Hover Documentation")
        nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

        -- Lesser used LSP functionality
        nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
        nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
        nmap("<leader>wl", function(client, buffer)
          vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "[W]orkspace [L]ist Folders")

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
          vim.lsp.buf.format()
        end, { desc = "Format current buffer with LSP" })
      end)

      U.on_attach(function(client, buffer)
        -- if client.supports_method("textdocument/inlayhint") or vim.tbl_contains({ "jdtls" }, client.name) then
        -- vim.notify_once("inlays supported: " .. client.name)
        vim.api.nvim_create_autocmd({ "InsertEnter" }, {
          callback = function()
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end,
        })
        vim.api.nvim_create_autocmd({ "InsertLeave" }, {
          callback = function()
            vim.lsp.inlay_hint.enable(false, { bufnr = buffer })
          end,
        })
        -- else
        -- vim.notify_once("inlays not supported: " .. client.name)
        -- end
      end)

      local has_hooks, hooks = pcall(require, "work_hooks")
      if has_hooks then
        U.on_attach(hooks.add_workspace_roots)
      end
    end,
  },
}
