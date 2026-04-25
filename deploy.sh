#!/bin/bash

# Deployment script for Static Docs
# Optimized for low-resource Linux servers serving static HTML

set -e

PROJECT_DIR=$(pwd)
DOCS_SERVICE="mlflow-docs.service"

echo "🚀 Starting deployment..."

# 0. Cleanup: Stop and disable the old tracking server if it exists
echo "🧹 Cleaning up old tracking server service..."
sudo systemctl stop mlflow-server.service || true
sudo systemctl disable mlflow-server.service || true

# 1. Update system and install dependencies
echo "📦 Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y curl git nano byobu htop zip unzip nodejs npm

# 2. Install uv (if not already installed)
if ! command -v uv &> /dev/null; then
    echo "✨ Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    fi
fi

# 3. Build Static Documentation
echo "🏗️ Building HTML from Jupyter Book..."
uv sync
uv run jupyter-book build --html

# 4. Configure Services dynamically
CURRENT_USER=$(whoami)

echo "🔧 Configuring services for user $CURRENT_USER..."
# Update Static Docs Service
sed -i "s|User=ubuntu|User=$CURRENT_USER|g" "$DOCS_SERVICE"
sed -i "s|Group=ubuntu|Group=$CURRENT_USER|g" "$DOCS_SERVICE"
sed -i "s|WorkingDirectory=/home/ubuntu/mlflow-tutorial/_build/html|WorkingDirectory=$PROJECT_DIR/_build/html|g" "$DOCS_SERVICE"

# 5. Create Symlinks
echo "🔗 Symlinking services..."
sudo ln -sf "$PROJECT_DIR/$DOCS_SERVICE" "/etc/systemd/system/$DOCS_SERVICE"

# 6. Reload systemd and start
echo "⚙️ Starting services..."
sudo systemctl daemon-reload
sudo systemctl enable $DOCS_SERVICE
sudo systemctl restart $DOCS_SERVICE

echo "✅ Deployment complete!"
echo "📖 Static Tutorial: http://$(hostname -I | awk '{print $1}'):8080"
