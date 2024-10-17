{ config, lib, pkgs, ... }:

{
    programs.kitty = {
	enabled = true;
    }
    home.file."./.config/kitty/" = { 
	  source = ./kitty;
	  recursive = true;
	};
}
