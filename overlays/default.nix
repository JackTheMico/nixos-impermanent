{inputs, ...}: {
  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
      overlays = [
        # An example to apply an overlay
        # inputs.nix-yazi-plugins.overlays.default
      ];
    };
  };
}
