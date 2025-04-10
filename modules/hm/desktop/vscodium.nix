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
      enableUpdateCheck = false;
      userSettings = {
        "files.autoSave" = "on";
        "[nix]"."editor.tabSize" = 2;
        "[python]"."editor.tabSize" = 4;
        "extensions.experimental.affinity" = {
          "asvetliakov.vscode-neovim" = 1;
        };
        "http.proxy" = "http://localhost:7897";
        "http.proxyStrictSSL" = false;
        "https.proxy" = "http://localhost:7897";
        "roo-cline.allowedCommands" = [
          "npm test"
          "npm install"
          "tsc"
          "git log"
          "git diff"
          "git show"
        ];
      };
      extensions = with pkgs.userPkgs.vscode-extensions;
        [
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
          # Just
          nefrob.vscode-just-syntax
          # Toml
          bungcip.better-toml
          # Vue
          vue.volar
          # vue.vscode-typescript-vue-plugin # NOTE: No longer need this.
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
          # Test
          ms-vscode.test-adapter-converter
          hbenl.vscode-test-explorer
          cameron.vscode-pytest
          twpayne.vscode-testscript
        ]
        ++ [pkgs.unstable.vscode-extensions.rooveterinaryinc.roo-cline];
    };
  };
}
