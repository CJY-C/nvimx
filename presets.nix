let
  base = {
    imports = [ ./nvimx ];
  };
in
{
  default = base;
  base = base;
  configs = base // { nvimx.preset.configs.enable = true; };
  latex = base // { nvimx.preset.latex.enable = true; };
  nix = base // { nvimx.preset.nix.enable = true; };
  shells = base // { nvimx.preset.shells.enable = true; };
  typst = base // { nvimx.preset.typst.enable = true; };
}
