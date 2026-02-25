{ config, pkgs, ... }: {
  system.stateVersion = "25.11";
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  environment.systemPackages = [ pkgs.wl-clipboard ];
}
