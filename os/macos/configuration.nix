{ config, pkgs, ... }:

{
  imports =
    [
      ../common/system.nix
    ];


  users.users = {
    beet = {
      home = "/Users/beet";
      # We need to manually `chsh` to the nix-version
      # bash because this option will point our
      # default shell to the macos-version bash
      # shell = pkgs.bashInteractive;
    };
  };

  services = {
    nix-daemon.enable = true;
    /*
      yabai = {
      enable = true;
      enableScriptingAddition = true;
      package = pkgs.yabai;
      };
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
        "com.apple.trackpad.scaling" = "2.50";
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
        { HIDKeyboardModifierMappingSrc = 30064771296; HIDKeyboardModifierMappingDst = 30064771129; }
        { HIDKeyboardModifierMappingSrc = 30064771129; HIDKeyboardModifierMappingDst = 30064771296; }
      ];
    };

    stateVersion = 4;
  };
}
