{ ... }:

{
  plugins.yazi = {
    enable = true;
    settings = {
      enable_mouse_support = true;
      floating_window_scaling_factor = 1;
      open_for_directories = true;
      yazi_floating_window_border = "none";
    };
  };

  keymaps = [
    {
      action = "<cmd>Yazi<CR>";
      key = "<leader>]";
      mode = [ "n" "i" "x" "s" ];
      options.desc = "Yazi: Open files";
    }
  ];
}
