# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = false;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
    efi.canTouchEfiVariables = true;
  };
  networking.hostName = "nixos"; # Define your hostname.


  services.cron = {
    enable = true;
    systemCronJobs = [
      #"@reboot sleep 10 && exec swaybg -i /home/krut/nixconfig/wall/train.png -m fit -c '#90D5FF' &"
    ];
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.krut = {
    isNormalUser = true;
    description = "krut";
    extraGroups = [ "networkmanager" "wheel" "input" "video" "audio"];
    packages = with pkgs; [];
  };
  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;        # Enable automatic GC
    dates = "weekly";        # Schedule (can be "daily", "weekly", "monthly", or cron syntax)
    options = "--delete-older-than 7d";  # GC options
  };



  environment.systemPackages = with pkgs; [
    vim 
    wget
    git
    kitty
    firefox
    wofi
    rofi
    wl-clipboard
    wl-clipboard-x11
    nwg-look
    neofetch
    
    brave
    pcmanfm
    networkmanagerapplet
    brightnessctl
    pulseaudio
    pavucontrol
    gh
    libnotify
    bluez
    blueman
    util-linux
    libreoffice-qt
    hunspell
    hunspellDicts.uk_UA
    unzip
    vscode
    # clipboard stuff
    wl-clipboard
    cliphist
    wl-clip-persist
    copyq
    # screenshot
    hyprshot
    grim
    slurp
    swappy
    xwayland-satellite
  ];

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;
  services.cloudflare-warp.enable = true;
  system.stateVersion = "25.05"; # Did you read the comment?
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;  
  };
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
    
  services.blueman.enable = true;
  services.dbus.enable = true;
  hardware.bluetooth.enable = true;  
 

  services.xserver.enable = true;
  # services.xserver.displayManager.startx.enable = true; 
  # services.getty.autologinUser = "krut";
  # Seatd (wayland seat management)
  services.displayManager.ly.enable = true;
  services.seatd.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # programs..enable = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji    
    nerd-fonts.jetbrains-mono
 ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];  
  services.hypridle.enable = true;
  programs.niri.enable = true;  
  services.tailscale.enable = true;
  powerManagement.powertop.enable = true;
  # services.xserver.windowManager.i3.enable = true;
}
