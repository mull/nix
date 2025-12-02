#!/usr/bin/env bash

SAFE_FILE="$HOME/nix/config/safe-wifi-ssids.txt"

SAFE_SSIDS=()
if [[ -r "$SAFE_FILE" ]]; then
  while IFS= read -r ssid; do
    [[ -z "$ssid" || "$ssid" =~ ^# ]] && continue
    SAFE_SSIDS+=("$ssid")
  done < "$SAFE_FILE"
else
  echo "[conditional-swaylock] WARNING: safe SSID file not found: $SAFE_FILE" >&2
fi

# Get current Wi-Fi SSID (first active=yes line)
current_ssid="$(
  LANG=C nmcli -t -f active,ssid dev wifi 2>/dev/null \
    | grep '^yes:' \
    | cut -d: -f2-
)"

echo "[conditional-swaylock] Current SSID: ${current_ssid:-<none>}" >&2
echo "[conditional-swaylock] Safe SSIDs: ${SAFE_SSIDS[*]:-<none>}" >&2

# If we're on a "safe" Wi-Fi, do nothing
for ssid in "${SAFE_SSIDS[@]}"; do
  if [[ "$current_ssid" == "$ssid" ]]; then
    echo "[conditional-swaylock] '$current_ssid' is safe, not locking" >&2
    exit 0
  fi
done

echo "[conditional-swaylock] '$current_ssid' not safe, locking" >&2
exec swaylock -efF
