{moduleNameSpace, ...}: {
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.ssh;
in {
  options.${moduleNameSpace}.ssh = {
    enable = mkEnableOption "User SSH Enable";
    githubIdentityFile = mkOption {
      type = types.str;
    };
    giteeIdentityFile = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      matchBlocks = {
        "github" = {
          host = "github.com";
          hostname = "ssh.github.com";
          identityFile = cfg.githubIdentityFile;
          proxyCommand = "nc -X connect -x 127.0.0.1:7897 %h %p";
        };
        "gitee" = {
          host = "gitee.com";
          hostname = "ssh.gitee.com";
          identityFile = cfg.giteeIdentityFile;
          # proxyCommand = "nc -X connect -x 127.0.0.1:7897 %h %p";
        };
      };
    };
  };
}
