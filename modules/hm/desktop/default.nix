{
  inputs,
  system,
  userName,
  gitName,
  gitEmail,
  pkgs,
  lib,
  ...
}: let
  moduleNameSpace = "jackwyHMMods";
  args = {inherit moduleNameSpace inputs system userName gitName gitEmail;};
  gitSSHFile = "/home/${userName}/.ssh/id_nixos_jackwy_desktop";
in {
  home = {
    packages = with pkgs.userPkgs; [keepassxc just];
    file = {
      ".config/hyde/config.toml" = lib.mkForce {
        source = ./hyde/config.toml;
        force = true;
        mutable = true;
      };
      ".config/kitty/kitty.conf" = lib.mkForce {
        source = ./config/kitty.conf;
        force = true;
        mutable = true;
      };
    };

    stateVersion = "25.05"; # Please read the comment before changing.
    # stateVersion = "24.11"; # Please read the comment before changing.

    # home-manager options go here
    # packages = with pkgs.userPkgs; [
    #   # pkgs.vscode - hydenix's vscode version
    #   # pkgs.userPkgs.vscode - your personal nixpkgs version
    # ];
    persistence."/persist/home/${userName}" = {
      directories = [
        "codes"
        "Downloads"
        "Games"
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        "VirtualBox VMs"
        ".gnupg"
        ".ssh"
        ".nixops"
        ".local/share"
        ".local/state/lazygit"
        ".local/state/nvf"
        ".local/state/wireplumber"
        ".local/state/hyde"
        ".config/lazygit"
        ".config/yazi/plugins"
        ".config/sops/age"
        ".config/fcitx5"
        ".config/keepassxc"
        ".config/hyde"
        ".wakatime"
        ".mozilla"
        ".cache/fish"
        ".cache/mozilla"
        ".cache/cliphist"
        ".cache/fontconfig"
        ".cache/hyde/home"
        ".cache/hyde/dcols"
        ".cache/hyde/landing"
        ".cache/hyde/thumbs"
        ".cache/kitty"
        ".cache/keepassxc"
        ".cache/qutebrowser"
        ".cache/nvf"
        ".cache/swww"
        ".cache/starship"
        ".cache/lutris"
        {
          directory = ".local/share/Steam";
          method = "symlink";
        }
      ];
      files = [
        ".screenrc"
        ".config/yazi/package.toml"
        ".cache/rofi-4.runcache"
        ".cache/rofi-entry-history.txt"
        ".cache/rofi3.druncache"
      ];
      allowOther = true;
    };
  };
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    # inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.impermanence.homeManagerModules.impermanence
    (import ./ssh.nix args)
    (import ./cmdline args)
    (import ./sops.nix args)
    (import ./qutebrowser.nix args)
  ];
  jackwyHMMods = {
    ssh = {
      enable = true;
      githubIdentityFile = gitSSHFile;
      giteeIdentityFile = gitSSHFile;
    };
    cmdline.enable = true;
    sopsnix.enable = true;
    qutebrowser.enable = true;
  };

  # hydenix home-manager options go here
  hydenix.hm = {
    #! Important options
    enable = true;

    # /*
    # ! Below are defaults

    comma.enable = true; # useful nix tool to run software without installing it first
    dolphin.enable = true; # file manager
    editors = {
      enable = false; # enable editors module
      neovim.enable = true; # enable neovim module
      vscode = {
        enable = true; # enable vscode module
        wallbash = true; # enable wallbash extension for vscode
      };
      vim.enable = true; # enable vim module
      default = "vim"; # default text editor
    };
    fastfetch.enable = true; # fastfetch configuration
    firefox = {
      enable = true; # enable firefox module
      useHydeConfig = false; # use hyde firefox configuration and extensions
      useUserChrome = true; # if useHydeConfig is true, apply hyde userChrome CSS customizations
      useUserJs = true; # if useHydeConfig is true, apply hyde user.js preferences
      useExtensions = true; # if useHydeConfig is true, install hyde firefox extensions
    };
    gaming.enable = true; # enable gaming module
    git = {
      enable = false; # enable git module
      name = gitName; # git user name eg "John Doe"
      email = gitEmail; # git user email eg "john.doe@example.com"
    };
    hyde.enable = true; # enable hyde module
    hyprland.enable = true; # enable hyprland module
    lockscreen = {
      enable = true; # enable lockscreen module
      hyprlock = true; # enable hyprlock lockscreen
      swaylock = false; # enable swaylock lockscreen
    };
    notifications.enable = true; # enable notifications module
    qt.enable = true; # enable qt module
    rofi.enable = true; # enable rofi module
    screenshots = {
      enable = true; # enable screenshots module
      grim.enable = true; # enable grim screenshot tool
      slurp.enable = true; # enable slurp region selection tool
      satty.enable = true; # enable satty screenshot annotation tool
      swappy.enable = false; # enable swappy screenshot editor
    };
    shell = {
      enable = true; # enable shell module
      zsh.enable = false; # enable zsh shell
      zsh.configText = ""; # zsh config text
      bash.enable = false; # enable bash shell
      fish.enable = false; # enable fish shell
      pokego.enable = true; # enable Pokemon ASCII art scripts
    };
    social = {
      enable = true; # enable social module
      discord.enable = true; # enable discord module
      webcord.enable = false; # enable webcord module
      vesktop.enable = true; # enable vesktop module
    };
    spotify.enable = true; # enable spotify module
    swww.enable = true; # enable swww wallpaper daemon
    terminals = {
      enable = true; # enable terminals module
      kitty.enable = true; # enable kitty terminal
      kitty.configText = ""; # kitty config text
    };
    theme = {
      enable = true; # enable theme module
      active = "Catppuccin Mocha"; # active theme name
      themes = [
        "Abyssal-Wave"
        "Catppuccin Mocha"
        "Catppuccin Latte"
        "Dracula"
        "One Dark"
        "Tokyo Night"
      ]; # default enabled themes, full list in https://github.com/richen604/hydenix/tree/main/hydenix/sources/themes
    };
    waybar.enable = true; # enable waybar module
    wlogout.enable = true; # enable wlogout module
    xdg.enable = true; # enable xdg module
    # */
  };
}
