# Graphical login

The graphical greeter starts on TTY1. Enter the username and password
chosen during installation. The preset session starts Niri with a
Noctalia panel showing workspaces and the clock.

- Press **Super+Enter** to open the Foot terminal.
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
