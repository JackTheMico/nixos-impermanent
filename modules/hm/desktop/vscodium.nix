{moduleNameSpace, ...}: {
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.vscodium;
in {
  options.${moduleNameSpace}.vscodium = {
    enable = mkEnableOption "User VSCodium Enable";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.userPkgs.vscodium;
      extensions = with pkgs.userPkgs.vscode-extensions; [
        # Neovim
        asvetliakov.vscode-neovim
        # Python
        ms-python.python
        ms-python.debugpy
        ms-python.flake8
        njpwerner.autodocstring
        charliermarsh.ruff
        cameron.vscode-pytest
        # Nix
        bbenoist.nix
        kamadorueda.alejandra
        # Vue
        vue.volar
        vue.vscode-typescript-vue-plugin
        # octref.vetur
        # Astro
        astro-build.astro-vscode

        # Markdown
        yzhang.markdown-all-in-one
        # Themes
        dracula-theme.theme-dracula
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
        # Spell
        yzhang.dictionary-completion
      ];
    };
  };
}
