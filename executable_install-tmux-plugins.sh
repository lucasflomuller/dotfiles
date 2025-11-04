#!/bin/bash
# Install TPM (Tmux Plugin Manager) and plugins

echo "🚀 Installing TPM and tmux plugins..."

# Install TPM if not already installed
if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "📦 Cloning TPM..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "✓ TPM installed"
else
    echo "✓ TPM already installed"
fi

# Check if fzf is installed (required for tmux-fzf)
if ! command -v fzf &> /dev/null; then
    echo "⚠️  fzf is not installed. Installing fzf..."
    if command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm fzf
    else
        echo "❌ Please install fzf manually for tmux-fzf to work"
    fi
else
    echo "✓ fzf is installed"
fi

echo ""
echo "✨ Installation complete!"
echo ""
echo "📋 Next steps:"
echo "1. Start tmux or reload config: tmux source ~/.tmux.conf"
echo "2. Inside tmux, press: prefix + I (capital i) to install plugins"
echo "3. Wait for plugins to install"
echo ""
echo "🎯 Plugin shortcuts:"
echo "  prefix + Ctrl-s     → Save session (resurrect)"
echo "  prefix + Ctrl-r     → Restore session (resurrect)"
echo "  prefix + F          → Open fuzzy finder (fzf)"
echo "  prefix + I          → Install plugins (tpm)"
echo "  prefix + U          → Update plugins (tpm)"
echo "  prefix + alt-u      → Uninstall plugins (tpm)"
echo ""
echo "  Copy mode (prefix + [):"
echo "    y                 → Copy to system clipboard (yank)"
echo "    Y                 → Copy and paste to command line (yank)"
echo ""
echo "  Open (in copy mode or normal):"
echo "    o                 → Open highlighted file/URL (open)"
echo "    Ctrl-o            → Open in editor (open)"
echo ""
echo "💾 Auto-save is enabled every 15 minutes"
echo "🔄 Auto-restore is enabled on tmux start"
