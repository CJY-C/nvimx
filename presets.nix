lib:
let
  base = {
    imports = [ ./nvimx ];
  };
  # Helper to generate a preset package configuration enabling a list of presets
  mkPreset = presets: base // {
    nvimx.preset = lib.genAttrs presets (name: { enable = true; });
  };
in
{
  default = base;
  base = base;
  configs = mkPreset [ "configs" ];
  latex = mkPreset [ "latex" ];
  lua = mkPreset [ "lua" ];
  markdown = mkPreset [ "markdown" ];
  nix = mkPreset [ "nix" ];
  python = mkPreset [ "python" ];
  rust = mkPreset [ "rust" ];
  shells = mkPreset [ "shells" ];
  typst = mkPreset [ "typst" ];

  # Pre-composed preset package containing all language configurations
  all = mkPreset [ "configs" "latex" "lua" "markdown" "nix" "python" "rust" "shells" "typst" ];
}
