local U = require("cladam.utils")

local function find_python()
  local virtual_env = os.getenv("VIRTUAL_ENV")
  if virtual_env then
    vim.notify_once("Using VIRTUAL_ENV python: " .. virtual_env .. "/bin/python", vim.log.levels.DEBUG)
    return virtual_env .. "/bin/python"
  end

  local env_dir = U.findup({ ".venv", ".env", "venv" }, "directory")
  if env_dir and U.exists(env_dir .. "/bin/python") then
    vim.notify_once("Using discovered venv: " .. env_dir .. "/bin/python", vim.log.levels.DEBUG)
    return env_dir .. "/bin/python"
  end

  local system_python = U.run_command("which python")
  if system_python.return_code == 0 then
    vim.notify_once("Using system python: " .. system_python.stdout, vim.log.levels.DEBUG)
    return system_python.stdout
  end
  vim.notify_once("No python found", vim.log.levels.ERROR)
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "ninja", "python", "rst", "toml" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          python = {
            analysis = {
              autoImportCompletion = true,
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
            },
          },
          mason = false,
        },
      },
      setup = {
        basedpyright = function()
          local function setup_pyright(client, _)
            if client.name == "basedpyright" then
              client.config.settings =
                vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = find_python() } })
            end
          end
          U.on_attach(setup_pyright)
        end,
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft.python = {
        "isort",
        "black",
        "autoflake",
      }
      local conform = require("conform")
      conform.formatters = {
        black = {
          command = os.getenv("BLACK_EXECUTABLE"),
        },
        autoflake = {
          command = os.getenv("AUTOFLAKE_EXECUTABLE"),
          prepend_args = { "--ignore-init-module-imports", "--remove-all-unused-imports" },
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft.python = { "mypy", "flake8" }
      opts.setup.mypy = function(mypy)
        mypy.args = {
          "--show-column-numbers",
          "--show-error-end",
          "--hide-error-context",
          "--no-color-output",
          "--no-error-summary",
          "--no-pretty",
          "--python-executable",
          find_python(),
        }
        vim.notify_once("mypy args:" .. vim.inspect(mypy.args), vim.log.levels.DEBUG)
        -- if cobertura reports are enabled in project settings mypy will fail silently
        -- unless lxml is installed, add it to the mypy virtual environment
        vim.api.nvim_create_autocmd("User", {
          pattern = "MasonToolsUpdateCompleted",
          callback = function(e)
            if vim.tbl_contains(e.data, "mypy") then
              vim.schedule(function()
                local cmd = vim.fn.stdpath("data") .. "/mason/packages/mypy/venv/bin/python"
                local args = { "-m", "pip", "install", "lxml" }
                require("plenary.job")
                  :new({
                    command = cmd,
                    args = args,
                    on_exit = function(job, return_val)
                      if return_val == 0 then
                        vim.notify("Installed lxml into mypy venv", vim.log.levels.DEBUG)
                      else
                        vim.notify("Unable to install lxml into mypy venv: " .. job:result(), vim.log.levels.ERROR)
                      end
                    end,
                  })
                  :start()
              end)
            end
          end,
        })
      end
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    config = function()
      local dap_python = require("dap-python")
      dap_python.setup()
      dap_python.test_runner = "pytest"
      dap_python.resolve_python = find_python

      local dap = require("dap")
      dap.listeners.before.event_initialized["disable-pytest-cov"] = function()
        -- coverage.py causes breakpoints to not work
        -- https://pytest-cov.readthedocs.io/en/latest/debuggers.html
        if U.exists("setup.cfg") then
          U.run_command("sed -ie s/^\\(\\s\\+--cov\\)/#NEOVIM\\1/ setup.cfg", { notify = true })
        end
      end
      dap.listeners.before.event_exited["disable-pytest-cov"] = function()
        -- undo
        if U.exists("setup.cfg") then
          U.run_command("sed -ie s/^#NEOVIM// setup.cfg", { notify = true })
        end
      end
    end,
  },
  {
    "nvim-neotest/neotest",
    ft = "python",
    dependencies = { "nvim-neotest/neotest-python" },
    opts = function(_, opts)
      vim.env.PYTHONPATH = "doc:src:lib"
      local adapter = require("neotest-python")({
        -- Extra arguments for nvim-dap configuration
        -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
        dap = { justMyCode = true },
        runner = "pytest",
        python = find_python,
      })
      vim.list_extend(opts.adapters, { adapter })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
