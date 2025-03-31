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
    githubIdentityFiles = mkOption {
      type = types.listOf (types.str);
    };
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      matchBlocks = {
        "github" = {
          host = "github.com";
          hostname = "ssh.github.com";
          identityFile = cfg.githubIdentityFiles;
          proxyCommand = "nc -X connect -x 127.0.0.1:7897 %h %p";
        };
      };
    };
  };
}
