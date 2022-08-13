{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware.nix
      ../common/system.nix
    ];

  users = {
    users = {
      beet = {
        initialPassword = "1111";
        isNormalUser = true;
        group = "docker";
        extraGroups = [
          "wheel"
        ];
      };
    };
  };

  fonts = {
    fonts = with pkgs; [
      noto-fonts-emoji
      source-han-mono
      source-han-sans
      source-han-serif
    ];
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  };

  time = {
    timeZone = "Asia/Shanghai";
  };

  hardware = {
    video.hidpi.enable = true;
    pulseaudio.enable = true;
  };

  sound = {
    enable = true;
  };

  virtualisation = {
    vmware.guest.enable = true;
    docker.enable = true;
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  nix = {
    autoOptimiseStore = true;
  };

  networking = {
    hostName = "be";
    useDHCP = false;
    interfaces.ens33.useDHCP = true;
    firewall.allowedTCPPorts = [ 3000 1234 ];
  };

  # service
  services = {
    xserver = {
      enable = true;

      # key repeat
      autoRepeatDelay = 200;
      autoRepeatInterval = 25;

      # libinput
      libinput = {
        enable = true;
        mouse = {
          accelSpeed = "0.5";
        };
      };

      displayManager = {
        gdm = {
          enable = true;
        };
      };
      windowManager = {
        leftwm = {
          enable = true;
        };
      };
      dpi = 192;
    };
    openssh = {
      enable = true;
    };
    gnome = {
      gnome-keyring = {
        enable = true;
      };
    };
  };

  environment = {
    variables = {
      GDK_SCALE = "2";
      GDK_DPI_SCALE = "0.5";
    };
    systemPackages = with pkgs; [
      xfce.thunar
      polybar
      feh
      rofi
      leftwm
      picom
      polkit
      chromium
      xclip
      wget
      xorg.xdpyinfo
      nixpkgs-fmt
    ];
  };

  # programs config
  programs = {
    gnupg.agent = {
      enable = true;
    };
    ssh = {
      startAgent = true;
    };
  };

  system = { stateVersion = "22.05"; };
}
