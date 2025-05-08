{moduleNameSpace, ...}: {
  inputs,
  config,
  userName,
  lib,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.nutstore;
  secretsPath = builtins.toString inputs.jackwy-secrets;
in {
  options.${moduleNameSpace}.nutstore = {
    enable = mkEnableOption "System Nutstore";
  };
  config = mkIf cfg.enable {
    sops = {
      age.keyFile = "/persist/home/jackwy/.config/sops/age/keys.txt";
      defaultSopsFile = "${secretsPath}/secrets.yaml";
      secrets = {
        "nutstore_davfs2" = {
          path = "/etc/davfs2/secrets";
        };
      };
    };
    services.davfs2 = {
      enable = true;
      settings = {
        globalSection = {
          ignore_dav_header = true;
          use_locks = false;
        };
      };
    };
    fileSystems."/mnt/nutstore" = {
      device = "https://dav.jianguoyun.com/dav/";
      fsType = "davfs";
      options = [
        "noauto" # 避免系统自动挂载（需结合 systemd 服务）
        "user" # 允许非 root 用户挂载
        "x-systemd.automount" # 启用 systemd 自动挂载
        "_netdev" # 声明依赖网络，确保网络就绪后才挂载:cite[8]
        "rw" # read and write
      ];
    };
    # 挂载点目录权限配置
    system.activationScripts.setupNutstore = ''
      mkdir -p /mnt/nutstore
      chown -R ${userName} /mnt/nutstore
      chmod -R 777 /mnt/nutstore
    '';
  };
}
