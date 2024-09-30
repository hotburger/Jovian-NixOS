{ stdenv
, resholve

, bash
, jq
, systemd
, util-linux
}:

let
  solution = {
    scripts = [ "bin/steamos-polkit-helpers/*" ];
    interpreter = "${bash}/bin/bash";
    inputs = [
#      coreutils
#      dmidecode
#      gawk
#      gnugrep
#      "${jupiter-dock-updater-bin}/lib/jupiter-dock-updater"
#      jovian-stubs
#      jupiter-hw-support
#      "${jupiter-hw-support}/lib/hwsupport"
      jq
#      steamdeck-firmware
      systemd
      util-linux
#      wirelesstools
#
#      #"${placeholder "out"}/bin/steamos-polkit-helpers"
    ];
    execer = [
#      "cannot:${jovian-stubs}/bin/jupiter-biosupdate"
#      "cannot:${jovian-stubs}/bin/steamos-reboot"
#      "cannot:${jovian-stubs}/bin/steamos-factory-reset-config"
#      "cannot:${jovian-stubs}/bin/steamos-select-branch"
#      "cannot:${jovian-stubs}/bin/steamos-update"
#      "cannot:${jupiter-dock-updater-bin}/lib/jupiter-dock-updater/jupiter-dock-updater.sh"
#      "cannot:${jupiter-hw-support}/bin/jupiter-check-support"
#      "cannot:${jupiter-hw-support}/lib/hwsupport/format-device.sh"
#      "cannot:${jupiter-hw-support}/lib/hwsupport/format-sdcard.sh"
#      "cannot:${jupiter-hw-support}/lib/hwsupport/trim-devices.sh"
#      "cannot:${steamdeck-firmware}/bin/jupiter-biosupdate"
#      "cannot:${systemd}/bin/poweroff"
#      "cannot:${systemd}/bin/reboot"
#      "cannot:${systemd}/bin/systemctl"
#      "cannot:${systemd}/bin/systemd-cat"
    ];
    fake = {
      external = ["pkexec"];
    };
    fix = {
      "/usr/bin/jupiter-biosupdate" = true;
      "/usr/bin/jupiter-check-support" = true;
      "/usr/bin/steamos-factory-reset-config" = true;
      "/usr/bin/steamos-reboot" = true;
      "/usr/bin/steamos-select-branch" = true;
      "/usr/bin/steamos-update" = true;
      "/usr/lib/hwsupport/format-device.sh" = true;
      "/usr/lib/hwsupport/format-sdcard.sh" = true;
      "/usr/lib/hwsupport/trim-devices.sh" = true;
      "/usr/lib/jupiter-dock-updater/jupiter-dock-updater.sh" = true;
      #"${placeholder "out"}/bin/steamos-polkit-helpers/steamos-format-device" = true;
    };
    keep = {
      # this file is removed in latest versions of hwsupport
      "/usr/lib/hwsupport/jupiter-amp-control" = true;
      "${placeholder "out"}/bin/steamos-polkit-helpers/steamos-format-device" = true;
    };
  };
in
stdenv.mkDerivation {
  name = "jovian-support-scripts";

  buildCommand = ''
    install -D -m 755 ${./steamos-format-sdcard} $out/bin/steamos-format-sdcard
    install -D -m 755 ${./steamos-format-device} $out/bin/steamos-format-device

    substituteInPlace $out/bin/steamos-format-sdcard \
      --replace-fail "/usr/bin/steamos-polkit-helpers/steamos-format-device" "$out/bin/steamos-polkit-helpers/steamos-format-device"
    (
    cd $out/bin

    mkdir -v steamos-polkit-helpers
    cd steamos-polkit-helpers
    ln -v -t . ../steamos-format-*
    )

    ${resholve.phraseSolution "steamos-format-sdcard" solution}
    ${resholve.phraseSolution "steamos-format-device" solution}
  '';

  meta = {
    # Any script defined here should be prioritized over Steam's own.
    priority = -10;
  };
}
