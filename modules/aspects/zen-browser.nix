{ inputs, lib, ... }:
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
            };
          profiles = {
            valentin = {
              isDefault = true;
              settings = {
                "browser.download.useDownloadDir" = false;
                "browser.translations.alwaysTranslateLanguages" = "de,it,es";
                "browser.translations.neverTranslateLanguages" = "fr,en";
                "intl.regional_prefs.use_os_locales" = true;
                "intl.locale.requested" = "en-GB";
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
              search =
                let
                  hideDefaultSearchEngines =
                    searchEngines:
                    lib.genAttrs searchEngines (id: {
                      inherit id;
                      metaData = {
                        hidden = true;
                      };
                    });
                in
                {
                  # https://gist.github.com/Tblue/62ff47bef7f894e92ed5
                  # nix-shell -p 'python314.withPackages (ps: with ps; [ lz4 ])' --run 'python3 mozlz4a.py -d search.json.mozlz4 search.json'
                  force = true;
                  default = "google";
                  engines = {
                    areweanticheatyet = {
                      name = "Are We Anti-Cheat Yet?";
                      icon = "https://areweanticheatyet.com/icon.webp";
                      definedAliases = [ "@ac" ];
                      urls = [
                        {
                          template = "https://areweanticheatyet.com/?search={searchTerms}";
                        }
                      ];
                    };
                    wordreference-enfr = {
                      name = "WordReference (EN to FR)";
                      icon = "https://www.wordreference.com/favicon.ico";
                      definedAliases = [ "@enfr" ];
                      urls = [
                        {
                          template = "https://www.wordreference.com/redirect/translation.aspx?w={searchTerms}&dict=enfr";
                        }
                      ];
                    };
                    wordreference-fren = {
                      name = "WordReference (FR to EN)";
                      icon = "https://www.wordreference.com/favicon.ico";
                      definedAliases = [ "@fren" ];
                      urls = [
                        {
                          template = "https://www.wordreference.com/redirect/translation.aspx?w={searchTerms}&dict=fren";
                        }
                      ];
                    };
                    howlongtobeat = {
                      name = "How Long To Beat";
                      icon = "https://howlongtobeat.com/img/icons/favicon-96x96.png";
                      definedAliases = [ "@hltb" ];
                      urls = [
                        {
                          template = "https://howlongtobeat.com/?q={searchTerms}";
                        }
                      ];
                    };
                    home-manager = {
                      name = "Home Manager";
                      icon = "https://mynixos.com/favicon-32x32.png";
                      definedAliases = [ "@hm" ];
                      urls = [
                        {
                          template = "https://mynixos.com/search?q=home-manager+{searchTerms}";
                        }
                      ];
                    };
                    nixos-packages = {
                      name = "NixOS packages";
                      icon = "https://nixos.org/favicon.ico";
                      definedAliases = [ "@np" ];
                      urls = [
                        {
                          template = "https://search.nixos.org/packages?channel=unstable&from=0&size=200&sort=relevance&type=packages&query={searchTerms}";
                        }
                      ];
                    };
                    nixos-options = {
                      name = "NixOS options";
                      icon = "https://nixos.org/favicon.ico";
                      definedAliases = [ "@no" ];
                      urls = [
                        {
                          template = "https://search.nixos.org/options?channel=unstable&from=0&size=200&sort=relevance&type=packages&query={searchTerms}";
                        }
                      ];
                    };
                    nixos-wiki = {
                      name = "NixOS wiki";
                      icon = "https://nixos.org/favicon.ico";
                      definedAliases = [ "@nw" ];
                      urls = [
                        {
                          template = "https://wiki.nixos.org/w/index.php?search={searchTerms}&title=Special%3ASearch&wprov=acrw1_-1";
                        }
                      ];
                    };
                    pcgamingwiki = {
                      name = "PCGamingWiki";
                      icon = "https://static.pcgamingwiki.com/favicons/pcgamingwiki.png";
                      definedAliases = [ "@pc" ];
                      urls = [
                        {
                          template = "https://www.pcgamingwiki.com/w/index.php?search={searchTerms}&title=Special%3ASearch";
                        }
                      ];
                    };
                    protondb = {
                      name = "ProtonDB";
                      icon = "https://www.protondb.com/sites/protondb/images/site-logo.svg";
                      definedAliases = [ "@pdb" ];
                      urls = [
                        {
                          template = "https://www.protondb.com/search?q={searchTerms}";
                        }
                      ];
                    };
                    universal-hint-system = {
                      name = "Universal Hint System";
                      icon = "https://static.uhs-hints.com/images/crystal-ball-transparent-16.png";
                      definedAliases = [ "@uhs" ];
                      urls = [
                        {
                          template = "https://www.uhs-hints.com/hints/search.php?search={searchTerms}";
                        }
                      ];
                    };
                    wikipedia-en = {
                      name = "Wikipedia EN";
                      icon = "https://wikipedia.org/static/favicon/wikipedia.ico";
                      definedAliases = [ "@w" ];
                      urls = [
                        {
                          template = "https://www.wikipedia.org/search-redirect.php?family=wikipedia&search={searchTerms}&language=en&go=Go";
                        }
                      ];
                    };
                    wikipedia-fr = {
                      name = "Wikipedia FR";
                      icon = "https://wikipedia.org/static/favicon/wikipedia.ico";
                      definedAliases = [ "@wfr" ];
                      urls = [
                        {
                          template = "https://www.wikipedia.org/search-redirect.php?family=wikipedia&search={searchTerms}&language=fr&go=Go";
                        }
                      ];
                    };
                    youtube = {
                      name = "Youtube";
                      icon = "https://www.youtube.com/s/desktop/33ae93e9/img/logos/favicon.ico";
                      definedAliases = [ "@yt" ];
                      urls = [
                        {
                          template = "https://www.youtube.com/results?search_query={searchTerms}";
                        }
                      ];
                    };
                  }
                  // hideDefaultSearchEngines [
                    "bing"
                    "ddg"
                    "ebay-uk"
                    "perplexity"
                    "qwant"
                    "wikipedia"
                  ];
                };
            };
          };
        };
      };
  };
}
