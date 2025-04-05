{moduleNameSpace, ...}: {
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.wezterm;
in {
  options.${moduleNameSpace}.wezterm = {
    enable = mkEnableOption "User WezTerm Enable";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wezterm
    ];
    programs.wezterm = {
      enable = true;
      extraConfig = builtins.readFile ./wezterm.lua;
    };
  };
}
