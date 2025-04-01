{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # ./example.nix - add your modules here
  ];

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
