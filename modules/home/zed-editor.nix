{ pkgs, lib, ... }:

{
  programs.zed-editor = {
    enable = true;

    # Lets Home Manager symlink Zed's config/keymap/settings into the right
    # XDG paths instead of you hand-editing ~/.config/zed.
    extensions = [
      "nix"
      "toml"
      "docker"
      "make"
      "html"
      "css"
      "sql"
      "git-firefly" # git blame/lens style extension; drop if you don't want it
      "catppuccin"
    ];

    # Extra CLI tools Zed shells out to (formatters, linters, LSPs not
    # already bundled). Anything referenced by userSettings' language
    # servers/formatters below should live here so it's on PATH for Zed.
    extraPackages = with pkgs; [
      nixd # Nix LSP
      nixpkgs-fmt
      nodePackages.prettier
      nodePackages.typescript-language-server
      rust-analyzer
      gopls
      ripgrep
      fd
    ];

    userSettings = {
      # --- Appearance ---
      theme = {
        mode = "system";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };
      buffer_font_family = "JetBrains Mono";
      buffer_font_size = 14;
      ui_font_size = 15;
      cursor_blink = false;

      # --- Editing behavior ---
      vim_mode = true; # flip to true if you're a vim refugee
      relative_line_numbers = true;
      soft_wrap = "editor_width";
      tab_size = 2;
      format_on_save = "on";
      remove_trailing_whitespace_on_save = true;
      ensure_final_newline_on_save = true;
      autosave = "on_focus_change";

      # --- UI panels ---
      show_whitespaces = "selection";
      scrollbar.show = "auto";
      project_panel = {
        dock = "left";
        default_width = 240;
      };
      terminal = {
        dock = "bottom";
        default_height = 320;
        shell = "system";
      };

      # --- Git ---
      git = {
        inline_blame.enabled = true;
        git_gutter = "tracked_files";
      };

      # --- Language-specific overrides ---
      languages = {
        Nix = {
          formatter = {
            external = {
              command = "nixpkgs-fmt";
              arguments = [ "-" ];
            };
          };
          language_servers = [ "nixd" ];
        };
        JavaScript = {
          formatter = "prettier";
        };
        TypeScript = {
          formatter = "prettier";
        };
        Rust = {
          format_on_save = "on";
        };
      };

      lsp = {
        nixd = {
          settings = {
            formatting.command = [ "nixpkgs-fmt" ];
          };
        };
      };

      # --- Misc quality of life ---
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      auto_update = false; # let Nix manage the version instead of Zed self-updating
    };

    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
          "cmd-shift-e" = "project_panel::ToggleFocus";
          "cmd-j" = "terminal_panel::ToggleFocus";
          "cmd-shift-f" = "workspace::NewSearch";
        };
      }
      {
        context = "Editor";
        bindings = {
          "cmd-d" = "editor::SelectNext";
          "cmd-shift-d" = "editor::DuplicateLine";
        };
      }
    ];
  };
}
