{ config, pkgs, ... }:

{
  home.username = "krut";
  home.homeDirectory = "/home/krut";
  home.stateVersion = "25.05"; # match your NixOS or Home Manager version

  programs.zsh.enable = true;
  programs.git = {
    enable = true;
    # userName = "noobs1100";
    # userEmail = "noobg43213@gmail.com";
  };

  # home.file.".config/git/config".source = null;

  home.packages = with pkgs; [
    neovim
    htop
    wget
    git
    gh
  ];

  # Example environment variable
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
