return {
  "mbbill/undotree",
  config = function()
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    vim.opt.undodir = os.getenv("HOME") .. "/.undotree"
    vim.opt.undofile = true
  end,
}

-- vim: ts=2 sts=2 sw=2 et
