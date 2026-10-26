# `config.constants.<...>`
{ lib, ... }:
let
  username = "gnister";
in
{
  options.constants = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    default = { };
    description = "Identity, locale and paths shared across all hosts.";
  };

  config.constants = {
    user = {
      inherit username;
      name = "gnister";
      email = "sscharer@online.no";
      # Public keys (for SSH)
      sshKeys = [ ];
    };

    locale = {
      timeZone = "Europe/Oslo";
      default = "en_US.UTF-8";
      extra.LC_TIME = "nb_NO.UTF-8";
      keyboard = {
        layout = "no";
        variant = "";
        options = "";
      };
    };

    flakeDir = "/home/${username}/nixos";

    # Base domain for services server exposes through Caddy
    domain = "home.arpa";
  };
}
