{ config, pkgs, ... }:

{
  home.username = "krut";
  home.homeDirectory = "/home/krut";
  home.stateVersion = "25.05"; # match your NixOS or Home Manager version

  programs.git = {
    enable = true;
    userName = "noobs1100";
    userEmail = "noobg43213@gmail.com";
  };
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use hyprland btw";
      nrs = "sudo nixos-rebuild switch --flake ~/nixconfig#nixos";
    };
 }; 

  # services.polkit-gnome.enable = true; # polkit
  home.packages = with pkgs; [
    neovim
    mpv
    vlc
    htop
    nnn   
    wget
    git
    grim
    slurp
    gh
    foot
    wlogout
    waybar
    hyprpicker
    pywal
    blueman
    bluez
    pywal
    gvfs
    libnotify
    wlogout
  ];
  
  #home.file.".config/hypr".source = ./config/hypr;
  # home.file.".config/waybar".source = ./config/waybar;
  #home.file.".config/wlogout".source = ./config/wlogout;
  #home.file.".vimrc".source = ./config/vim/vimrc;
  services.dunst.enable = true;
}
