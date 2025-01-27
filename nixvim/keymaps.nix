{
  ## Command alias
  extraConfigVim = ''
    cnoreabbrev q qa
    cnoreabbrev Q q
    cnoreabbrev Q! q!
    cnoreabbrev q1 q!
    cnoreabbrev Q1 q!
    cnoreabbrev W w
    cnoreabbrev Wq wq
    cnoreabbrev WQ wq
    cnoreabbrev wQ wq
    cnoreabbrev wq1 wq!
    cnoreabbrev wQ! wq!
    cnoreabbrev Wq! wq!
    cnoreabbrev wQ1 wq!
    cnoreabbrev Wq1 wq!
    cnoreabbrev WQ1 wq!
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
