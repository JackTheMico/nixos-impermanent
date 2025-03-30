{
  description = "Nixos config flake";
     
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

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

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, home-manager, ...} @ inputs:
  let
    inherit (self) outputs;
    desktop-device = "/dev/disk/by-id/nvme-ZHITAI_TiPro7000_1TB_ZTA21T0KA23433024L";
    system = "x86_64-linux";
    userName = "jackwy";
    gitName = "Jack Wenyoung";
    gitEmail = "dlwxxxdlw@gmail.com";
  in
  {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs userName gitName gitEmail system;};
      modules = [
        inputs.disko.nixosModules.default
        (import ./disko.nix { device = desktop-device; })

        ./configuration.nix
              
        inputs.home-manager.nixosModules.default
        inputs.impermanence.nixosModules.impermanence
      ];
    };
  };
}
