# ThinkPad X1 Carbon Gen 9 hardware

The profile loads Intel `i915` in the initrd and enables Mesa and the Intel
media driver. The kernel exposes the built-in input devices and backlight
controls. The profile enables libinput and the TrackPoint hardware.

Logind suspends on lid close, on battery or AC, and on a short power-button
press. It ignores lid close while docked or with more than one display
connected. Long power-button presses remain subject to the firmware's
emergency power-off behavior. The kernel uses the platform's default sleep
mode.

## Before erasing the target disk

- Boot the official graphical NixOS ISO in UEFI mode. Check the built-in
  display, brightness keys, keyboard, and touchpad in the live desktop.
- Confirm the Intel AX201 connects from the live USB and the GitHub clone
  succeeds over Wi-Fi. Follow the [live USB checks](thinkpad-installation.md#boot-the-live-usb-and-verify-wi-fi).

## After installing

- Unlock LUKS and log in on a TTY using the built-in keyboard. Confirm
  that `i915` drives the internal panel, that its brightness changes, and
  that the kernel detects the touchpad and TrackPoint.
- Suspend and resume with the lid on battery and AC. Check that the display
  and input work after resume and that a short power-button press suspends.
  If using a dock or external display, confirm closed-lid operation there.
  Inspect the effective policy with
  `systemd-analyze cat-config systemd/logind.conf`.
