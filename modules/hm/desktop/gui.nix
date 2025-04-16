{moduleNameSpace, ...}: {
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.gui;
  pinnedZoomPkgs =
    import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/0c19708cf035f50d28eb4b2b8e7a79d4dc52f6bb.tar.gz";
      sha256 = "0ngw2shvl24swam5pzhcs9hvbwrgzsbcdlhpvzqc7nfk8lc28sp3";
    }) {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
in {
  options.${moduleNameSpace}.gui = {
    enable = mkEnableOption "User Common GUI Softwares Enable";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs.userPkgs;
      [
        # freetube
        kdePackages.konsole
        keepassxc
        qq
        wechat-uos
        obsidian
        libreoffice-qt6-fresh
      ]
      ++ [pinnedZoomPkgs.zoom-us];
    programs = {
      freetube = {
        enable = true;
        settings = {
          checkForUpdates = false;
          defaultQuality = "1080";
          baseTheme = "catppuccinMocha";
        };
      };
      obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [wlrobs obs-shaderfilter input-overlay waveform];
      };
    };
  };
}
