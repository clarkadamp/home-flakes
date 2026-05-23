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

    local skeld = require("skel-nvim.defaults")

    -- given filename: "my-filename.ext" -> "my-filename"
    local filename_no_ext = function(filename)
      return skeld.get_filename(filename):gsub("%.%w+$", "")
    end

    -- given filename: "my-weird_filename" -> "myWeirdFilename"
    local function to_camel_case(dashed_or_underscore_seperated)
      return dashed_or_underscore_seperated:gsub("-(%a)", function(l)
        return l:upper()
      end)
    end

    -- given filename: "my-aspect-name.nix" -> "myAspectName"
    local function nix_aspect_name(filename)
      return to_camel_case(filename_no_ext(filename))
    end

    require("skel-nvim").setup({
      mappings = {
        ["*.java"] = { "java-class.skel", "java-interface.skel" },
        ["*.nix"] = {
          "nix/multi-context.skel",
          "nix/inheritance.skel",
          "nix/conditional.skel",
        },
      },
      substitutions = {
        ["ASPECT_NAME"] = nix_aspect_name,
        ["CLASSNAME"] = skeld.get_classname2,
        ["FILENAME"] = skeld.get_filename,
        ["FILENAME_NO_EXT"] = filename_no_ext,
        ["JAVA_PACKAGE_NAME"] = java_package_path,
      },
    })
  end,
}
