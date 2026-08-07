{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;

    # Auto-inject shell integration
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      # --- Window & Layout ---
      window-decoration = false;
      window-padding-x = 12;
      window-padding-y = 12;
      window-padding-balance = true;
      confirm-close-surface = false;

      # --- Cursor & Interaction ---
      cursor-style = "block";
      cursor-style-blink = false;
      mouse-hide-while-typing = true;

      # --- Clipboard & System ---
      copy-on-select = "clipboard";
      clipboard-read = "ask";
      clipboard-write = "allow";
      gtk-single-instance = true;
      quit-after-last-window-closed = true;

      # --- Keybindings ---
      keybind = [
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"
        "ctrl+plus=increase_font_size:1"
        "ctrl+minus=decrease_font_size:1"
        "ctrl+zero=reset_font_size"
      ];
    };
  };
}