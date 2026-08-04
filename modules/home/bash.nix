{ ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    historyControl = [
      "ignoredups"
      "ignorespace"
    ];
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
      # --- eza as a drop-in ls replacement ---
      ls = "eza --group-directories-first";
      ll = "eza -l --all --header --git --group-directories-first --time-style=long-iso"; # was: ls -alF
      la = "eza --all --group-directories-first"; # eza -a already behaves like `ls -A` (no . / ..)
      l = "eza --classify --group-directories-first"; # was: ls -CF

      # extras that come for free once you have eza around
      lt = "eza --tree --level=2 --group-directories-first";
      tree = "eza --tree";
      "l." = "eza -d .* --group-directories-first"; # list only dotfiles in cwd

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
    '';

    profileExtra = ''
      export PATH="$HOME/.local/bin:$PATH"
    '';

    bashrcExtra = ''
      # anything you want in every bash invocation
    '';
  };
}
