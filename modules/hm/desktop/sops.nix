{moduleNameSpace, ...}: {
  inputs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.sopsnix;
  secretsPath = builtins.toString inputs.jackwy-secrets;
in {
  options.${moduleNameSpace}.sopsnix = {
    enable = mkEnableOption "User Sops.nix Enable";
  };

  config = mkIf cfg.enable {
    sops = {
      age.keyFile = "/persist${config.home.homeDirectory}/.config/sops/age/keys.txt";
      defaultSopsFile = "${secretsPath}/secrets.yaml";
      secrets = {
        # "ssh_host_ed25519_key/private/nixos_jackwy_laptop" = {
        #   path = "/home/jackwenyoung/.ssh/id_nixos_jackwy_laptop";
        # };
        "gh_token" = {};
        "wakatime" = {};
      };
      templates = {
        "hosts.yml" = {
          content =
            /*
            yaml
            */
            ''
              github.com:
                users:
                  JackTheMico:
                    oauth_token: "${config.sops.placeholder.gh_token}"
                git_protocol: ssh
                oauth_token: "${config.sops.placeholder.gh_token}"
                user: JackTheMico
            '';
          mode = "0777";
        };
        "nix.conf".content = ''
          access-tokens = github.com=${config.sops.placeholder.gh_token}
        '';
        "wakatime.cfg".content = ''
          [settings]
          debug = false
          hidefilenames = false
          ignore =
              COMMIT_EDITMSG$
              PULLREQ_EDITMSG$
              MERGE_MSG$
              TAG_EDITMSG$
          api_key=${config.sops.placeholder.wakatime};
        '';
        # "netrc".content = ''
        #   machine youtube login ${config.sops.placeholder.yt_username} password ${config.sops.placeholder.yt_password}
        # '';
      };
    };
    xdg.configFile."gh/hosts.yml".source = config.lib.file.mkOutOfStoreSymlink "${config.sops.templates."hosts.yml".path}";
    xdg.configFile."nix/nix.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.sops.templates."nix.conf".path}";
    # home.file.".netrc".source = config.lib.file.mkOutOfStoreSymlink "${config.sops.templates."netrc".path}";
    home.file.".wakatime.cfg".source = config.lib.file.mkOutOfStoreSymlink "${config.sops.templates."wakatime.cfg".path}";
  };
}
