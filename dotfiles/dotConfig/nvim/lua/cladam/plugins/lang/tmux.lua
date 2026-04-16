return {
  {
    "christoomey/vim-tmux-navigator",
    config = function()
      vim.api.nvim_create_autocmd("BufWritePost", {
        desc = "Reload tmux config on write",
        group = vim.api.nvim_create_augroup("tmux_reload_on_save", { clear = true }),
        callback = function(opts)
          if vim.bo[opts.buf].filetype == "tmux" then
            os.execute("tmux source ~/.config/tmux/tmux.conf")
          end
        end,
      })
    end,
  },
}
