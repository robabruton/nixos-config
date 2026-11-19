# Graphical login

The graphical greeter starts on TTY1. Enter the username and password
chosen during installation. The preset session starts Niri with a
Noctalia panel showing workspaces and the clock.

- Press **Super+Enter** to open the Foot terminal.
- Press **Super+E** to open Files (Nautilus).
- Press **Super+D**, type **Firefox**, and press **Enter** to launch it.
- Press **Super+Alt+L** to lock the session.
- Press **Super+Q** to close the focused window.
- Press **Super+Shift+E** and confirm to log out. The greeter returns.
- From the greeter, press **Ctrl+Alt+F2** to reach the text login and use
  the same account.
  Press **Ctrl+Alt+F1** to return to the greeter or graphical session.

The system-wide Niri configuration is at `/etc/niri/config.kdl`. For
login or session startup problems, inspect `journalctl -b -u greetd`
from the text console.

On the installed ThinkPad, check that the greeter appears on the
internal panel after unlocking LUKS. Check the shortcuts on the built-in
keyboard, including switching to TTY2 from inside the Niri session.

## Firefox and Git

Firefox keeps its profile in your home directory. To clone this public
repository, run the following in Foot as your own account.

```sh
git clone https://github.com/robabruton/nixos-config.git
```

The public clone needs no credentials. Keep any Git credentials in
your account's credential storage, outside the NixOS configuration.

## Files, screenshots, and clipboard

Files opens local folders and supports moving files to Trash. Open it
with **Super+E** or search for **Files** in the Noctalia launcher.
Run `yazi` in Foot to browse the current directory in the terminal.

- Press **Print Screen**, drag a region, and press **Space** to capture it.
- Press **Ctrl+Print Screen** to capture the focused display.
- Press **Alt+Print Screen** to capture the focused window.

Niri saves captures as PNGs in `~/Pictures/Screenshots` and copies them
to the clipboard. It creates the directory on the first capture. In the
region selector, **Ctrl+C** copies without saving.

Use the clipboard icon in the Noctalia panel to recover a previous
copy. To delete one entry, select it and use the trash button in its
preview. Use the trash button above the history list to clear it.
Confirm the action when prompted.
History is encrypted on disk when the system keyring is available.
With the keyring locked or unavailable, history stays in the current
session.

## Audio

Use the speaker and microphone controls in the Noctalia panel to adjust
levels or mute a device. Open the audio panel from a control to select
input and output devices. The volume and mute keys work in Niri.
PipeWire handles playback and capture, and WirePlumber manages devices
and routing. Run `wpctl status` to see the available devices and defaults.

On the ThinkPad, play audio through the speakers and record a short clip
with the built-in microphone. Check the volume and mute keys, then repeat
playback and recording with a headset if you use one.

## Session locking

Noctalia locks the session after 10 minutes of inactivity and before
the system suspends. Use your installed account password to unlock it.
Logind handles the lid and power button according to the
[ThinkPad hardware policy](thinkpad-hardware.md).

The system-wide defaults are in `/etc/noctalia/config.toml`. Noctalia
settings saved in `~/.local/state/noctalia/settings.toml` take precedence.

On the ThinkPad, close the lid on battery and on AC, then reopen it and
check for the password prompt on the internal panel. Repeat using the
power button to suspend.

## Workstation profile

The ThinkPad imports `modules/workstation` and sets
`profiles.workstation.enable = true;`. Other hosts can opt in the same
way. The module provides the graphical session and leaves hardware and
boot configuration to the host.

## TrackPoint

Niri configures libinput to scroll when the physical middle button
(`BTN_MIDDLE`, Linux input code 274) is held while moving the TrackPoint.
[libinput button scrolling](https://wayland.freedesktop.org/libinput/doc/latest/scrolling.html#button-scrolling)

On the ThinkPad, verify vertical and horizontal scrolling in a window
with scrollable content. Confirm that releasing the button restores
pointer movement and that a stationary middle click behaves normally.
