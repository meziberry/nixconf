{ config, ... }:
{
  # inherit (config.home) shellAliases;
  programs.zsh.initExtra = ''
    # exec elvish
  '';
}
