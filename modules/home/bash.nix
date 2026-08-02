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
}
