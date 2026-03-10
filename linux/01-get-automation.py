#!/usr/bin/env python3
"""
Linux setup script — equivalent to windows/01-setup.ps1.
Configures git, sets up SSH keys, and clones the automation repo.
"""

import os
import re
import shutil
import subprocess
import sys
from pathlib import Path


def run(cmd, **kwargs):
    """Run a shell command, raising on failure."""
    return subprocess.run(cmd, check=True, **kwargs)


def prompt(message):
    try:
        return input(message).strip()
    except KeyboardInterrupt:
        print("\nAborted.")
        sys.exit(1)


# ---------------------------------------------------------------------------
# 1. Sensemaking root
# ---------------------------------------------------------------------------

dir_name = prompt("\nPlease enter the directory name for the sensemaking root: ")
sm_root = Path.home() / dir_name
sm_root.mkdir(parents=True, exist_ok=True)
print(f"Root directory: {sm_root}")

# Export SM_ROOT for child processes and persist it to ~/.profile for future sessions.
os.environ["SM_ROOT"] = str(sm_root)
profile = Path.home() / ".profile"
profile_text = profile.read_text() if profile.exists() else ""
import re
if re.search(r"^\s*export\s+SM_ROOT=", profile_text, re.MULTILINE):
    updated = re.sub(r"^\s*export\s+SM_ROOT=.*$", f"export SM_ROOT={sm_root}", profile_text, flags=re.MULTILINE)
    if updated != profile_text:
        profile.write_text(updated)
        print(f"Updated SM_ROOT in {profile}")
    else:
        print(f"SM_ROOT already set correctly in {profile} — skipping.")
else:
    with profile.open("a") as f:
        f.write(f"\nexport SM_ROOT={sm_root}\n")
    print(f"Set SM_ROOT={sm_root} in {profile}")


# ---------------------------------------------------------------------------
# 2. SSH agent + key generation
# ---------------------------------------------------------------------------

user_email = prompt("Please enter your git email: ")

# Start ssh-agent and export its environment variables into this process.
agent_output = subprocess.check_output(["ssh-agent", "-s"], text=True)
for match in re.finditer(r"(\w+)=([^;]+);", agent_output):
    os.environ[match.group(1)] = match.group(2)

ssh_key = Path.home() / ".ssh" / "id_ed25519"
if not ssh_key.exists():
    run(["ssh-keygen", "-t", "ed25519", "-C", user_email, "-f", str(ssh_key)])
else:
    print(f"\nSSH key already exists at {ssh_key}, skipping generation.")

run(["ssh-add", str(ssh_key)])


# ---------------------------------------------------------------------------
# 5. Display / copy public key and wait for GitHub
# ---------------------------------------------------------------------------

pub_key = ssh_key.with_suffix(".pub").read_text().strip()

copied = False
if shutil.which("wl-copy"):
    subprocess.run(["wl-copy"], input=pub_key, text=True)
    copied = True
elif shutil.which("xclip"):
    subprocess.run(["xclip", "-selection", "clipboard"], input=pub_key, text=True)
    copied = True

if copied:
    print("\nYour public key has been copied to your clipboard.")
else:
    print("\nCould not find wl-copy or xclip. Here is your public key — copy it manually:")
    print(pub_key)

if shutil.which("xdg-open"):
    subprocess.Popen(["xdg-open", "https://github.com/settings/keys"])

prompt("\nPress Enter once you have added the key to GitHub...")


# ---------------------------------------------------------------------------
# 6. Clone automation repo
# ---------------------------------------------------------------------------

os.chdir(sm_root)
run(["git", "clone", "git@github.com:sensemaking/automation.git"])

print("\nInstalling defaults.")

# ---------------------------------------------------------------------------
# 7. Run 02-setup
# ---------------------------------------------------------------------------

setup_script = sm_root / "automation/linux/02-install.py"
run([sys.executable, str(setup_script)])
