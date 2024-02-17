{ self, inputs, ... }:
{
  flake = {
    homeModules = {
      common = {
        home.stateVersion = "24.05";
        imports = [
          inputs.nix-index-database.hmModules.nix-index
          ./terminal.nix
          ./starship.nix
          ./git.nix
          ./direnv.nix
          ./zellij.nix
          ./just.nix
          ./elvish.nix
          ./emacs.nix
          ./nix.nix
          # ./ssh.nix
          # ./helix.nix
          # ./tmux.nix
          # ./neovim.nix
          # ./nushell.nix
          # ./powershell.nix
        ];
      };
      common-linux = {
        imports = [
          self.homeModules.common
          ./bash.nix
          # ./vscode-server.nix
        ];
      };
      common-darwin = {
        imports = [
          self.homeModules.common
          ./zsh.nix
          ./bash.nix
          # ./kitty.nix
        ];
      };
    };
  };
}
