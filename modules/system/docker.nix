{moduleNameSpace, ...}: {
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.docker;
in {
  options.${moduleNameSpace}.docker = {
    enable = mkEnableOption "System Docker Enable";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [arion compose2nix lazydocker docker-compose];
    # environment.etc."containers/registries.conf".text = lib.mkForce ''
    #   unqualified-search-registries = ["docker.io"]
    #
    #   # Docker Hub 镜像加速
    #   [[registry]]
    #   prefix = "docker.io"
    #   location = "docker.io"
    #   [[registry.mirror]]
    #   location = "xxxx.mirror.aliyuncs.com"  # 阿里云
    #   [[registry.mirror]]
    #   location = "docker.mirrors.ustc.edu.cn"  # 中科大
    #
    #   # Red Hat 镜像配置
    #   [[registry]]
    #   prefix = "registry.redhat.io"
    #   location = "mirror.registry.redhat.example.com"  # 企业内网镜像
    #   insecure = true  # 若使用自签名证书需启用
    # '';
    virtualisation.docker = {
      enable = false;
      daemon.settings = {
        "registry-mirrors" = [
          "https://registry.docker-cn.com" # Docker 中国官方镜像（可能已失效，需替换）
          "https://mirror.baidubce.com" # 百度云镜像
        ];
      };
    };
    # https://github.com/nix-community/nix-ld
    programs.nix-ld = {
      enable = true;
      # libraries = with pkgs; [];
    };
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    xdg.configFile = {
      "containers/containers.conf".text = ''
        [containers]
        http_proxy = true
        env = ["http_proxy=http://127.0.0.1:7897", "https_proxy=http://127.0.0.1:7897"]
      '';
    };
  };
}
