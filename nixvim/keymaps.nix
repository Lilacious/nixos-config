{
  ## Command alias
  extraConfigVim = ''
    cnoreabbrev Q q
    cnoreabbrev Q! qa!
    cnoreabbrev q1 qa!
    cnoreabbrev Q1 qa!
    cnoreabbrev W w
    cnoreabbrev Wq wqa
    cnoreabbrev WQ wqa
    cnoreabbrev wQ wqa
    cnoreabbrev wq1 wqa!
    cnoreabbrev wQ! wqa!
    cnoreabbrev Wq! wqa!
    cnoreabbrev wQ1 wqa!
    cnoreabbrev Wq1 wqa!
    cnoreabbrev WQ1 wqa!
  '';
  keymaps = [
    # Clear highlights on search when pressing <Esc> in normal mode
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
    }
    {
      key = "<leader>vc";
      action = ":VimtexCompile<CR>";
    }
  ];
}
