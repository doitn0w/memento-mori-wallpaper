#!/bin/bash
# Install the memento mori wallpaper for Omarchy/Hyprland.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/memento-mori"
SYSTEMD_DIR="$HOME/.config/systemd/user"

for dep in rsvg-convert gum hyprctl python3; do
  command -v "$dep" >/dev/null 2>&1 || { echo "Missing dependency: $dep" >&2; exit 1; }
done
command -v omarchy-theme-bg-set >/dev/null 2>&1 || {
  echo "omarchy-theme-bg-set not found — this tool is built for Omarchy." >&2
  exit 1
}

echo "Installing scripts to $BIN_DIR..."
mkdir -p "$BIN_DIR"
install -m 755 "$SCRIPT_DIR/bin/memento-mori-wallpaper" "$BIN_DIR/"
install -m 755 "$SCRIPT_DIR/bin/memento-mori-settings" "$BIN_DIR/"

echo "Setting up config in $CONFIG_DIR..."
mkdir -p "$CONFIG_DIR"
if [[ -f "$CONFIG_DIR/config.toml" ]]; then
  echo "Config already exists, leaving it untouched."
else
  cp "$SCRIPT_DIR/config/config.toml.example" "$CONFIG_DIR/config.toml"
  echo "Wrote default config — edit it now or run 'memento-mori-settings' later:"
  echo "  $CONFIG_DIR/config.toml"
fi

echo "Installing systemd timer..."
mkdir -p "$SYSTEMD_DIR"
install -m 644 "$SCRIPT_DIR/systemd/memento-mori-wallpaper.service" "$SYSTEMD_DIR/"
install -m 644 "$SCRIPT_DIR/systemd/memento-mori-wallpaper.timer" "$SYSTEMD_DIR/"
systemctl --user daemon-reload
systemctl --user enable --now memento-mori-wallpaper.timer

echo "Installing theme-change hook..."
omarchy hook install theme-set "$SCRIPT_DIR/hooks/theme-set-memento-mori"

echo
echo "Done. Edit your birth date / life expectancy with: memento-mori-settings"
echo "Generating your first wallpaper now..."
"$BIN_DIR/memento-mori-wallpaper"
