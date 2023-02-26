{ config, pkgs, nixvim, enablePkgs, ... }:
{
  imports =
    [
      ../common/system.nix
      #nixvim.nixDarwinModules.nixvim
    ];


  users.users = {
    beet = {
      home = "/Users/beet";
      shell = pkgs.fish;
    };
  };

  programs = enablePkgs {
    fish = { };
  };

  services = {
    nix-daemon.enable = true;
    /*
      # To Avoid the buggy permission issue on yabai rev0.3.5,
      # currently using brew to manage yabai. 
      yabai = {
      enable = true;
      enableScriptingAddition = true;
      package = pkgs.yabai;
      };
    */
    /*
      skhd = {
      enable = true;
      package = pkgs.skhd;
      };
    */
  };

  system = {
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        InitialKeyRepeat = 10;
        KeyRepeat = 2;
        _HIHideMenuBar = true;
        "com.apple.trackpad.scaling" = 2.5;
      };
      dock = {
        wvous-bl-corner = 4;
        wvous-br-corner = 1;
        wvous-tl-corner = 3;
        wvous-tr-corner = 1;
      };
      finder = {
        ShowPathbar = true;
      };
      spaces = {
        spans-displays = false;
      };
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };

    };
    keyboard = {
      enableKeyMapping = true;
      userKeyMapping = [
        # Swap CapsLock with Ctrl
        # { HIDKeyboardModifierMappingSrc = 30064771296; HIDKeyboardModifierMappingDst = 30064771129; }
        # { HIDKeyboardModifierMappingSrc = 30064771129; HIDKeyboardModifierMappingDst = 30064771296; }
      ];
    };
    # We need to manually `chsh` to the nix-version shell
    activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.fish}/bin/fish beet'';
  };
}
