{ config, pkgs, ... }:

let
  nur = config.nur;
  clash-premium = nur.repos.linyinfeng.clash-premium;
in
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
          "networkmanager"
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

    inputMethod = {
      enabled = "ibus";
      ibus.engines = [ pkgs.ibus-engines.rime ];
    };
  };

  time = {
    timeZone = "Asia/Shanghai";
  };

  hardware = {
    pulseaudio.enable = false;
  };

  security.rtkit.enable = true;

  sound = {
    enable = true;
  };

  virtualisation = {
    docker.enable = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };

  nix = {
    settings.auto-optimise-store = true;
  };

  networking = {
    hostName = "be";
    firewall.allowedTCPPorts = [ 3000 1234 ];
    networkmanager = {
      enable = true;
      insertNameservers = [ "8.8.8.8" ];
      dns = "none";
    };
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

      desktopManager = {
        gnome = {
          enable = true;
        };
      };
    };
    openssh = {
      enable = true;
    };
    gnome = {
      gnome-keyring = {
        enable = true;
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    printing.enable = true;
  };

  systemd.services.clashd = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "Clash daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${clash-premium}/bin/clash-premium -d /etc/clash'';
    };
  };

  environment = {
    systemPackages = with pkgs; [
      google-chrome
      clash-premium
      libcamera
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

  system = { stateVersion = "22.11"; };
}
