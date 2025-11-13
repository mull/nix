{ config, pkgs, lib, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
        FastConnectable = true;
        AutoEnable = true;
      };
    };
  };
  services.blueman.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
    wireplumber.extraConfig = {
      "wireplumber.profiles" = {
        "bluez-monitor" = {
          "properties" = {
            "bluez5.enable-msbc" = true;
            "bluez5.enable-sbc-xq" = true;
            "bluez5.enable-hw-volume" = true;
            "bluez5.codecs" = ["sbc" "aac"];
          };
        };
      };
    };
  };
}

