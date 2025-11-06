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
  profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
          exec hyprland 
      fi
    '';
    
  };
  
  
  services.swaync = {
    enable = true;
  };

  programs.alacritty.enable = true; # Super+T in the default setting (terminal)
  programs.fuzzel.enable = true; # Super+D in the default setting (app launcher)
  programs.swaylock.enable = true; # Super+Alt+L in the default setting (screen locker)
  # programs.waybar.enable = true; # launch on startup in the default setting (bar)
  services.swayidle.enable = true; # idle management daemon
  services.polkit-gnome.enable = true; # polkit

  

  
  home.packages = with pkgs; [
    neovim
    htop
    nnn   
    wget
    git
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
    swaynotificationcenter
    wlogout
    hyprlock
    swaybg
  ];

  # Example environment variable
  home.file.".config/hypr".source = ./config/hypr;
  home.file.".config/waybar".source = ./config/waybar;
  home.file.".config/wlogout".source = ./config/wlogout;
  home.file.".vimrc".source = ./config/vim/vimrc;

}
