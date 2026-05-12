{ config, pkgs, lib, isDesktop ? false, ... }:
{
  # Write the niri config file in KDL format.
  # After changing this, run: niri msg action reload-config
  xdg.configFile."niri/config.kdl".text = /* kdl */ ''
    // =========================================================================
    // Input
    // =========================================================================
    input {
        keyboard {
            xkb {
                layout "no"
                // options "caps:escape"    // remap Caps Lock → Escape
            }
            repeat-delay 400
            repeat-rate  30
        }

        touchpad {
            tap                  // tap-to-click
            natural-scroll
            dwt                  // disable-while-typing
            // accel-speed 0.2
        }

        mouse {
            // accel-speed 0.0
        }

        // Warp pointer on focus change
        warp-mouse-to-focus
        focus-follows-mouse max-scroll-amount="0%"
    }

    // =========================================================================
    // Outputs
    // Run `niri msg outputs` to list your connected displays.
    // =========================================================================
  '' + (if isDesktop then /* kdl */ ''
    // Desktop — two monitors side by side.
    // Replace "DP-1" / "DP-2" with your actual connector names.
    output "DP-1" {
        scale 1.0
        position x=0 y=0
    }

    output "DP-2" {
        scale 1.0
        position x=1920 y=0   // adjust to your left monitor's width
    }
  '' else /* kdl */ ''
    // Laptop — single built-in display.
    // Replace "eDP-1" if your connector name differs.
    output "eDP-1" {
        scale 1.0
    }
  '') + /* kdl */ ''

    // =========================================================================
    // Layout
    // =========================================================================
    layout {
        gaps 8

        center-focused-column "never"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        default-column-width { proportion 0.5; }

        focus-ring {
            width 2
            active-color   "#89b4fa"
            inactive-color "#45475a"
        }

        border {
            off
        }

        struts {
            // Reserve space for waybar (set to bar height if needed)
            // top 30
        }
    }

    // Clients cannot request server-side decorations (avoids double borders)
    prefer-no-csd

    // Where built-in screenshots land
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    // =========================================================================
    // Animations
    // =========================================================================
    animations {
        slowdown 1.0   // >1 = slower, <1 = faster, 0 = off
    }

    // =========================================================================
    // Key bindings
    // Mod = Super (Windows key)
    // =========================================================================
    binds {
        // --- Applications -------------------------------------------
        Mod+Return { spawn "alacritty"; }
        Mod+D      { spawn "fuzzel"; }
        Mod+E      { spawn "nautilus"; }

        // --- Window management --------------------------------------
        Mod+Shift+Q  { close-window; }
        Mod+F        { maximize-column; }
        Mod+Shift+F  { fullscreen-window; }
        Mod+C        { center-column; }
        Mod+Comma    { consume-window-into-column; }
        Mod+Period   { expel-window-from-column; }

        // --- Focus --------------------------------------------------
        Mod+H     { focus-column-left; }
        Mod+L     { focus-column-right; }
        Mod+J     { focus-window-down; }
        Mod+K     { focus-window-up; }
        Mod+Left  { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }

        // Move focus between monitors
        Mod+Shift+H { focus-monitor-left; }
        Mod+Shift+L { focus-monitor-right; }

        // --- Move windows -------------------------------------------
        Mod+Ctrl+H     { move-column-left; }
        Mod+Ctrl+L     { move-column-right; }
        Mod+Ctrl+J     { move-window-down; }
        Mod+Ctrl+K     { move-window-up; }
        Mod+Ctrl+Left  { move-column-left; }
        Mod+Ctrl+Right { move-column-right; }

        // Move window to other monitor
        Mod+Shift+Ctrl+H { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+L { move-column-to-monitor-right; }

        // --- Resize -------------------------------------------------
        Mod+R       { switch-preset-column-width; }
        Mod+Minus   { set-column-width "-10%"; }
        Mod+Equal   { set-column-width "+10%"; }
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        // --- Workspaces ---------------------------------------------
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }

        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }

        Mod+Tab         { focus-workspace-down; }
        Mod+Shift+Tab   { focus-workspace-up; }

        // --- Screenshots --------------------------------------------
        // Built-in niri screenshot (saves to screenshot-path above)
        Print           { screenshot; }
        Ctrl+Print      { screenshot-screen; }
        Alt+Print       { screenshot-window; }
        // Region screenshot piped to clipboard via grim+slurp
        Mod+Shift+S     { spawn "bash" "-c" "grim -g \"$(slurp)\" - | wl-copy"; }

        // --- Audio --------------------------------------------------
        XF86AudioRaiseVolume  allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume  allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioMute         allow-when-locked=true { spawn "wpctl" "set-mute"   "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86AudioMicMute      allow-when-locked=true { spawn "wpctl" "set-mute"   "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

        // --- Brightness (laptop) ------------------------------------
        XF86MonBrightnessUp   { spawn "brightnessctl" "set" "+10%"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "set" "10%-"; }

        // --- Session ------------------------------------------------
        Mod+Shift+E { quit; }
        Mod+Shift+P { power-off-monitors; }
        Ctrl+Alt+Delete { spawn "bash" "-c" "niri msg action quit"; }
    }

    // =========================================================================
    // Window rules
    // =========================================================================
    window-rule {
        // Float certain windows by default
        match app-id=r#"^(pavucontrol|nm-connection-editor|blueman-manager)$"#
        open-floating true
    }

    window-rule {
        match app-id="firefox" title="Picture-in-Picture"
        open-floating true
        open-on-output "eDP-1"
    }

    // =========================================================================
    // Hotkey overlay (shown on Mod+? by default)
    // =========================================================================
    hotkey-overlay {
        skip-at-startup
    }
  '';
}
