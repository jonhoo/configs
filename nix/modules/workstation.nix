# Personal interactive development environment
{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
    ./home/workstation.nix
  ];

  # Auto-login is fine with FDE
  services.getty = {
    autologinUser = "jon";
    autologinOnce = true;
  };

  # NAS
  fileSystems."/mnt/nas/jon" = {
    device = "//192.168.50.50/jon";
    fsType = "cifs";
    options =
      let
        mount_opts = "_netdev,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in
      [ "${mount_opts},credentials=/etc/nixos/smb-secrets,uid=jon,gid=users" ];
  };

  # Keybase
  services.keybase.enable = true;
  services.kbfs.enable = true;

  # Additional dev packages
  environment.systemPackages = with pkgs; [
    cifs-utils
    cpuset
    ffmpeg-full
    links2
    pv
  ];

  # Home-manager setup
  home-manager.useGlobalPkgs = true;
}
