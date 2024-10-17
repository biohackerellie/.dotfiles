{config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    tig
  ];
  programs.git = {
    enable = true;
    userName = "biohackerellie";
    userEmail = "epkerns@gmail.com";
    extraConfig = {
	init = { defaultBranch = "main"; };
	pull = { rebase = true; };
	push = { autoSetupRemote = true;};
    };
  };
}
