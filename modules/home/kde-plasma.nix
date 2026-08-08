{ pkgs, inputs, ... }:

{
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  programs.plasma = {
    enable = true;

    shortcuts = {
      # Keyboard Layout Switcher
      "KDE Keyboard Layout Switcher"."Switch to Last-Used Keyboard Layout" = "Meta+Alt+L";
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "Meta+Alt+K";

      # Accessibility
      kaccess."Toggle Screen Reader On and Off" = "Meta+Alt+S";

      # Audio Controls
      kmix = {
        decrease_microphone_volume = "Microphone Volume Down";
        decrease_volume = "Volume Down";
        decrease_volume_small = "Shift+Volume Down";
        increase_microphone_volume = "Microphone Volume Up";
        increase_volume = "Volume Up";
        increase_volume_small = "Shift+Volume Up";
        mic_mute = [ "Microphone Mute" "Meta+Volume Mute" ];
        mute = "Volume Mute";
      };

      mediacontrol = {
        nextmedia = "Media Next";
        pausemedia = "Media Pause";
        playpausemedia = "Media Play";
        previousmedia = "Media Previous";
        seekbackwardmedia = "Media Rewind";
        seekforwardmedia = "Media Fast Forward";
        stopmedia = "Media Stop";
      };

      # Session Management
      ksmserver = {
        "Lock Session" = [ "Screensaver" "Meta+L" ];
        "Log Out" = "Ctrl+Alt+Del";
      };

      # Window Manager (KWin)
      kwin = {
        "Activate Window Demanding Attention" = "Meta+Ctrl+A";
        "Edit Tiles" = "Meta+T";
        Expose = [ "Ctrl+F9" "Meta+F9" ];
        ExposeAll = [ "Launch (C)" "Ctrl+F10" "Meta+F10" ];
        ExposeClass = [ "Ctrl+F7" "Meta+F7" ];
        "Grid View" = "Meta+G";
        "Kill Window" = "Meta+Ctrl+Esc";
        MoveMouseToCenter = "Meta+F6";
        MoveMouseToFocus = "Meta+F5";
        Overview = "Meta+W";
        "Show Desktop" = "Meta+D";
        "Suspend Compositing" = "Alt+Shift+F12";
        "Switch One Desktop Down" = "Meta+Ctrl+Down";
        "Switch One Desktop Up" = "Meta+Ctrl+Up";
        "Switch One Desktop to the Left" = "Meta+Ctrl+Left";
        "Switch One Desktop to the Right" = "Meta+Ctrl+Right";
        "Switch Window Down" = "Meta+Alt+Down";
        "Switch Window Left" = "Meta+Alt+Left";
        "Switch Window Right" = "Meta+Alt+Right";
        "Switch Window Up" = "Meta+Alt+Up";
        "Switch to Desktop 1" = [ "Ctrl+F1" "Meta+F1" ];
        "Switch to Desktop 2" = [ "Ctrl+F2" "Meta+F2" ];
        "Switch to Desktop 3" = [ "Ctrl+F3" "Meta+F3" ];
        "Switch to Desktop 4" = [ "Ctrl+F4" "Meta+F4" ];
        "Walk Through Windows" = [ "Alt+Tab" "Meta+Tab" ];
        "Walk Through Windows (Reverse)" = [ "Alt+Shift+Tab" "Meta+Shift+Tab" ];
        "Walk Through Windows of Current Application" = [ "Alt+`" "Meta+`" ];
        "Walk Through Windows of Current Application (Reverse)" = [ "Alt+~" "Meta+~" ];
        "Window Close" = [ "Alt+F4" "Meta+Q" ];
        "Window Fullscreen" = "Meta+F";
        "Window Maximize" = "Meta+PgUp";
        "Window Minimize" = "Meta+PgDown";
        "Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
        "Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
        "Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
        "Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";
        "Window Operations Menu" = "Alt+F3";
        "Window Quick Tile Bottom" = "Meta+Down";
        "Window Quick Tile Left" = "Meta+Left";
        "Window Quick Tile Right" = "Meta+Right";
        "Window Quick Tile Top" = "Meta+Up";
        "Window Restore" = "Meta+Backspace";
        "Window to Next Screen" = "Meta+Shift+Right";
        "Window to Previous Screen" = "Meta+Shift+Left";
        disableInputCapture = "Meta+Shift+Esc";
        view_actual_size = "Meta+0";
        view_zoom_in = [ "Meta++" "Meta+=" ];
        view_zoom_out = "Meta+-";
      };

      # Power Management
      org_kde_powerdevil = {
        "Decrease Keyboard Brightness" = "Keyboard Brightness Down";
        "Decrease Screen Brightness" = "Monitor Brightness Down";
        "Decrease Screen Brightness Small" = "Shift+Monitor Brightness Down";
        Hibernate = "Hibernate";
        "Increase Keyboard Brightness" = "Keyboard Brightness Up";
        "Increase Screen Brightness" = "Monitor Brightness Up";
        "Increase Screen Brightness Small" = "Shift+Monitor Brightness Up";
        PowerDown = "Power Down";
        PowerOff = "Power Off";
        Sleep = "Sleep";
        "Toggle Keyboard Backlight" = "Keyboard Light On/Off";
        powerProfile = [ "Battery" "Meta+B" ];
      };

      # Plasma Shell
      plasmashell = {
        "activate application launcher" = [ "Meta" "Alt+F1" ];
        "activate task manager entry 1" = "Meta+1";
        "activate task manager entry 2" = "Meta+2";
        "activate task manager entry 3" = "Meta+3";
        "activate task manager entry 4" = "Meta+4";
        "activate task manager entry 5" = "Meta+5";
        "activate task manager entry 6" = "Meta+6";
        "activate task manager entry 7" = "Meta+7";
        "activate task manager entry 8" = "Meta+8";
        "activate task manager entry 9" = "Meta+9";
        clipboard_action = "Meta+Ctrl+X";
        cycle-panels = "Meta+Alt+P";
        "next activity" = "Meta+A";
        "previous activity" = "Meta+Shift+A";
        "show dashboard" = "Ctrl+F12";
        show-on-mouse-pos = "Meta+V";
      };
    };

    configFile = {
      # Input Configuration
      kcminputrc = {
        "Libinput/1739/52967/SYNA32EB:00 06CB:CEE7 Touchpad" = {
          ClickMethod = 2;
          NaturalScroll = true;
        };
        Mouse.X11LibInputXAccelProfileFlat = true;
      };

      # Display & Window Manager
      kwinrc = {
        Desktops = {
          Number = 2;
          Rows = 1;
        };
        NightColor = {
          Active = true;
          Mode = "Constant";
        };
        Xwayland.Scale = 1.3;
      };

      # System Defaults
      kdeglobals.General.BrowserApplication = "helium.desktop";

      # Utilities & Runner
      krunnerrc.General.FreeFloating = true;
      kded5rc.Module-device_automounter.autoload = false;
      kwalletrc.Wallet."First Use" = false;
      plasma-localerc.Formats.LANG = "en_US.UTF-8";

      # Kate Text Editor Behavioral Settings
      katerc = {
        General = {
          "Show Full Path in Title" = false;
          "Show Menu Bar" = true;
          "Show Status Bar" = true;
          "Show Tab Bar" = true;
          "Show Url Nav Bar" = true;
        };
        "KTextEditor Renderer" = {
          "Animate Bracket Matching" = false;
          "Auto Color Theme Selection" = true;
          "Line Height Multiplier" = 1;
          "Show Indentation Lines" = false;
          "Show Whole Bracket Expression" = false;
          "Word Wrap Marker" = false;
        };
      };

      # File Dialogs & Dolphin
      dolphinrc."KFileDialog Settings" = {
        "Places Icons Auto-resize" = false;
        "Places Icons Static Size" = 22;
      };

      spectaclerc = {
        ImageSave.translatedScreenshotsFolder = "Screenshots";
        VideoSave.translatedScreencastsFolder = "Screencasts";
      };
    };
  };
}
