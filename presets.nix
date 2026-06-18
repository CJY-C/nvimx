let
  base = {
    imports = [ ./nvimx ];
  };
in
{
  default = base;
  base = base;
  configs = base // {
    nvimx.preset.configs.enable = true;
  };
  latex = base // {
    nvimx.preset.latex.enable = true;
  };
  lua = base // {
    nvimx.preset.lua.enable = true;
  };
  markdown = base // {
    nvimx.preset.markdown.enable = true;
  };
  nix = base // {
    nvimx.preset.nix.enable = true;
  };
  python = base // {
    nvimx.preset.python.enable = true;
  };
  rust = base // {
    nvimx.preset.rust.enable = true;
  };
  shells = base // {
    nvimx.preset.shells.enable = true;
  };
  typst = base // {
    nvimx.preset.typst.enable = true;
  };
}
