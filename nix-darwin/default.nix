{ self, inputs, config, ... }:
{
  # Configuration common to all macOS systems
  flake = {
    darwinModules = {
      myself = {
        home-manager.users.${config.people.myself} = { pkgs, ... }: {
          imports = [
            self.homeModules.common-darwin
            ../home/shellcommon.nix
            ../home/git.nix
          ];
        };
      };
      default.imports = [
        self.darwinModules.home-manager
        self.darwinModules.myself
        ../nixos/caches
      ];
    };
    lib-darwin.mkMacosSystem = mod: inputs.darwin.lib.darwinSystem rec {
      system = "aarch64-darwin";
      specialArgs = {
        inherit inputs system;
        flake = { inherit config; };
        rosettaPkgs = import inputs.nixpkgs { system = "x86_64-darwin"; };
      };
      modules = [ mod ];
    };
  };
}