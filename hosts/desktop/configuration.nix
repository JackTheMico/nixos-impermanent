{
  lib,
  inputs,
  userName,
  gitName,
  gitEmail,
  system,
  ...
}: let
  # Package declaration
  # ---------------------
  pkgs = import inputs.hydenix.inputs.hydenix-nixpkgs {
    inherit (inputs.hydenix.lib) system;
    config.allowUnfree = true;
    overlays = [
      inputs.hydenix.lib.overlays
      # Include your own package set to be used eg. pkgs.userPkgs.bash
      (final: prev: {
        userPkgs = import inputs.nixpkgs {
          inherit (prev) system;
          config.allowUnfree = true;
        };
      })
    ];
  };
  pShadow = "/persist/rootfs/etc/shadow";
  pShadowParent = "/persist/rootfs/etc";
in {
  # Set pkgs for hydenix globally, any file that imports pkgs will use this
  nixpkgs.pkgs = pkgs;
  imports = [
    inputs.hydenix.inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    inputs.hydenix.lib.nixOsModules
    ../../modules/system

    # === GPU-specific configurations ===

    /*
    For drivers, we are leveraging nixos-hardware
    Most common drivers are below, but you can see more options here: https://github.com/NixOS/nixos-hardware
    */

    #! EDIT THIS SECTION
    # For NVIDIA setups
    inputs.hydenix.inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    # inputs.hydenix.inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonmodeset

    # For AMD setups
    # inputs.hydenix.inputs.nixos-hardware.nixosModules.common-gpu-amd

    # === CPU-specific configurations ===
    # For AMD CPUs
    # inputs.hydenix.inputs.nixos-hardware.nixosModules.common-cpu-amd
    # inputs.hydenix.inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate

    # For Intel CPUs
    inputs.hydenix.inputs.nixos-hardware.nixosModules.common-cpu-intel

    # === Other common modules ===
    # inputs.hydenix.inputs.nixos-hardware.nixosModules.common-pc
    inputs.hydenix.inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs system userName gitName gitEmail;};
    users."${userName}" = {...}: {
      imports = [
        inputs.hydenix.lib.homeModules
        ../../modules/hm/desktop
      ];
    };
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd.postDeviceCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/root_vg/root /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-chinese-addons
          fcitx5-nord
        ];
      };
    };
  };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "vim";
    # TERMINAL = "wezterm";
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  networking = {
    # hostName = "${userName}-desktop";
    wireless = {enable = false;};
    # firewall.enable = false;
    networkmanager = {enable = true;};
    # NOTE: Require clash-verge-rev or another computer which has it.
    # proxy.default = "http://127.0.0.1:7897";
    # proxy.noProxy = "127.0.0.1,localhost,.localdomain";
  };
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    optimise.automatic = true;

    # NOTE: For devenv, uncomment this later after the installation
    # extraOptions = ''
    #   trusted-users = root jackwenyoung
    #   extra-substituters = https://devenv.cachix.org
    #   extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    # '';
  };

  services.openssh.enable = true;

  # system.stateVersion = "24.11"; # Did you read the comment?
  system.stateVersion = "25.05"; # Did you read the comment?

  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }
    ];
    files = [
      "/etc/machine-id"
      {
        file = "/var/keys/secret_file";
        parentDirectory = {mode = "u=rwx,g=,o=";};
      }
    ];
  };
  systemd.tmpfiles.rules = [
    "d /persist/home/ 0777 root root -" # create /persist/home owned by root
    "d /persist/rootfs/etc/ 0777 root root -" # for persist changed user password
    "d /persist/home/${userName} 0700 ${userName} users -" # /persist/home/<user> owned by that user
    "d /persist/nixos/ 0700 ${userName} users -" # /persist/nixos owned by that user
  ];
  # NOTE: https://github.com/nix-community/impermanence/issues/120#issuecomment-2382674299
  system.activationScripts = {
    etc_shadow = ''
      [ -f "/etc/shadow" ] && cp /etc/shadow ${pShadow}
      [ -f "${pShadow}" ] && cp ${pShadow} /etc/shadow
    '';

    users.deps = ["etc_shadow"];
  };

  systemd.services."etc_shadow_persistence" = {
    enable = true;
    description = "Persist /etc/shadow on shutdown.";
    wantedBy = ["multi-user.target"];
    path = [pkgs.util-linux];
    unitConfig.defaultDependencies = true;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      # Service is stopped before shutdown
      ExecStop = pkgs.writeShellScript "persist_etc_shadow" ''
        mkdir --parents "${pShadowParent}"
        cp /etc/shadow ${pShadow}
      '';
    };
  };

  programs = {
    fuse.userAllowOther = true;
    fish.enable = true;
    clash-verge = {
      enable = true;
      autoStart = true;
    };
  };
  # IMPORTANT: Customize the following values to match your preferences
  hydenix = {
    enable = true; # Enable the Hydenix module

    #! EDIT THESE VALUES
    hostname = "${userName}-desktop"; # Change to your preferred hostname
    timezone = "Asia/Shanghai"; # Change to your timezone
    locale = "en_US.UTF-8"; # Change to your preferred locale

    /*
    Optionally edit the below values, or leave to use hydenix defaults
    visit ./modules/hm/default.nix for more options

    audio.enable = true; # enable audio module
    boot = {
      enable = true; # enable boot module
      useSystemdBoot = true; # disable for GRUB
      grubTheme = pkgs.hydenix.grub-retroboot; # or pkgs.hydenix.grub-pochita
      grubExtraConfig = ""; # additional GRUB configuration
      kernelPackages = pkgs.linuxPackages_zen; # default zen kernel
    };
    hardware.enable = true; # enable hardware module
    network.enable = true; # enable network module
    nix.enable = true; # enable nix module
    sddm = {
      enable = true; # enable sddm module
      theme = pkgs.hydenix.sddm-candy; # or pkgs.hydenix.sddm-corners
    };
    system.enable = true; # enable system module
    */
  };
  #! EDIT THESE VALUES (must match users defined above)
  users.users."${userName}" = {
    isNormalUser = true; # Regular user account
    initialPassword = "qwer1234"; # Default password (CHANGE THIS after first login with passwd)
    extraGroups = [
      "wheel" # For sudo access
      "networkmanager" # For network management
      "video" # For display/graphics access
      # Add other groups as needed
      "input"
      "davfs2"
      "docker"
      "podman"
    ];
    shell = pkgs.fish; # Change if you prefer a different shell
  };
}
