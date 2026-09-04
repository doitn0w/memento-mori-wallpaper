#!/bin/bash
# Remove the memento mori wallpaper: timer, hook, scripts, config, state.
set -euo pipefail

echo "Stopping and disabling the weekly timer..."
systemctl --user disable --now memento-mori-wallpaper.timer 2>/dev/null || true
rm -f "$HOME/.config/systemd/user/memento-mori-wallpaper.timer" "$HOME/.config/systemd/user/memento-mori-wallpaper.service"
systemctl --user daemon-reload

echo "Removing the theme-change hook..."
rm -f "$HOME/.config/omarchy/hooks/theme-set.d/theme-set-memento-mori"

echo "Removing scripts and config..."
rm -f "$HOME/.local/bin/memento-mori-wallpaper" "$HOME/.local/bin/memento-mori-settings"
rm -rf "$HOME/.config/memento-mori" "$HOME/.local/state/memento-mori"

echo "Done. Run 'omarchy theme bg switcher' to pick a new background."
