{
  pkgs,
  inputs,
  system,
  userName,
  gitName,
  gitEmail,
  ...
}: let
  moduleNameSpace = "jackwySystemMods";
  args = {inherit moduleNameSpace inputs system userName gitName gitEmail;};
in {
  imports = [
    (import ./nutstore.nix args)
    (import ./docker.nix args)
    (import ./firefox.nix args)
    (import ./fonts.nix args)
    (import ./gaming.nix args)
  ];

  jackwySystemMods = {
    nutstore.enable = true;
    docker.enable = true;
    firefox.enable = true;
    fontProfiles.enable = true;
    gaming.enable = true;
  };

  programs = {
    gnupg = {
      agent = {
        enable = true;
        settings = {
          # Increase default ttl.
          default-cache-ttl = 86400;
        };
      };
    };
  };

  environment.systemPackages = with pkgs.userPkgs; [
    git
    wget
    ripgrep
    fd
    starship
    n8n
    inputs.jackwy-nvf.packages.${system}.default
    # hyprpm requires #NOTE: ✖ failed to install headers with error code 2 (Headers missing)
    # pkg-config
    # cmake
    # meson
    # cpio

    # pkgs.vscode - hydenix's vscode version
    # pkgs.userPkgs.vscode - your personal nixpkgs version
  ];

  # FIXME: Not working with /var/lib/n8n persist
  # services.n8n = {
  #   enable = true;
  #   settings = {
  #     "N8N_USER_FOLDER" = "/home/jackwy/Documents/n8n";
  #     "HOME" = "/home/jackwy/Documents/n8n";
  #   };
  # };
}
