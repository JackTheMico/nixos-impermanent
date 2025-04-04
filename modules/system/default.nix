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
  ];

  jackwySystemMods = {
    nutstore.enable = true;
    docker.enable = true;
  };

  environment.systemPackages = with pkgs.userPkgs; [
    git
    wget
    ripgrep
    fd
    starship
    inputs.jackwy-nvf.packages.${system}.default
    # hyprpm requires #NOTE: ✖ failed to install headers with error code 2 (Headers missing)
    # pkg-config
    # cmake
    # meson
    # cpio

    # pkgs.vscode - hydenix's vscode version
    # pkgs.userPkgs.vscode - your personal nixpkgs version
  ];
  # ++ [inputs.jackwy-nvf.packages.${system}.default];
}
