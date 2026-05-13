{
  inputs,
  pkgs,
  ...
}:

{
  extraPlugins = [(pkgs.vimUtils.buildVimPlugin {
    name = "winresize";
    src = inputs.winresize;
  })];

  keymaps = [
    {
      key = "<C-w>h";
      action = ''<cmd>lua require("winresize").resize(0, 2, "left")<CR>'';
      options.desc = "Resize Window: Expand left";
    }
    {
      key = "<C-w>j";
      action = ''<cmd>lua require("winresize").resize(0, 1, "down")<CR>'';
      options.desc = "Resize Window: Expand down";
    }
    {
      key = "<C-w>k";
      action = ''<cmd>lua require("winresize").resize(0, 1, "up")<CR>'';
      options.desc = "Resize Window: Expand up";
    }
    {
      key = "<C-w>l";
      action = ''<cmd>lua require("winresize").resize(0, 2, "right")<CR>'';
      options.desc = "Resize Window: Expand right";
    }
  ];
}
