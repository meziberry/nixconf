{ self, ... }:
{
  flake = {
    homeModules = {
      common = {
        home.stateVersion = "23.11";
        imports = [
          ./terminal.nix
          ./starship.nix
          ./git.nix
          ./direnv.nix
          ./zellij.nix
          ./just.nix
          ./elvish.nix
          ./emacs.nix
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
