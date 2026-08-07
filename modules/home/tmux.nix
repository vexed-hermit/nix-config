{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shortcut = "a";             # Replaces default C-b with C-a
    baseIndex = 1;              # Start window numbers at 1 instead of 0
    escapeTime = 0;             # Eliminates ESC delay (crucial for Vim/Neovim)
    historyLimit = 50000;       # Boost scrollback buffer
    keyMode = "vi";             # Vi keys in copy mode
    mouse = true;               # Mouse support for resizing/selecting
    terminal = "tmux-256color"; # Correct terminal type

    plugins = with pkgs.tmuxPlugins; [
      # Seamless navigation between Vim splits and Tmux panes (<C-h/j/k/l>)
      vim-tmux-navigator

      # Theme (Catppuccin)
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'mocha'
          set -g @catppuccin_window_status_style 'rounded'
          set -g @catppuccin_status_background 'default'
        '';
      }

      # Session state preservation across system reboots
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'off'
          set -g @continuum-save-interval '15'
        '';
      }
    ];

    extraConfig = ''
      # Direct true-color (24-bit) support overrides
      set -as terminal-features ",xterm-256color:RGB"
      set -as terminal-overrides ",xterm-256color:Tc"

      # Retain current working directory when splitting or creating windows
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # Visual splits using | and -
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Easy config reload
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Tmux configuration reloaded!"

      # Vim-style pane resizing (-r allows repetition without pressing prefix again)
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Enable system clipboard integration in vi-copy mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    '';
  };
}
