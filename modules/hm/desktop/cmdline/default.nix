{moduleNameSpace, ...}: {
  config,
  inputs,
  pkgs,
  lib,
  gitName,
  gitEmail,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.cmdline;
in {
  options.${moduleNameSpace}.cmdline = {
    enable = mkEnableOption "User CMDLine Enable";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs.userPkgs;
      [
        # chezmoi
        cachix
        exercism # https://exercism.org/tracks/elixir
        grc # I forget what this for.
        gh
        # gtrash
        ghostty
        harlequin
        imgurbash2
        # TUI
        lazygit
        lazyjj
        tuir
        dooit
        smassh
        musikcube
        # -----
        just
        sops
        # spotdl # NOTE: not working
        mpv
        # youtube-tui # NOTE: not working
        jq # NOTE: JSON preview in yazi
        rich-cli # NOTE: yazi rich-preview requires
        navi # NOTE: Great cmd help tool
        nix-search-cli
        nix-inspect # # Interactive TUI for inspecting nix configs.
        nvd # Nix/NixOS package version diff tool
        nushell
        neovide
        translate-shell
        pipx
        zip
        unzip
      ]
      ++ [pkgs.yazi pkgs.devenv pkgs.lazyjournal pkgs.dooit-extras];
    programs = {
      bat = {
        enable = true;
        config = {
          theme = "dracula";
        };
        extraPackages = with pkgs.userPkgs.bat-extras; [
          batdiff
          batman
          batgrep
          batwatch
          prettybat
        ];
        themes = {
          dracula = {
            src = pkgs.fetchFromGitHub {
              owner = "dracula";
              repo = "sublime"; # Bat uses sublime syntax for its themes
              rev = "26c57ec282abcaa76e57e055f38432bd827ac34e";
              sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
            };
            file = "Dracula.tmTheme";
          };
        };
      };
      btop = {
        enable = true;
        settings = {
          color_theme = "dracula";
          theme_background = true;
          truecolor = true;
          vim_keys = true;
        };
      };
      eza = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        git = true;
        icons = "always";
        colors = "always";
      };
      fzf = {
        enable = true;
        changeDirWidgetCommand = "fd --type d";
        changeDirWidgetOptions = [
          "--preview 'eza --tree --color=always {} | head -200'"
        ];

        defaultOptions = [
          "--border"
        ];
        enableBashIntegration = true;
        enableFishIntegration = true;
        fileWidgetOptions = [
          "--preview 'bat -n --color=always --line-range :2000 {}'"
        ];
      };
      thefuck = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
      };
      nh = {
        enable = true;
        flake = "/persist/nixos";
        clean = {
          enable = true;
          extraArgs = "--keep 5 --keep-since 3d";
        };
      };
      git = {
        enable = true;
        delta = {
          enable = true;
          options = {
            decorations = {
              commit-decoration-style = "bold yellow box ul";
              file-decoration-style = "none";
              file-style = "bold yellow ul";
            };
            features = "decorations";
            whitespace-error-style = "22 reverse";
          };
        };
        userName = gitName;
        userEmail = gitEmail;
        extraConfig = {
          http.proxy = "http://127.0.0.1:7897";
          https.proxy = "http://127.0.0.1:7897";
          commit.gpgsign = true;
          user.signingkey = "A30DF874D95E6029";
        };
      };
      jujutsu = {
        enable = true;
        settings = {
          user = {
            name = gitName;
            email = gitEmail;
          };
          ui = {
            pager = "delta";
            editor = "vim";
            default-command = "log";
            diff.format = "git";
            allow-init-native = true;
          };
          signing = {
            behavior = "own";
            backend = "gpg";
            key = "A30DF874D95E6029";
          };
        };
      };
      fish = {
        enable = true;
        interactiveShellInit = ''
          fzf_configure_bindings --processes=\cp
        '';
        functions = {
          enproxy = "set -xg ALL_PROXY http://localhost:7897 ; set -xg HTTP_PROXY http://localhost:7897 ; set -xg HTTPS_PROXY http://localhost:7897; echo 'Proxy Enabled'";
          deproxy = "set -e ALL_PROXY; set -e HTTPS_PROXY; set -e HTTP_PROXY; echo 'Proxy disabled'";
          gitignore = "curl -sL https://www.gitignore.io/api/$argv";
          gitjackinit = ''
            git config commit.gpgsign true
            git config user.email "dlwxxxdlw@gmail.com"
            git config user.name "Jack Wenyoung"
            git config user.signKey "A30DF874D95E6029"
          '';
          y = ''
            function y
            	set tmp (mktemp -t "yazi-cwd.XXXXXX")
            	yazi $argv --cwd-file="$tmp"
            	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            		builtin cd -- "$cwd"
            	end
            	rm -f -- "$tmp"
            end
          '';
        };
        plugins = [
          {
            name = "done";
            inherit (pkgs.fishPlugins.done) src;
          }
          {
            name = "grc";
            inherit (pkgs.fishPlugins.grc) src;
          }
          {
            name = "fzf-fish";
            inherit (pkgs.fishPlugins.fzf-fish) src;
          }
          {
            name = "forgit";
            inherit (pkgs.fishPlugins.forgit) src;
          }
        ];
        shellAbbrs = {
          gco = "git checkout";
          npu = "nix-prefetch-url";
          dnv = "devenv";
          transe = "trans -x 127.0.0.1:7897 en:zh ";
          transz = "trans -x 127.0.0.1:7897 zh:en ";
          ls = "eza --color=always --long --no-filesize --git --icons=always --no-time --no-user --no-permissions";
          ll = "eza -l";
          la = "eza -l -a";
          lt = "eza -T";
          lg = "lazygit";
          lj = "lazyjj";
          md = "mkdir";
          ff = "fastfetch";
          jjbm = "jj bookmark s -r @- main";
          gpom = "git push -u origin main";
          czi = "chezmoi";
          ns = "nix-search";
          wgete = "wget -e 'http-proxy=http:localhost:7897; https-proxy=http://localhost:7897' ";
          ".j" = "just -f ~/.user.justfile --working-directory .";
          ",j" = "just -f ~/.user.justfile --working-directory ~";
          jt = "just";
          code = "codium --disable-gpu --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform-hint=auto --enable-wayland-ime --unity-launch %F";
          obsi = "obsidian --disable-gpu --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime %u";
        };
      };
      starship = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        enableTransience = true;
      };
      yt-dlp = {
        enable = true;
        settings = {
          proxy = "127.0.0.1:7897";
          # netrc = true;
          cookies-from-browser = "firefox";
        };
      };
      yazi = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
        flavors = {
          dracula = "${inputs.yazi-flavors}/dracula.yazi";
          catppuccin-latte = "${inputs.yazi-flavors}/catppuccin-latte.yazi";
        };
        initLua = ./yaziInit.lua;
        keymap = {
          manager.prepend_keymap = [
            {
              run = "plugin searchjump -- autocd";
              on = ["i"];
              desc = "Searchjump mode";
            }
            {
              run = "plugin ouch --args=zip";
              on = ["C"];
              desc = "Compress with ouch";
            }
          ];
        };
        settings = {
          plugin = {
            prepend_previewers = [
              # Archive previewer
              {
                mime = "application/*zip";
                run = "ouch";
              }
              {
                mime = "application/x-tar";
                run = "ouch";
              }
              {
                mime = "application/x-bzip2";
                run = "ouch";
              }
              {
                mime = "application/x-7z-compressed";
                run = "ouch";
              }
              {
                mime = "application/x-rar";
                run = "ouch";
              }
              {
                mime = "application/x-xz";
                run = "ouch";
              }
              {
                name = "*.csv";
                run = "rich-preview";
              } # for csv files
              {
                name = "*.md";
                run = "rich-preview";
              } # for markdown (.md) files
              {
                name = "*.rst";
                run = "rich-preview";
              } # for restructured text (.rst) files
              {
                name = "*.ipynb";
                run = "rich-preview";
              } # for jupyter notebooks (.ipynb)
              {
                name = "*.json";
                run = "rich-preview";
              } # for json (.json) files
            ];
          };
        };
        theme = {
          flavor = {
            light = "catppuccin-latte";
            dark = "dracula";
          };
        };
      };
      zoxide = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableNushellIntegration = true;
      };
    };
    xdg.configFile."imgurbash2/config".text = ''
      # Set to true to copy URLs of uploaded images to your clipboard
      COPY_URL_TO_CLIP=true

      # Enable/Disable information being logged within a log file
      DISABLE_LOGGING=false
    '';
    home.file.".user.justfile".source = config.lib.file.mkOutOfStoreSymlink ./justfile;
  };
}
