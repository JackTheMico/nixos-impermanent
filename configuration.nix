{ pkgs, lib, inputs, userName, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  environment.systemPackages = with pkgs; [
    git
    neovim
    yazi
    wget
    ripgrep
    fd
  ];
  networking = {
    # hostName = "jackwy-desktop";
    wireless = {enable = false;};
    firewall.enable = false;
    networkmanager = {enable = true;};
    # NOTE: Require clash-verge-rev or another computer which has it.
    # proxy.default = "http://127.0.0.1:7897";
    # proxy.noProxy = "127.0.0.1,localhost,.localdomain";
  };
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    optimise.automatic = true;

    # For devenv
    extraOptions = ''
      trusted-users = root jackwenyoung
      extra-substituters = https://devenv.cachix.org
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    '';
  };
  
  services.openssh.enable = true;

  system.stateVersion = "24.11"; # Did you read the comment?

    users.users."${userName}" = {
    isNormalUser = true;
    initialPassword = "qwer1234";
    extraGroups = [ "wheel" "input" "video"]; # Enable ‘sudo’ for the user.
  };

  boot.initrd.postDeviceCommands = lib.mkAfter ''
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
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
    ];
    files = [
      "/etc/machine-id"
      { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
    ];
  };
  systemd.tmpfiles.rules = [
    "d /persist/home/ 0777 root root -" # create /persist/home owned by root
    "d /persist/home/${userName} 0700 ${userName} users -" # /persist/home/<user> owned by that user
  ]
  programs.fuse.userAllowOther = true;
  home-manager = {
    extraSpecialArgs = {inherit inputs userName;};
    users = {
      "${userName}" = import ./home.nix;
    };
  };

}
