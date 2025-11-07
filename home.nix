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
  
  home.file.".config/i3".source = ./config/i3config/i3;
  home.file.".config/picom".source = ./config/i3config/picom;
  home.file.".config/wlogout".source = ./config/i3config/wlogout;
  home.file.".config/rofi".source = ./config/i3config/rofi;
  home.file.".config/polybar".source = ./config/i3config/polybar;
  #home.file.".vimrc".source = ./config/vim/vimrc;
  services.dunst.enable = true;
}
