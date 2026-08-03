{ ... }:

{
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

  programs.eza = {
    enable = true;
    enableBashIntegration = false;
    git = true;
    icons = "auto";
  };

  programs.ripgrep-all.enable = true;

  programs.mcfly = {
    enable = true;
    enableBashIntegration = true;
    fzf.enable = true;
    keyScheme = "vim";
  };
}
