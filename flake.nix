{
  description = "Nixos config flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # Nixpkgs
    sops-nix = {
      url = "github:Mic92/sops-nix";
      # optional, not necessary for the module
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # my secrets
    jackwy-secrets = {
      url = "git+ssh://git@github.com/JackTheMico/jackwy-secrets.git?ref=main&shallow=1";
      flake = false;
    };

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
    # Yazi Flavors
    yazi-flavors = {
      url = "github:yazi-rs/flavors";
      flake = false;
    };

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
    sops-nix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    desktop-device = "/dev/disk/by-id/nvme-ZHITAI_TiPro7000_1TB_ZTA21T0KA23433024L";
    userName = "jackwy";
    gitName = "Jack Wenyoung";
    gitEmail = "dlwxxxdlw@gmail.com";
    hydenixDesktopConfig = inputs.hydenix.inputs.hydenix-nixpkgs.lib.nixosSystem {
      inherit (inputs.hydenix.lib) system;
      specialArgs = {inherit inputs outputs userName gitName gitEmail;};
      modules = [
        sops-nix.nixosModules.sops
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
