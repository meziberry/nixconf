{ pkgs, lib, ... }:

# Platform-independent terminal setup
{
  home.packages = with pkgs; [
    # Unixy tools
    ripgrep
    fd

    # Useful for Nix development
    nix-output-monitor
    devour-flake
    nil
    nixpkgs-fmt
  ];

  home.shellAliases = {
    l = lib.getExe pkgs.exa;
    g = "git";
    v = "vim";
    vf = "vim $(fzf)";
    e = "emacs -nw";
    ew = "emacs";
    ef = "emacs -nw $(fzf)";
  };

  home.file.".zshrc".text = ''
    #Proxy Swith
    fcuntion xop(){
        export ftp_proxy=socks5://127.0.0.1:4781
        export ALL_PROXY=socks5://127.0.0.1:4781
        export http_proxy=127.0.0.1:4780
        export https_proxy=127.0.0.1:4780
        export no_proxy="*10.*.*.*,192.168.*.*,*.local,localhost,127.0.0.1"
        echo -e "Via proxy."
    }
    fcuntion xfp(){
        unset ftp_proxy
        unset ALL_PROXY
        unset http_proxy
        unset https_proxy
        echo -e "Tun off proxy."
    }
  '';

  programs = {
    bat.enable = true;
    autojump.enable = false;
    zoxide.enable = true;
    fzf.enable = true;
    jq.enable = true;
    nix-index.enable = true;
    htop.enable = true;
  };
}
