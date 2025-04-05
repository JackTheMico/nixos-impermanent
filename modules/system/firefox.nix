{moduleNameSpace, ...}: {
  # pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.firefox;
in {
  options.${moduleNameSpace}.firefox = {
    enable = mkEnableOption "System Firefox Enable";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      policies = {
        ExtensionSettings = with builtins; let
          extension = shortId: uuid: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "normal_installed";
            };
          };
        in
          listToAttrs [
            (extension "tabby-window-tab-manager" "tabby@whatsyouridea.com")
            (extension "surfingkeys_ff" "{a8332c60-5b6d-41ee-bfc8-e9bb331d34ad}")
            (extension "tree-style-tab" "treestyletab@piro.sakura.ne.jp")
            (extension "ublock-origin" "uBlock0@raymondhill.net")
            (extension "umatrix" "uMatrix@raymondhill.net")
            (extension "darkreader" "addon@darkreader.org")
            (extension "immersive-translate" "{5efceaa7-f3a2-4e59-a54b-85319448e305}")
            (extension "keepassxc-browser" "keepassxc-browser@keepassxc.org")
            (extension "zeroomega" "suziwen1@gmail.com")
            (extension "enhancer-for-youtube" "enhancerforyoutube@maximerf.addons.mozilla.org")
            (extension "web-clipper-obsidian" "clipper@obsidian.md")
            (extension "raindropio" "jid0-adyhmvsP91nUO8pRv0Mn2VKeB84@jetpack")
            (
              extension "better-history-ng" "{058af685-fc17-47a4-991a-bab91a89533d}"
            )
          ];
        # To add additional extensions, find it on addons.mozilla.org, find
        # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
        # Then, download the XPI by filling it in to the install_url template, unzip it,
        # run `jq .browser_specific_settings.gecko.id manifest.json` or
        # `jq .applications.gecko.id manifest.json` to get the UUID
      };
    };
  };
}
