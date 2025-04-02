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
    wl-clipboard
    starship
    inputs.jackwy-nvf.packages.${system}.default
    # pkgs.vscode - hydenix's vscode version
    # pkgs.userPkgs.vscode - your personal nixpkgs version
  ];
  # ++ [inputs.jackwy-nvf.packages.${system}.default];
}
