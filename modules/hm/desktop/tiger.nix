{moduleNameSpace, ...}: {
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.tiger;
in {
  options.${moduleNameSpace}.tiger = {
    enable = mkEnableOption "User Fcitx5 Tiger Code Enable";
  };

  config = mkIf cfg.enable {
    home.file.".local/share/fcitx5/table/tiger.main.dict".source = ../fcitx5/table/tiger.main.dict;
    home.file.".local/share/fcitx5/inputmethod/tiger.conf".source = ../fcitx5/inputmethod/tiger.conf;
  };
}
