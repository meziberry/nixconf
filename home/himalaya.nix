let
  # https://pimalaya.org/himalaya/cli/latest/configuration/icloud-mail.html
  iCloudMailSettings = {
    imap = {
      host = "imap.mail.me.com";
      port = 993;
    };
    smtp = {
      host = "smtp.mail.me.com";
      port = 587;
      tls.useStartTls = true;
    };
  };
in
{
  home.shellAliases = {
    H = "himalaya";
    Hd = "himalaya message delete";
  };

  programs.himalaya = {
    enable = true;
  };

  accounts.email.accounts = {
    "srid@srid.ca" = iCloudMailSettings // {
      primary = true;
      realName = "Sridhar Ratnakumar";
      address = "happyandharmless@icloud.com";
      aliases = [ "srid@srid.ca" ];
      userName = "happyandharmless";
      passwordCommand = "op read op://Personal/iCloud-Apple/himalaya";
      himalaya = {
        enable = true;
        # Disabled because of https://todo.sr.ht/~soywod/pimalaya/213
        settings.sync = {
          enable = true;
        };
      };
    };
  };
}
