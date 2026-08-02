{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
      user.name = "kingro27";
      user.email = "kumarvasu2006@gmail.com";
    };
  };
}
