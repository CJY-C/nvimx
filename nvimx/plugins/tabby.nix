{
  inputs,
  pkgs,
  ...
}:

{
  extraPlugins = [(pkgs.vimUtils.buildVimPlugin {
    name = "tabby";
    src = inputs.tabby;
  })];

  extraConfigLua = ''
    require("tabby").setup({})
  '';
}
