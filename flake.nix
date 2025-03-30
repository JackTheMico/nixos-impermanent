{
  description = "Nixos config flake";
     
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs:
  let
    desktop-device = "/dev/disk/by-id/nvme-ZHITAI_TiPro7000_1TB_ZTA21T0KA23433024L";
    userName = "jackwy";
    gitName = "Jack Wenyoung";
    gitEmail = "dlwxxxdlw@gmail.com";
  in
  {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs userName gitName gitEmail;};
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
