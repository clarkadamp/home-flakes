local U = require("cladam.utils")
local function find_jdtls_java()
  if os.getenv("JDTLS_JAVA_HOME") ~= nil then
    return os.getenv("JDTLS_JAVA_HOME") .. "/bin/java"
  end
  local jvm_locations = {
    "/Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk/Contents/Home/bin/java",
    "/usr/lib/jvm/java-21-amazon-corretto/bin/java",
  }
  for _, path in ipairs(jvm_locations) do
    if U.exists(path) then
      return path
    end
  end
  vim.notify("Amazon Corretto 17 not installed", vim.log.levels.ERROR)
  return nil
end

local jdtls_java_path = find_jdtls_java()
if jdtls_java_path == nil then
  return
end

local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

local function config_system()
  local system
  if U.run_command("uname").stdout == "Darwin" then
    system = "config_mac"
  else
    system = "config_linux"
  end
  if string.find(U.run_command("uname -m").stdout, "arm") ~= nil then
    system = system .. "_arm"
  end
  return jdtls_path .. "/" .. system
end

local function eclipse_workspace()
  local path = ".eclipse/"
  local hooks_exist, hooks = pcall(require, "work_hooks")
  if hooks_exist then
    path = hooks.eclipse_path()
  end
  vim.fn.mkdir(path, "p")
  return path
end
local ws_root_dir = require("jdtls.setup").find_root({ "packageInfo" }, "Config")

local ws_folders_jdtls = {}
if ws_root_dir then
  local file = io.open(ws_root_dir .. "/.bemol/ws_root_folders")
  if file then
    for line in file:lines() do
      table.insert(ws_folders_jdtls, "file://" .. line)
    end
    file:close()
  end
end

local cmp_capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
local InstallLocation = require("mason-core.installer.InstallLocation")
local java_debug_root = InstallLocation.global():package("java-debug-adapter")
local bundles = {
  vim.fn.glob(java_debug_root .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
}
local java_test_root = InstallLocation.global():package("java-test")
vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_root .. "/extension/server/*.jar", true), "\n"))

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    find_jdtls_java(),
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx4g",
    "-javaagent:" .. jdtls_path .. "/lombok.jar",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),

    -- 💀
    "-configuration",
    config_system(),
    -- See `data directory configuration` section in the README
    "-data",
    eclipse_workspace(),
  },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = require("jdtls.setup").find_root({ ".git", "Config" }),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      signatureHelp = {
        enabled = true,
      },
      configuration = {
        -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        -- And search for `interface RuntimeOption`
        -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
        -- TODO: Figure out how to deal with multiple runtimes
        -- runtimes = {
        --   {
        --     name = "JavaSE_1_8",
        --     path = ws_root_dir .. "/env/OpenJDK8-1.1/runtime/jdk1.8/",
        --     default = true,
        --   },
        -- }
      },
      completion = {
        guessMethodArguments = true,
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.junit.jupiter.api.Assumptions.*",
          "org.junit.jupiter.api.DynamicContainer.*",
          "org.junit.jupiter.api.DynamicTest.*",
          "org.mockito.Matchers.*",
          "org.mockito.Mockito.*",
        },
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = "all", -- literals, all, none
        },
      },
      extendedClientCapabilities = require("jdtls").extendedClientCapabilities,
      format = {
        settings = {
          url = vim.fn.stdpath("config") .. "/tidbits/eclipse-java-google-style.xml",
          profile = "GoogleStyle",
        },
      },
    },
    capabilities = cmp_capabilities,
  },
  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = bundles,
    workspaceFolders = ws_folders_jdtls,
  },
}
vim.notify_once(vim.inspect(cmp_capabilities), vim.log.levels.DEBUG)
vim.notify_once(vim.inspect(config.settings.java.extendedClientCapabilities), vim.log.levels.DEBUG)
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require("jdtls").start_or_attach(config)
