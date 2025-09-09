#!/usr/bin/env bash
set -euo pipefail
if command -v gsettings >/dev/null 2>&1; then
  CURRENT=$(gsettings get org.gnome.desktop.input-sources xkb-options)
  # set to caps:escape (overwrites existing xkb-options for simplicity)
  gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"
  echo "Set Caps Lock -> Escape (GNOME). Previous was: $CURRENT"
else
  echo "gsettings not found; skipping Caps->Esc"
fi
