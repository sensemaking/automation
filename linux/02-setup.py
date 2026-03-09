#!/usr/bin/env python3
"""
Linux setup script — installs applications to taste.

Tools installed:
  - yay (AUR helper, bootstrapped from pacman)
  - Ghostty
  - Zsh + oh-my-zsh, default shell changed to zsh
  - Zoom
  - Slack
  - Docker (with systemd service + docker group)
  - Lazydocker
  - Neovim + LazyVim
  - GitHub CLI
  - Zen Browser
  - VS Code

All installs are non-interactive; already-installed tools are skipped.
"""

import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def run(cmd, **kwargs):
    """Run a shell command, raising on failure."""
    return subprocess.run(cmd, check=True, **kwargs)


def yay_install(*packages):
    """Install one or more packages via yay, non-interactively."""
    run(["yay", "-S", "--noconfirm", "--needed", *packages])


def is_cmd(name):
    """Return True if *name* is found on PATH."""
    return shutil.which(name) is not None


def section(title):
    print(f"\n{'─' * 60}")
    print(f"  {title}")
    print('─' * 60, flush=True)


# ---------------------------------------------------------------------------
# yay
# ---------------------------------------------------------------------------

section("yay (AUR helper)")
if is_cmd("yay"):
    print("yay already installed — skipping.")
else:
    print("Installing yay…")
    run(["sudo", "pacman", "-S", "--needed", "--noconfirm", "base-devel", "git"])
    with tempfile.TemporaryDirectory() as tmpdir:
        run(["git", "clone", "https://aur.archlinux.org/yay.git", tmpdir + "/yay"])
        run(["makepkg", "-si", "--noconfirm"], cwd=tmpdir + "/yay")
    print("yay installed.")


# ---------------------------------------------------------------------------
# Ghostty
# ---------------------------------------------------------------------------

section("Ghostty")
if is_cmd("ghostty"):
    print("ghostty already installed — skipping.")
else:
    print("Installing ghostty…")
    yay_install("ghostty")


# ---------------------------------------------------------------------------
# Zsh + oh-my-zsh + default shell
# ---------------------------------------------------------------------------

section("Zsh")
if is_cmd("zsh"):
    print("zsh already installed — skipping package install.")
else:
    print("Installing zsh…")
    yay_install("zsh")

section("oh-my-zsh")
omz_dir = Path.home() / ".oh-my-zsh"
if omz_dir.exists():
    print("oh-my-zsh already installed — skipping.")
else:
    print("Installing oh-my-zsh…")
    install_script = subprocess.check_output(
        ["curl", "-fsSL", "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"],
        text=True,
    )
    run(
        ["sh"],
        input=install_script,
        text=True,
        env={**os.environ, "RUNZSH": "no", "CHSH": "no"},
    )

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
# Zoom
# ---------------------------------------------------------------------------

section("Zoom")
if is_cmd("zoom"):
    print("zoom already installed — skipping.")
else:
    print("Installing zoom…")
    yay_install("zoom")


# ---------------------------------------------------------------------------
# Slack
# ---------------------------------------------------------------------------

section("Slack")
if is_cmd("slack"):
    print("slack already installed — skipping.")
else:
    print("Installing slack…")
    yay_install("slack-desktop")


# ---------------------------------------------------------------------------
# Docker
# ---------------------------------------------------------------------------

section("Docker")
if is_cmd("docker"):
    print("docker already installed — skipping package install.")
else:
    print("Installing docker…")
    yay_install("docker")

# Enable and start the Docker service.
docker_active = subprocess.run(
    ["systemctl", "is-active", "--quiet", "docker"],
    check=False,
).returncode == 0

if docker_active:
    print("docker.service already active — skipping.")
else:
    print("Enabling and starting docker.service…")
    run(["sudo", "systemctl", "enable", "--now", "docker"])

# Add current user to the docker group.
current_user = os.environ.get("USER") or os.environ.get("LOGNAME") or ""
if current_user:
    groups_output = subprocess.check_output(["groups", current_user], text=True)
    if "docker" in groups_output.split():
        print(f"{current_user} already in docker group — skipping.")
    else:
        print(f"Adding {current_user} to docker group…")
        run(["sudo", "usermod", "-aG", "docker", current_user])
        print("NOTE: Log out and back in (or run `newgrp docker`) for the group change to take effect.")


section("Lazydocker")
if is_cmd("lazydocker"):
    print("lazydocker already installed — skipping.")
else:
    print("Installing lazydocker…")
    yay_install("lazydocker")


# ---------------------------------------------------------------------------
# Neovim + LazyVim
# ---------------------------------------------------------------------------

section("Neovim")
if is_cmd("nvim"):
    print("neovim already installed — skipping.")
else:
    print("Installing neovim…")
    yay_install("neovim")

section("LazyVim starter config")
nvim_config = Path.home() / ".config" / "nvim"
if nvim_config.exists():
    print(f"{nvim_config} already exists — skipping LazyVim setup.")
else:
    print("Cloning LazyVim starter config…")
    run(["git", "clone", "https://github.com/LazyVim/starter", str(nvim_config)])
    # Remove the .git dir so the config can be managed independently.
    run(["rm", "-rf", str(nvim_config / ".git")])


# ---------------------------------------------------------------------------
# GitHub CLI
# ---------------------------------------------------------------------------

section("GitHub CLI")
if is_cmd("gh"):
    print("gh already installed — skipping.")
else:
    print("Installing github-cli…")
    yay_install("github-cli")


# ---------------------------------------------------------------------------
# Zen Browser
# ---------------------------------------------------------------------------

section("Zen Browser")
if is_cmd("zen-browser") or is_cmd("zen"):
    print("zen-browser already installed — skipping.")
else:
    print("Installing zen-browser…")
    yay_install("zen-browser-bin")


# ---------------------------------------------------------------------------
# VS Code
# ---------------------------------------------------------------------------

section("VS Code")
if is_cmd("code"):
    print("VS Code already installed — skipping.")
else:
    print("Installing VS Code…")
    yay_install("visual-studio-code-bin")


# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------

print("\n" + "═" * 60)
print("  Setup complete.")
print("═" * 60)
