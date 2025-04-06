# My system level fonts settings
{moduleNameSpace, ...}: {
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.fontProfiles;
in {
  options.${moduleNameSpace}.fontProfiles = {
    enable = mkEnableOption "System fonts module";
  };

  config = mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        # Possible system defaut fonts
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        # (nerdfonts.override {fonts = ["Hack" "FiraCode"];})
        maple-mono-NF
        vazir-fonts
        ubuntu_font_family
        liberation_ttf
      ];
      # Hydenix should take care of this.
      # fontconfig = {
      #   defaultFonts = {
      #     serif = [  "Liberation Serif" "Vazirmatn" ];
      #     sansSerif = [ "Ubuntu" "Vazirmatn" ];
      #     monospace = [ "Maple Mono NF" ];
      #   };
      # };
    };
  };
}
