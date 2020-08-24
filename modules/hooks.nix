{ config, lib, pkgs, ... }:
let
  inherit (config.pre-commit) tools settings;
  inherit (lib) mkOption types;
in
{
  options.pre-commit.settings =
    {
      ormolu =
        {
          defaultExtensions =
            mkOption {
              type = types.listOf types.str;
              description = "Haskell language extensions to enable";
              default = [];
            };
        };
      nix-linter =
        {
          checks =
            mkOption {
              type = types.listOf types.str;
              description =
                "Available checks (See `nix-linter --help-for [CHECK]` for more details)";
              default = [];
            };
        };
    };

  config.pre-commit.hooks =
    {
      ansible-lint =
        {
          name = "ansible-lint";
          description =
            "Ansible linter";
          entry = "${tools.ansible-lint}/bin/ansible-lint";
        };
      brittany =
        {
          name = "brittany";
          description = "Haskell source code formatter.";
          entry = "${tools.brittany}/bin/brittany --write-mode=inplace";
          files = "\\.l?hs$";
        };
      flake8 = {
        description = "A python tool that glues together pep8, pyflakes, mccabe, and third-party plugins";
        entry = "${pkgs.python3Packages.flake8}/bin/flake8";
        files = "\\.py$";
      };
      hlint =
        {
          name = "hlint";
          description =
            "HLint gives suggestions on how to improve your source code.";
          entry = "${tools.hlint}/bin/hlint";
          files = "\\.l?hs$";
        };
      hpack =
        {
          name = "hpack";
          description =
            "hpack converts package definitions in the hpack format (package.yaml) to Cabal files.";
          entry = "${tools.hpack}/bin/hpack --force .";
          files = "(\\.l?hs$)|(^[^/]+\\.cabal$)|(^package\\.yaml$)";
          pass_filenames = false;
        };
      ormolu =
        {
          name = "ormolu";
          description = "Haskell code prettifier.";
          entry =
            "${tools.ormolu}/bin/ormolu --mode inplace ${
            lib.escapeShellArgs (lib.concatMap (ext: [ "--ghc-opt" "-X${ext}" ]) settings.ormolu.defaultExtensions)
            }";
          files = "\\.l?hs$";
        };
      hindent =
        {
          name = "hindent";
          description = "Haskell code prettifier.";
          entry = "${tools.hindent}/bin/hindent";
          files = "\\.l?hs$";
        };
      cabal-fmt =
        {
          name = "cabal-fmt";
          description = "Format Cabal files";
          entry = "${tools.cabal-fmt}/bin/cabal-fmt --inplace";
          files = "\\.cabal$";
        };
      nixfmt =
        {
          name = "nixfmt";
          description = "Nix code prettifier.";
          entry = "${tools.nixfmt}/bin/nixfmt";
          files = "\\.nix$";
        };
      nixpkgs-fmt =
        {
          name = "nixpkgs-fmt";
          description = "Nix code prettifier.";
          entry = "${tools.nixpkgs-fmt}/bin/nixpkgs-fmt";
          files = "\\.nix$";
        };
      nix-linter =
        {
          name = "nix-linter";
          description = "Linter for the Nix expression language.";
          entry =
            "${tools.nix-linter}/bin/nix-linter ${
            lib.escapeShellArgs (lib.concatMap (check: [ "-W" "${check}" ]) settings.nix-linter.checks)
            }";
          files = "\\.nix$";
        };
      elm-format =
        {
          name = "elm-format";
          description = "Format Elm files";
          entry =
            "${tools.elm-format}/bin/elm-format --yes --elm-version=0.19";
          files = "\\.elm$";
        };
      shellcheck =
        {
          name = "shellcheck";
          description = "Format shell files";
          types =
            [
              "bash"
            ];
          entry = "${tools.shellcheck}/bin/shellcheck";
        };
      terraform-format =
        {
          name = "terraform-format";
          description = "Format terraform (.tf) files";
          entry = "${tools.terraform-fmt}/bin/terraform-fmt";
          files = "\\.tf$";
        };
      yamllint =
        {
          name = "yamllint";
          description = "Yaml linter";
          types = [ "file" "yaml" ];
          entry = "${tools.yamllint}/bin/yamllint";
        };
      rustfmt =
        {
          name = "rustfmt";
          description = "Format Rust code.";
          entry = "${tools.rustfmt}/bin/cargo-fmt fmt -- --check --color always";
          files = "\\.rs$";
          pass_filenames = false;
        };
      clippy =
        {
          name = "clippy";
          description = "Lint Rust code.";
          entry = "${tools.clippy}/bin/cargo-clippy clippy";
          files = "\\.rs$";
          pass_filenames = false;
        };
      cargo-check =
        {
          name = "cargo-check";
          description = "Check the cargo package for errors";
          entry = "${tools.cargo}/bin/cargo check";
          files = "\\.rs$";
          pass_filenames = false;
        };
    };
}
