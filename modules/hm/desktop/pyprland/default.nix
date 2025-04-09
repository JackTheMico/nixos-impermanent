{moduleNameSpace, ...}: {
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.pyprland;
in {
  options.${moduleNameSpace}.pyprland = {
    enable = mkEnableOption "User Pyprland Enable";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs.userPkgs; [pyprland];
    xdg.configFile = {
      "hypr/pyprland.toml".source = config.lib.file.mkOutOfStoreSymlink ./pyprland.toml;
    };
  };
}
