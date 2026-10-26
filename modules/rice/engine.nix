{ inputs, ... }:
{
  flake.modules.nixos.workstation =
    { config, lib, ... }:
    {
      options.workstation.profile = lib.mkOption {
        type = lib.types.str;
        default = "mocha";
        description = "Rice profile of the base generation (used until you pick another with `rice`).";
      };

      config.environment.etc = lib.mapAttrs' (
        user: hm: lib.nameValuePair "rice/${user}" { source = hm.home.activationPackage; }
      ) config.home-manager.users;
    };

  flake.modules.homeManager.workstation =
    {
      config,
      lib,
      osConfig,
      pkgs,
      ...
    }:
    let
      inherit (lib) mkOption types;
      cfg = config.rice;

      base16 = [
        "base00"
        "base01"
        "base02"
        "base03"
        "base04"
        "base05"
        "base06"
        "base07"
        "base08"
        "base09"
        "base0A"
        "base0B"
        "base0C"
        "base0D"
        "base0E"
        "base0F"
      ];
      slot = types.enum base16;

      font = types.submodule {
        options = {
          name = mkOption { type = types.str; };
          package = mkOption { type = types.package; };
        };
      };

      fraction = types.numbers.between 0 1;

      profileModule =
        { name, ... }:
        {
          options = {
            description = mkOption {
              type = types.str;
              default = name;
              description = "One line shown by `rice list` and the picker.";
            };
            polarity = mkOption {
              type = types.enum [
                "dark"
                "light"
              ];
              default = "dark";
            };
            scheme = mkOption {
              type = types.nullOr (
                types.oneOf [
                  types.str
                  types.path
                  (types.attrsOf types.str)
                ]
              );
              default = null;
              description = ''
                base16 colours: a scheme name from base16-schemes (browse with
                `rice schemes`), a path to a scheme YAML, an attrset of
                base00…base0F, or null to derive the palette from
                `wallpaper.image`.
              '';
            };
            accent = mkOption {
              type = slot;
              default = "base0D";
              description = "Main accent: focus ring, active workspace, highlights.";
            };
            accent2 = mkOption {
              type = slot;
              default = "base0E";
              description = "Secondary accent: gradient end, rice indicator.";
            };

            wallpaper = {
              image = mkOption {
                type = types.nullOr types.path;
                default = null;
                description = "Wallpaper file. When null, one is generated from the palette.";
              };
              generate = mkOption {
                type = types.enum [
                  "solid"
                  "gradient"
                  "radial"
                  "blobs"
                ];
                default = "blobs";
                description = "Generator used when `image` is null.";
              };
              colors = mkOption {
                type = types.listOf slot;
                default = [
                  "base00"
                  "base0D"
                  "base0E"
                  "base0C"
                ];
                description = "Palette slots fed to the generator (background first).";
              };
              transition = mkOption {
                type = types.str;
                default = "grow";
                description = "awww transition when switching to this profile (grow, wipe, wave, fade, outer, ...).";
              };
            };

            fonts = {
              mono = mkOption {
                type = font;
                default = {
                  name = "JetBrainsMono Nerd Font";
                  package = pkgs.nerd-fonts.jetbrains-mono;
                };
              };
              sans = mkOption {
                type = font;
                default = {
                  name = "Inter";
                  package = pkgs.inter;
                };
              };
              serif = mkOption {
                type = font;
                default = {
                  name = "Noto Serif";
                  package = pkgs.noto-fonts;
                };
              };
              size = {
                terminal = mkOption {
                  type = types.ints.positive;
                  default = 11;
                };
                ui = mkOption {
                  type = types.ints.positive;
                  default = 11;
                };
              };
            };

            cursor = {
              name = mkOption {
                type = types.str;
                default = "Bibata-Modern-Classic";
              };
              package = mkOption {
                type = types.package;
                default = pkgs.bibata-cursors;
              };
              size = mkOption {
                type = types.ints.positive;
                default = 24;
              };
            };

            icons = {
              package = mkOption {
                type = types.package;
                default = pkgs.papirus-icon-theme;
              };
              dark = mkOption {
                type = types.str;
                default = "Papirus-Dark";
              };
              light = mkOption {
                type = types.str;
                default = "Papirus-Light";
              };
            };

            opacity = {
              terminal = mkOption {
                type = fraction;
                default = 1.0;
              };
              bar = mkOption {
                type = fraction;
                default = 1.0;
              };
              popups = mkOption {
                type = fraction;
                default = 1.0;
              };
              inactive = mkOption {
                type = fraction;
                default = 1.0;
                description = "Opacity of unfocused windows.";
              };
            };

            gaps = mkOption {
              type = types.ints.unsigned;
              default = 8;
            };
            radius = mkOption {
              type = types.ints.unsigned;
              default = 10;
              description = "Corner radius shared by windows, bar, launcher and notifications.";
            };
            border = {
              kind = mkOption {
                type = types.enum [
                  "ring"
                  "border"
                ];
                default = "ring";
                description = "niri focus ring (drawn outside the window) or border (inside).";
              };
              width = mkOption {
                type = types.ints.unsigned;
                default = 2;
              };
              gradient = mkOption {
                type = types.bool;
                default = false;
                description = "Fade the active border from `accent` to `accent2`.";
              };
            };
            shadow = mkOption {
              type = types.bool;
              default = true;
            };

            bar = {
              style = mkOption {
                type = types.enum [
                  "islands"
                  "docked"
                  "minimal"
                ];
                default = "islands";
                description = "islands: floating rounded groups · docked: full-width strip · minimal: bare text.";
              };
              position = mkOption {
                type = types.enum [
                  "top"
                  "bottom"
                ];
                default = "top";
              };
              height = mkOption {
                type = types.ints.positive;
                default = 34;
              };
              extraCss = mkOption {
                type = types.lines;
                default = "";
                description = "Appended to the generated waybar stylesheet.";
              };
            };

            lock.blur = mkOption {
              type = types.bool;
              default = true;
              description = "Lock screen shows a blurred screenshot (true) or the wallpaper (false).";
            };

            nvim.colorscheme = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Use this Neovim colorscheme instead of painting it from the palette.";
            };
          };
        };

      schemeFile =
        scheme:
        if builtins.isString scheme && !lib.hasPrefix "/" scheme then
          "${pkgs.base16-schemes}/share/themes/${scheme}.yaml"
        else
          scheme;

      p =
        cfg.profiles.${cfg.active} or (throw ''
          rice: unknown profile "${cfg.active}". Defined profiles: ${lib.concatStringsSep ", " (lib.attrNames cfg.profiles)}
        '');

      paletteOf = colors: lib.genAttrs base16 (name: colors.withHashtag.${name});

      # Palette of every profile, for previews in `rice list`. Only the base
      # generation can see the others (through its specialisations).
      paletteFor =
        name:
        if name == cfg.active then
          paletteOf config.lib.stylix.colors
        else if config.specialisation ? ${name} then
          paletteOf config.specialisation.${name}.configuration.lib.stylix.colors
        else
          null;
    in
    {
      imports = [ inputs.stylix.homeModules.stylix ];

      options.rice = {
        profiles = mkOption {
          type = types.attrsOf (types.submodule profileModule);
          default = { };
          description = "All rice profiles. One file per profile in modules/rice/profiles/.";
        };
        default = mkOption {
          type = types.str;
          default = osConfig.workstation.profile;
          description = "Profile of the base generation.";
        };
        active = mkOption {
          type = types.str;
          description = "Profile rendered by this generation (set per specialisation; don't set by hand).";
        };
        current = mkOption {
          type = types.raw;
          readOnly = true;
          internal = true;
          description = "The resolved active profile, for the rendering modules.";
        };
      };

      config = {
        assertions = [
          {
            assertion = cfg.profiles ? ${cfg.default};
            message = "rice: default profile \"${cfg.default}\" is not defined (have: ${lib.concatStringsSep ", " (lib.attrNames cfg.profiles)}).";
          }
        ];

        rice.active = lib.mkDefault cfg.default;
        rice.current = p;

        specialisation = lib.mapAttrs (name: _: {
          configuration.rice.active = lib.mkForce name;
        }) (removeAttrs cfg.profiles [ cfg.default ]);

        # With useUserPackages, NixOS installs only the base generation's
        # packages; install every profile's fonts, icons and cursors so they
        # exist whichever profile is active.
        home.packages = lib.unique (
          lib.concatMap (profile: [
            profile.fonts.mono.package
            profile.fonts.sans.package
            profile.fonts.serif.package
            profile.icons.package
            profile.cursor.package
          ]) (lib.attrValues cfg.profiles)
        );

        # Re-enter the remembered profile whenever the base generation is
        # activated (nixos-rebuild, boot). Runs before anything is written and
        # hands over to the specialisation's own activation.
        home.activation.riceRestore = lib.mkIf (config.specialisation != { }) (
          lib.hm.dag.entryBefore [ "checkLinkTargets" "checkFilesChanged" "writeBoundary" ] ''
            _riceState="''${XDG_STATE_HOME:-$HOME/.local/state}/rice/profile"
            if [[ -z "''${RICE_SKIP_RESTORE:-}" && ! -v DRY_RUN && -r "$_riceState" ]]; then
              case "$(<"$_riceState")" in
              ${lib.concatStrings (
                lib.mapAttrsToList (name: spec: ''
                  ${name})
                    echo "rice: restoring profile ${name}"
                    RICE_SKIP_RESTORE=1 exec ${spec.configuration.home.activationPackage}/activate
                    ;;
                '') config.specialisation
              )}
              esac
            fi
          ''
        );

        xdg.configFile = {
          "rice/active".text = cfg.active;
          "rice/profiles.json".text = builtins.toJSON {
            inherit (cfg) default;
            profiles = lib.mapAttrsToList (name: profile: {
              inherit name;
              inherit (profile) description polarity;
              palette = paletteFor name;
            }) cfg.profiles;
          };
        };

        stylix = {
          enable = true;
          inherit (p) polarity;
          base16Scheme = lib.mkIf (p.scheme != null) (schemeFile p.scheme);
          image = config.rice.wallpaper;

          fonts = {
            monospace = p.fonts.mono;
            sansSerif = p.fonts.sans;
            serif = p.fonts.serif;
            emoji = {
              name = "Noto Color Emoji";
              package = pkgs.noto-fonts-color-emoji;
            };
            sizes = {
              terminal = p.fonts.size.terminal;
              applications = p.fonts.size.ui;
              desktop = p.fonts.size.ui;
              popups = p.fonts.size.ui;
            };
          };

          inherit (p) cursor;

          icons = {
            enable = true;
            inherit (p.icons) package dark light;
          };

          opacity = {
            terminal = p.opacity.terminal;
            popups = p.opacity.popups;
            desktop = p.opacity.bar;
          };

          overlays.enable = false;

          targets = {
            # Rendered by the rice modules instead.
            waybar.enable = false;
            neovim.enable = false;
            # Not used on a niri desktop (and expensive to build).
            gnome.enable = false;
            kde.enable = false;
            firefox.profileNames = [ "default" ];
            swaylock.image.enable = !p.lock.blur;
          };
        };

        dconf.settings."org/gnome/desktop/interface".color-scheme = lib.mkDefault (
          if p.polarity == "dark" then "prefer-dark" else "default"
        );
      };
    };
}