{moduleNameSpace, ...}: {
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.gaming;
in {
  options.${moduleNameSpace}.gaming = {
    enable = mkEnableOption "System Extra Gaming Module";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wine
      winetricks
    ];
  };
}
