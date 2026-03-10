#!/usr/bin/env python3
"""
Linux config script — applies user-level configuration after apps are installed.

Configuration applied:
  - Default shell changed to zsh
  - Default terminal changed to ghostty (via xdg-terminals.list for xdg-terminal-exec)
"""

import os
import shutil
import subprocess
from pathlib import Path


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def run(cmd, **kwargs):
    """Run a shell command, raising on failure."""
    return subprocess.run(cmd, check=True, **kwargs)


def section(title):
    print(f"\n{'─' * 60}")
    print(f"  {title}")
    print('─' * 60, flush=True)


# ---------------------------------------------------------------------------
# Default shell → zsh
# ---------------------------------------------------------------------------

section("Default shell → zsh")
zsh_path = shutil.which("zsh")
current_shell = os.environ.get("SHELL", "")
if zsh_path and current_shell == zsh_path:
    print(f"Default shell is already {zsh_path} — skipping.")
elif zsh_path is None:
    print("zsh not found on PATH — cannot change default shell.")
else:
    print(f"Changing default shell to {zsh_path}…")
    run(["chsh", "-s", zsh_path])


# ---------------------------------------------------------------------------
# Default terminal → ghostty (xdg-terminal-exec, used by Omarchy/Hyprland)
# ---------------------------------------------------------------------------

section("Default terminal → ghostty")

# Omarchy's Super+Return binding uses xdg-terminal-exec, which reads
# ~/.config/xdg-terminals.list to determine the preferred terminal.
xdg_terminals = Path.home() / ".config" / "xdg-terminals.list"
desktop_id = "com.mitchellh.ghostty.desktop"

current = xdg_terminals.read_text() if xdg_terminals.exists() else ""
first_entry = next(
    (line.strip() for line in current.splitlines() if line.strip() and not line.startswith("#")),
    None,
)

if first_entry == desktop_id:
    print(f"{desktop_id} is already the first entry in {xdg_terminals} — skipping.")
else:
    xdg_terminals.parent.mkdir(parents=True, exist_ok=True)
    xdg_terminals.write_text(
        "# Terminal emulator preference order for xdg-terminal-exec\n"
        "# The first found and valid terminal will be used\n"
        f"{desktop_id}\n"
    )
    print(f"Set {desktop_id} as default in {xdg_terminals}")


# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------

print("\n" + "═" * 60)
print("  Config complete.")
print("═" * 60)
