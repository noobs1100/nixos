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
          exec hyprland & waybar
      fi
    '';
    
  };
  
  
  services.swaync = {
    enable = true;
  };

  # home.file.".config/git/config".source = null;

  home.packages = with pkgs; [
    neovim
    htop
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
  ];

  # Example environment variable
  home.file.".config/hypr".source = /home/krut/nixconfig/config/hypr;
  home.file.".config/waybar".source = /home/krut/nixconfig/config/waybar;
  home.file.".config/wlogout".source = /home/krut/nixconfig/config/wlogout;

}
