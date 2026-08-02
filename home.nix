{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    inputs.helium-browser.homeModules.default
  ];

  home.username = "doctor";
  home.homeDirectory = "/home/doctor";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    btop
    wl-clipboard
    curl
    fastfetch
    tree
    unzip
    zip
  ];

  home.file = {
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;

    historyControl = [ "ignoredups" "ignorespace" ];
    historySize = 10000;
    historyFileSize = 20000;

    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
    ];

    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      gs = "git status";
      gc = "git commit";
      gp = "git push";
      ".." = "cd ..";
      "..." = "cd ../..";
      grep = "grep --color=auto";
    };

    initExtra = ''
      # Custom prompt
      PS1='\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '

      # fzf keybindings if you have it enabled below
      export EDITOR=nvim
      export VISUAL=nvim

      # Better less
      export LESS='-R --use-color -Dd+r$Du+b$'
    '';

    profileExtra = ''
      export PATH="$HOME/.local/bin:$PATH"
    '';

    bashrcExtra = ''
     # anything you want in every bash invocation
    '';
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.bat.enable = true;
  programs.eza.enable = true; # modern ls replacement

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
      user.name = "kingro27";
      user.email = "kumarvasu2006@gmail.com";
    };
  };

  programs.ripgrep-all.enable = true;

  programs.mcfly = {
    enable = true;
    enableBashIntegration = true;
    fzf.enable = true;
    keyScheme = "vim";
  };

  programs.helium = {
    enable = true;

    flags = [
      "--ozone-platform-hint=auto"
      "--enable-features=TouchpadOverscrollHistoryNavigation"
      "--start-maximized"
    ];
  };

  services.playerctld.enable = true;

  services.flatpak = {
    packages = [
      "com.stremio.Stremio"
    ];
    update.onActivation = true;
  };

  programs.home-manager.enable = true;
}
