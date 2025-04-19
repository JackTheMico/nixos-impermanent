{
  moduleNameSpace,
  # inputs,
  ...
}: {
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.qutebrowser;
in {
  options.${moduleNameSpace}.qutebrowser = {
    enable = mkEnableOption "User qutebrowser";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [qutebrowser];
    programs.qutebrowser = {
      enable = true;
      loadAutoconfig = true;
      # :open google qutebrowser
      searchEngines = {
        mt = "https://metaso.cn/?q={}";
        gg = "https://www.google.com/search?hl=en&q={}";
        nw = "https://wiki.nixos.org/index.php?search={}";
        ddg = "https://duckduckgo.com/?q={}";
        gh = "https://github.com/search?q={}&type=repositories";
        DEFAULT = "https://metaso.cn/?q={}";
      };
      keyBindings = {
        normal = {
          "td" = "config-cycle colors.webpage.darkmode.enable true false";
          "pw" = "spawn --userscript qute-keepassxc --key A30DF874D95E6029";
          "pt" = "spawn --userscript qute-keepassxc --key A30DF874D95E6029 --totp";
        };
        insert = {
          "<Alt-Shift-u>" = "spawn --userscript qute-keepassxc --key A30DF874D95E6029";
        };
      };
      quickmarks = {
        noogle = "https://noogle.dev/";
        noss = "https://search.nixos.org/packages";
        devenv = "https://devenv.sh/";
        gh = "https://github.com";
        hmos = "https://home-manager-options.extranix.com";
        yt = "https://www.youtube.com";
        bili = "https://www.bilibili.com";
        ds = "https://chat.deepseek.com";
        gm = "https://mail.google.com/mail/u/0/#inbox";
        uw = "https://www.upwork.com";
        nut = "https://www.jianguoyun.com/d/home#/";
        fl = "https://www.freelancer.com/";
        ho = "https://www.hackerone.com/";
        h101 = "https://www.hacker101.com/";
        bc = "https://www.bugcrowd.com/";
        inti = "https://www.intigriti.com/";
        ywh = "https://www.yeswehack.com/";
        hts = "https://www.hackthissite.org/";
        htb = "https://www.hackthebox.com/";
        bt = "https://www.butian.net/";
        vb = "https://www.vulbox.com/";
        zh = "https://www.zhihu.com/";
        nvfo = "https://notashelf.github.io/nvf/options.html";
        wqb = "https://platform.worldquantbrain.com/simulate";
        xzm = "https://www.xiezuocat.com/";
        yhdm = "https://www.yinhuadm.vip/";
        mt = "https://metaso.cn";
        imgur = "https://imgur.com/";
        ncloud = "https://n8n.io/";
        nlocal = "http://localhost:5678/home/workflows";
        uxbaike = "https://www.uxbaike.com";
      };
      settings = {
        auto_save.session = true;
        confirm_quit = ["always"];
        content = {
          proxy = "http://localhost:7897";
        };
        colors = {
          webpage = {
            darkmode = {
              enabled = true;
              algorithm = "lightness-cielab";
              contrast = 0.6;
            };
          };
        };
        fonts = {
          default_size = "16pt";
          default_family = "Maple Mono NF";
        };
        tabs = {
          position = "bottom";
          show = "multiple";
        };
        scrolling.smooth = true;
        statusbar.show = "in-mode";
        url = {
          start_pages = "https://www.limestart.cn/";
          default_page = "https://www.limestart.cn/";
        };
        zoom = {
          default = "135%";
        };
      };
      greasemonkey = [
        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/afreakk/greasemonkeyscripts/refs/heads/master/youtube_sponsorblock.js";
          sha256 = "9f035a75ed681cffb0e4b1943c94a0017d7e9d06658b84617bc14552817998b1";
        })
        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/afreakk/greasemonkeyscripts/refs/heads/master/youtube_adblock.js";
          sha256 = "0320fd5682c96ca3dfaa60c4c0520404c97ffc4215fc5627675fa89daf9553d7";
        })
        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/afreakk/greasemonkeyscripts/refs/heads/master/reddit_adblock.js";
          sha256 = "2a60972f81ab66dc0f2d1c80bc0c400e9ca36dd6395059d2fd729914ab60eed9";
        })
        # https://github.com/afreakk/greasemonkeyscripts
      ];
    };
  };
}
