{ inputs, ... }:
{
  flake-file.inputs = {
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.zen-browser = {
    homeManager =
      { pkgs, ... }:
      {
        imports = [ inputs.zen-browser.homeModules.beta ];

        programs.zen-browser = {
          enable = true;
          setAsDefaultBrowser = true;
        };

        xdg = {
          enable = true;
          mimeApps =
            let
              value =
                let
                  zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta;
                in
                zen-browser.meta.desktopFileName;

              associations = builtins.listToAttrs (
                map
                  (name: {
                    inherit name value;
                  })
                  [
                    "application/x-extension-shtml"
                    "application/x-extension-xhtml"
                    "application/x-extension-html"
                    "application/x-extension-xht"
                    "application/x-extension-htm"
                    "x-scheme-handler/chrome"
                    "x-scheme-handler/about"
                    "x-scheme-handler/https"
                    "x-scheme-handler/http"
                    "application/xhtml+xml"
                    "text/html"
                  ]
              );
            in
            {
              associations.added = associations;
              defaultApplications = associations;
            };
        };
      };

    provides.valou.homeManager =
      { config, lib, ... }:
      {
        programs.zen-browser = {
          policies =
            let
              mkPluginUrl =
                id:
                if !lib.strings.hasPrefix "https://" id then
                  "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi"
                else
                  id;

              mkExtensionEntry =
                {
                  id,
                  pinned ? false,
                }:
                let
                  base = {
                    install_url = mkPluginUrl id;
                    installation_mode = "force_installed";
                  };
                in
                if pinned then base // { default_area = "navbar"; } else base;

              mkExtensionSettings = builtins.mapAttrs (
                _: entry: if builtins.isAttrs entry then entry else mkExtensionEntry { id = entry; }
              );
            in
            {
              # Options available at about:policies#documentation
              AutofillAddressEnabled = false;
              AutofillCreditCardEnabled = false;
              DisableAppUpdate = true;
              DisableFeedbackCommands = true;
              DisableFirefoxStudies = true;
              DisablePocket = true;
              DisableTelemetry = true;
              DontCheckDefaultBrowser = true;
              NoDefaultBookmarks = true;
              OfferToSaveLogins = false;
              EnableTrackingProtection = {
                Value = true;
                Locked = true;
                Cryptomining = true;
                Fingerprinting = true;
              };
              SearchSuggestEnabled = true;
              ExtensionSettings = mkExtensionSettings {
                "jetpack-extension@dashlane.com" = mkExtensionEntry {
                  id = "dashlane";
                  pinned = true;
                };
                "firefox@betterttv.net" = "betterttv";
                "reddit-url-redirector@kichkoupi.com" = "reddituntranslate";
                "sponsorBlocker@ajay.app" = "sponsorblock";
                "uBlock0@raymondhill.net" = "ublock-origin";
                "{458160b9-32eb-4f4c-87d1-89ad3bdeb9dc}" = "youtube-anti-translate";
                "firefox-extension@steamdb.info" = "steam-database";
                "{1be309c5-3e4f-4b99-927d-bb500eb4fa88}" = "augmented-steam";
                "{dbac9680-d559-4cd4-9765-059879e8c467}" = "igraal";
                "{188e9a6d-0e71-49ad-b1f2-0b78519512e0}" = "dealabs";
                "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" = "violentmonkey";
                "{EDB6A15C-5F8C-4531-92FA-98E988CF233C}" = "wanteeed";
                "{6a65273e-2b26-40f5-b66e-8eed317307da}" = "new-tab-suspender";
                "amptra@keepa.com" = "keepa";
                "addon@protondb-community-extension.com" = "protondb-community-extension";
                "nowstreaming@joao.sh" = "nowstreaming-twitch";
                "addon@karakeep.app" = "karakeep";
                "extension@gamesgraph.com" = "gamesgraph";
                "twitchnosub@besuper.com" =
                  "https://github.com/besuper/TwitchNoSub/releases/download/0.9.3/TwitchNoSub-firefox-0.9.3.xpi";
              };
              SearchEngines = {
                Add = [
                  {
                    Alias = "@ac";
                    Description = "Search in Are We Anti-Cheat Yet?";
                    IconURL = "https://areweanticheatyet.com/icon.webp";
                    Method = "GET";
                    Name = "Are We Anti-Cheat Yet?";
                    URLTemplate = "https://areweanticheatyet.com/?search={searchTerms}";
                  }
                  {
                    Alias = "@enfr";
                    Description = "Search in WordReference (EN to FR)";
                    IconURL = "https://www.wordreference.com/favicon.ico";
                    Method = "GET";
                    Name = "WordReference (EN to FR)";
                    URLTemplate = "https://www.wordreference.com/redirect/translation.aspx?w={searchTerms}&dict=enfr";
                  }
                  {
                    Alias = "@fren";
                    Description = "Search in WordReference (FR to EN)";
                    IconURL = "https://www.wordreference.com/favicon.ico";
                    Method = "GET";
                    Name = "WordReference (FR to EN)";
                    URLTemplate = "https://www.wordreference.com/redirect/translation.aspx?w={searchTerms}&dict=fren";
                  }
                  {
                    Alias = "@hltb";
                    Description = "Search in How Long To Beat";
                    IconURL = "https://howlongtobeat.com/img/icons/favicon-96x96.png";
                    Method = "GET";
                    Name = "How Long To Beat";
                    URLTemplate = "https://howlongtobeat.com/?q={searchTerms}";
                  }
                  {
                    Alias = "@hm";
                    Description = "Search in Home Manager options";
                    IconURL = "https://mynixos.com/favicon-32x32.png";
                    Method = "GET";
                    Name = "Home Manager";
                    URLTemplate = "https://mynixos.com/search?q=home-manager+{searchTerms}";
                  }
                  {
                    Alias = "@np";
                    Description = "Search in NixOS packages";
                    IconURL = "https://nixos.org/favicon.ico";
                    Method = "GET";
                    Name = "NixOS packages";
                    URLTemplate = "https://search.nixos.org/packages?channel=unstable&from=0&size=200&sort=relevance&type=packages&query={searchTerms}";
                  }
                  {
                    Alias = "@no";
                    Description = "Search in NixOS options";
                    IconURL = "https://nixos.org/favicon.ico";
                    Method = "GET";
                    Name = "NixOS options";
                    URLTemplate = "https://search.nixos.org/options?channel=unstable&from=0&size=200&sort=relevance&type=packages&query={searchTerms}";
                  }
                  {
                    Alias = "@nw";
                    Description = "Search in NixOS wiki";
                    IconURL = "https://nixos.org/favicon.ico";
                    Method = "GET";
                    Name = "NixOS wiki";
                    URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}&title=Special%3ASearch&wprov=acrw1_-1";
                  }
                  {
                    Alias = "@pc";
                    Description = "Search in PCGamingWiki";
                    IconURL = "https://static.pcgamingwiki.com/favicons/pcgamingwiki.png";
                    Method = "GET";
                    Name = "PCGamingWiki";
                    URLTemplate = "https://www.pcgamingwiki.com/w/index.php?search={searchTerms}&title=Special%3ASearch";
                  }
                  {
                    Alias = "@pdb";
                    Description = "Search in ProtonDB";
                    IconURL = "https://www.protondb.com/sites/protondb/images/site-logo.svg";
                    Method = "GET";
                    Name = "ProtonDB";
                    URLTemplate = "https://www.protondb.com/search?q={searchTerms}";
                  }
                  {
                    Alias = "@uhs";
                    Description = "Search in Universal Hint System";
                    IconURL = "https://static.uhs-hints.com/images/crystal-ball-transparent-16.png";
                    Method = "GET";
                    Name = "Universal Hint System";
                    URLTemplate = "https://www.uhs-hints.com/hints/search.php?search={searchTerms}";
                  }
                  {
                    Alias = "@w";
                    Description = "Search in Wikipedia (EN)";
                    IconURL = "https://wikipedia.org/static/favicon/wikipedia.ico";
                    Method = "GET";
                    Name = "Wikipedia EN";
                    URLTemplate = "https://www.wikipedia.org/search-redirect.php?family=wikipedia&search={searchTerms}&language=en&go=Go";
                  }
                  {
                    Alias = "@wfr";
                    Description = "Search in Wikipedia (FR)";
                    IconURL = "https://wikipedia.org/static/favicon/wikipedia.ico";
                    Method = "GET";
                    Name = "Wikipedia FR";
                    URLTemplate = "https://www.wikipedia.org/search-redirect.php?family=wikipedia&search={searchTerms}&language=fr&go=Go";
                  }
                  {
                    Alias = "@yt";
                    Description = "Search in Youtube";
                    IconURL = "https://www.youtube.com/s/desktop/33ae93e9/img/logos/favicon.ico";
                    Method = "GET";
                    Name = "Youtube";
                    URLTemplate = "https://www.youtube.com/results?search_query={searchTerms}";
                  }
                ];
                Remove = [
                  "Bing"
                  "Wikipedia (en)"
                ];
              };
            };
          profiles = {
            valentin = {
              isDefault = true;
              settings = {
                "browser.download.useDownloadDir" = false;
                "browser.translations.alwaysTranslateLanguages" = "de,it,es";
                "browser.translations.neverTranslateLanguages" = "fr,en";
                "intl.regional_prefs.use_os_locales" = true;
                "services.sync.username" = config.sops.secrets."emails/mozilla";
                "services.sync.engine.workspaces" = true;
                "zen.pinned-tab-manager.restore-pinned-tabs-to-pinned-url" = true;
                "zen.view.compact.enable-at-startup" = true;
                "zen.welcome-screen.seen" = true;
                "zen.workspaces.container-specific-essentials-enabled" = true;
                "zen.workspaces.continue-where-left-off" = true;
              };
              extensions = {
                force = true;
                settings = {
                  "uBlock0@raymondhill.net".settings = {
                    # https://github.com/gorhill/uBlock/blob/master/src/js/background.js
                    advancedUserEnabled = true;
                    hiddenSettings.userResourcesLocation = "https://raw.githubusercontent.com/ryanbr/TwitchAdSolutions/6f7f110eb1a8134ae200fcaceeaad999be03d5d8/vaft/vaft-ublock-origin.js";
                    user-filters = "twitch.tv##+js(twitch-videoad)";
                  };
                };
              };
              containersForce = true;
              containers = {
                personal = {
                  name = "Personal";
                  color = "blue";
                  icon = "fingerprint";
                  id = 1;
                };
                work = {
                  name = "Work";
                  color = "orange";
                  icon = "briefcase";
                  id = 2;
                };
              };
            };
          };
        };
      };
  };
}
