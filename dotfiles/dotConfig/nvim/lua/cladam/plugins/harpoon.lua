return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local harpoon = require("harpoon")

    -- basic telescope configuration
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers")
        .new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
            results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
        })
        :find()
    end

    vim.keymap.set("n", "<C-e>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
      -- toggle_telescope(harpoon:list())
    end, { desc = "Harpoon toggle quick menu" })

    vim.keymap.set("n", "<C-a>", function()
      harpoon:list():add()
    end, { desc = "Harpoon [A]dd File" })

    vim.keymap.set("n", "<M-j>", function()
      harpoon:list():select(1)
    end, { desc = "Harpoon goto file in position 1" })
    vim.keymap.set("n", "<M-k>", function()
      harpoon:list():select(2)
    end, { desc = "Harpoon goto file in position 2" })
    vim.keymap.set("n", "<M-l>", function()
      harpoon:list():select(3)
    end, { desc = "Harpoon goto file in position 3" })
    vim.keymap.set("n", "<M-;>", function()
      harpoon:list():select(4)
    end, { desc = "Harpoon goto file in position 4" })
  end,
}
