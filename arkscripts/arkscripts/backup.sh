#!/bin/bash

# Arkscripts - https://github.com/arkboix/dotfiles

BACKUP_DIR="$HOME/backups/backup_$(date +%Y-%m-%d_%H-%M-%S)"
CONFIG_DIR="$BACKUP_DIR/config"

echo "📁 Creating timestamped backup: $BACKUP_DIR"
mkdir -p "$CONFIG_DIR"

echo "📦 Copying dotfiles..."
cp -r "$HOME/dotfiles/"* "$BACKUP_DIR/" 2>/dev/null || echo "⚠️ No dotfiles to copy."

echo "📦 Copying .config..."
cp -r "$HOME/.config/"* "$CONFIG_DIR/" 2>/dev/null || echo "⚠️ No .config files to copy."

echo "🗜️ Compressing backup..."
tar -czf "$BACKUP_DIR.tar.gz" -C "$HOME/backups" "$(basename "$BACKUP_DIR")"

echo "✅ Backup completed! Archive saved as $BACKUP_DIR.tar.gz"
notify-send "Backup" "saved as $BACKUP_DIR.tar.gz"
