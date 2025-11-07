# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  # security 
  security.sudo.wheelNeedsPassword = false;
  # Bootloader.
  boot.loader = {
    systemd-boot.enable = false;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
    
  };
  boot.initrd.compressor = "zstd";
  boot.initrd.compressorArgs = ["-19" "-T0"];
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
    rofi
    wl-clipboard
    wl-clipboard-x11
    neofetch
    # browser  
    brave
    firefox
    # filemanager
    nautilus
    pcmanfm
    # polybar 
    polybar
    pavucontrol
    networkmanagerapplet
    brightnessctl
    pulseaudio
    # applet
    cbatticon
    fcitx5
    pasystray
    pavucontrol
    pamixer
    gh
    libnotify
    bluez
    blueman
    util-linux
    # personal software
    tmux
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
    flameshot
    hyprshot
    grim
    slurp
    swappy
    wmctrl
    font-awesome
  ];

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;
  system.stateVersion = "25.05"; # Did you read the comment?
  # programs.hyprland = {
  #   enable = true;
  #   xwayland.enable = true;  
  # };
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
    
  services.blueman.enable = true;
  services.dbus.enable = true;
  hardware.bluetooth.enable = true;  
  # services.blueman.enable = true;
  services.cloudflare-warp.enable = true;
  services.displayManager.ly.enable = true;
  services.tailscale.enable = true;
  # programs..enable = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji    
    nerd-fonts.jetbrains-mono
  ];
  fonts.fontconfig.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];  
  # programs.niri.enable = true;  
  powerManagement.powertop.enable = true;
  ####  gnome  ####
  # services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.core-apps.enable = true;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;
  environment.gnome.excludePackages = with pkgs; [ gnome-tour gnome-user-docs ];

  services.xserver = {
    videoDrivers = [ "intel" ];
    deviceSection = ''
      Option "TearFree" "true"
    '';
  };

  ####  i3  ####
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };
   
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };
  };  
  services.displayManager.defaultSession = "none+i3";

  programs.i3lock.enable = true; #default i3 screen locker
  services.picom.enable = true;
  
}
