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

  dependencies.yazi = {
    enable = true;
    packageFallback = true;
  };

  keymaps = [
    {
      action = "<cmd>Yazi<CR>";
      key = "<leader>]";
      mode = [ "n" ]; # for some reason this cmd doesnt work in visual mode
      options.desc = "Yazi: Open files";
    }
  ];
}
