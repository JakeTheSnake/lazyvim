local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

-- Workspace per project
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

-- Keymaps on attach
local function on_attach(client, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  -- Your original bindings:
  map("n", "<leader>di", function()
    jdtls.organize_imports()
  end, "Organize Imports")
  map("n", "<leader>dt", function()
    jdtls.test_class()
  end, "Test Class")
  map("n", "<leader>dn", function()
    jdtls.test_nearest_method()
  end, "Test Nearest Method")
  map("v", "<leader>de", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", "Extract Variable (V)")
  map("n", "<leader>de", function()
    jdtls.extract_variable()
  end, "Extract Variable")
  map("v", "<leader>dm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", "Extract Method (V)")
  -- Modern format API:
  map("n", "<leader>cf", function()
    vim.lsp.buf.format({ async = true })
  end, "Format")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Actions")
  map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
  map("n", "K", vim.lsp.buf.hover, "Hover")
end

local cmd = {

  "java", -- or '/path/to/java17_or_newer/bin/java'
  -- depends on if `java` is in your $PATH env variable and if it points to the right version.

  "-javaagent:/home/jake/.local/share/java/lombok.jar",
  -- '-Xbootclasspath/a:/home/jake/.local/share/java/lombok.jar',
  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.protocol=true",
  "-Dlog.level=ALL",
  -- '-noverify',
  "-Xms1g",
  "--add-modules=ALL-SYSTEM",
  "--add-opens",
  "java.base/java.util=ALL-UNNAMED",
  "--add-opens",
  "java.base/java.lang=ALL-UNNAMED",
  "-jar",
  vim.fn.glob("/home/jake/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
  -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
  -- Must point to the                                                     Change this to
  -- eclipse.jdt.ls installation                                           the actual version

  "-configuration",
  "/home/jake/.local/share/nvim/mason/packages/jdtls/config_linux",
  -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
  -- Must point to the                      Change to one of `linux`, `win` or `mac`
  -- eclipse.jdt.ls installation            Depending on your system.

  -- See `data directory configuration` section in the README
  "-data",
  workspace_dir,
}

local config = {
  cmd = cmd,
  root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
  on_attach = on_attach,
  init_options = {
    -- This is the important part
    vmArgs = "--enable-preview",
  },
  settings = {
    java = {
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
          "com.mongodb.client.model.Filters.*",
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
      },
      project = {
        sourcePaths = {
          "target/generated-sources/wsimport",
          "target/generated-sources/annotations",
        },
      },
      configuration = {
        updateBuildConfiguration = "automatic",
      },
      contentProvider = { preferred = "fernflower" },
      eclipse = { downloadSources = true },
      flags = {
        allow_incremental_sync = true,
        server_side_fuzzy_completion = true,
      },
      implementationsCodeLens = { enabled = false },
      format = { enabled = false },
      inlayHints = { parameterNames = { enabled = "literals" } },
      maven = { downloadSources = true, updateSnapshots = true },
      referencesCodeLens = { enabled = false },
      references = { includeDecompiledSources = true },
      saveActions = { organizeImports = false },
    },
  },
  handlers = {
    -- ["language/status"] = function(_, _) end,
    ["$/progress"] = function(_, _, _) end,
  },
}

jdtls.start_or_attach(config)
