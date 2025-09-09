#!/usr/bin/env bash
set -euo pipefail

# Map Caps Lock to Escape via hidutil (works on Apple Silicon & Intel)
/usr/bin/hidutil property --set '{
  "UserKeyMapping": [
    { "HIDKeyboardModifierMappingSrc": 0x700000039, "HIDKeyboardModifierMappingDst": 0x700000029 }
  ]
}' >/dev/null
echo "Set Caps Lock -> Escape (current session). To persist across reboots, consider adding this to a LaunchAgent."
