return {
  "motosir/skel-nvim",
  config = function()
    local U = require("cladam.utils")
    local function java_package_path(cfg)
      local package_path = vim.fn.split(U.findup("com", "directory", cfg.filename), "/")
      local file_path = vim.fn.split(cfg.filename, "/")
      file_path = vim.fn.slice(file_path, 0, vim.tbl_count(file_path) - 1) -- Remove filename
      for _, path_section in ipairs({ -- iteratively remove paths from the base
        package_path, -- remove packagePath/src
        { "main", "java" },
      }) do
        local path_start = vim.fn.slice(file_path, 0, vim.tbl_count(path_section))
        if table.concat(path_start) == table.concat(path_section) then
          file_path = vim.fn.slice(file_path, vim.tbl_count(path_section), vim.tbl_count(file_path))
        end
      end
      return vim.fn.join(file_path, ".")
    end

    require("skel-nvim").setup({
      mappings = {
        ["*.java"] = { "java-class.skel", "java-interface.skel" },
      },
      substitutions = {
        ["JAVA_PACKAGE_NAME"] = java_package_path,
      },
    })
  end,
}
