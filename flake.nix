{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jackwy-nvf = {
      url = "github:JackTheMico/jackwy-nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    # home-manager = {
    #   url = "github:nix-community/home-manager/release-24.11";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Hydenix and its nixpkgs - kept separate to avoid conflicts
    hydenix = {
      # Available inputs:
      # Main: github:richen604/hydenix
      # Dev: github:richen604/hydenix/dev
      # Commit: github:richen604/hydenix/<commit-hash>
      # Version: github:richen604/hydenix/v1.0.0
      url = "github:richen604/hydenix";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    desktop-device = "/dev/disk/by-id/nvme-ZHITAI_TiPro7000_1TB_ZTA21T0KA23433024L";
    system = "x86_64-linux";
    userName = "jackwy";
    gitName = "Jack Wenyoung";
    gitEmail = "dlwxxxdlw@gmail.com";
    hydenixDesktopConfig = inputs.hydenix.inputs.hydenix-nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs userName gitName gitEmail system;};
      modules = [
        inputs.disko.nixosModules.default
        (import ./hosts/desktop/disko.nix {device = desktop-device;})
        ./hosts/desktop/configuration.nix
        inputs.impermanence.nixosModules.impermanence
      ];
    };
  in {
    nixosConfigurations = {
      # nixos = hydenixConfig;

      "${userName}-desktop" = hydenixDesktopConfig;
    };
  };
}
