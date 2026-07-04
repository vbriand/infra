{ inputs, den, ... }:
{
  flake-file.inputs = {
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  den.aspects.vscode = {
    base = {
      homeManager =
        { pkgs, ... }:
        {
          nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];

          programs.vscode =
            let
              # TODO: find how to centralize the common extensions and user settings between aspects
              # Possible alternative at some point: https://github.com/microsoft/vscode/issues/188612
              commonExtensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
                johnpapa.winteriscoming
                leodevbro.blockman
                pkief.material-icon-theme
                streetsidesoftware.code-spell-checker
                tuttieee.emacs-mcx
              ];
              commonUserSettings =
                let
                  blockmanSettings = {
                    "editor.inlayHints.enabled" = "off";
                    "editor.guides.indentation" = false;
                    "editor.guides.bracketPairs" = false;
                    "editor.wordWrap" = "off";
                    "diffEditor.wordWrap" = "off";
                    "workbench.colorCustomizations" = {
                      "editor.lineHighlightBorder" = "#9fced11f";
                      "editor.lineHighlightBackground" = "#1073cf2d";
                    };
                  };
                in
                {
                  "editor.formatOnSave" = true;
                  "git.blame.editorDecoration.enabled" = true;
                  "telemetry.telemetryLevel" = "off";
                  # Prevent emacs shortcuts used in the terminal from interacting with the main VS Code window
                  "terminal.integrated.allowChords" = false;
                  "workbench.colorTheme" = "Winter is Coming (Dark Blue)";
                  "workbench.iconTheme" = "material-icon-theme";
                }
                // blockmanSettings;
            in
            {
              enable = true;
              profiles = {
                default = {
                  # These options are only valid for the default profile
                  enableExtensionUpdateCheck = false;
                  enableUpdateCheck = false;
                  extensions = commonExtensions;
                  userSettings = commonUserSettings;
                };

                Nix = {
                  extensions =
                    with pkgs.nix-vscode-extensions.vscode-marketplace;
                    [
                      jnoortheen.nix-ide
                    ]
                    ++ commonExtensions;
                  userSettings = commonUserSettings;
                };
              };
            };
        };
    };

    personal.includes = [ den.aspects.vscode.base ];

    work = {
      includes = [ den.aspects.vscode.base ];

      homeManager =
        { pkgs, ... }:
        {
          programs.vscode =
            let
              commonExtensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
                johnpapa.winteriscoming
                leodevbro.blockman
                pkief.material-icon-theme
                streetsidesoftware.code-spell-checker
                tuttieee.emacs-mcx
              ];
              commonUserSettings =
                let
                  blockmanSettings = {
                    "editor.inlayHints.enabled" = "off";
                    "editor.guides.indentation" = false;
                    "editor.guides.bracketPairs" = false;
                    "editor.wordWrap" = "off";
                    "diffEditor.wordWrap" = "off";
                    "workbench.colorCustomizations" = {
                      "editor.lineHighlightBorder" = "#9fced11f";
                      "editor.lineHighlightBackground" = "#1073cf2d";
                    };
                  };
                in
                {
                  "editor.formatOnSave" = true;
                  "git.blame.editorDecoration.enabled" = true;
                  "telemetry.telemetryLevel" = "off";
                  # Prevent emacs shortcuts used in the terminal from interacting with the main VS Code window
                  "terminal.integrated.allowChords" = false;
                  "workbench.colorTheme" = "Winter is Coming (Dark Blue)";
                  "workbench.iconTheme" = "material-icon-theme";
                }
                // blockmanSettings;
            in
            {
              profiles = {
                LaTeX = {
                  enableExtensionUpdateCheck = false;
                  enableUpdateCheck = false;
                  extensions =
                    with pkgs.nix-vscode-extensions.vscode-marketplace;
                    [
                      james-yu.latex-workshop
                    ]
                    ++ commonExtensions;
                  userSettings = commonUserSettings;
                };
                React-Native = {
                  extensions =
                    with pkgs.nix-vscode-extensions.vscode-marketplace;
                    [
                      aaron-bond.better-comments
                      davidanson.vscode-markdownlint
                      dbaeumer.vscode-eslint
                      esbenp.prettier-vscode
                      expo.vscode-expo-tools
                      johnpapa.vscode-peacock
                      kruemelkatze.vscode-dashboard
                      mikestead.dotenv
                      streetsidesoftware.code-spell-checker-french-reforme
                      wix.vscode-import-cost
                      yoavbls.pretty-ts-errors
                    ]
                    ++ commonExtensions;
                  userSettings = commonUserSettings;
                };
              };
            };
        };
    };
  };
}
