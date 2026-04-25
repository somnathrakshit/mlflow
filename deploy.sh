#!/bin/bash

# Deployment script for MLflow Tracking Server and Static Docs
# Optimized for low-resource Linux servers (serving static HTML)

set -e

PROJECT_DIR=$(pwd)
SERVER_SERVICE="mlflow-server.service"
DOCS_SERVICE="mlflow-docs.service"

echo "🚀 Starting deployment..."

# 1. Update system and install dependencies
echo "📦 Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y curl git python3-pip

# 2. Install uv (if not already installed)
if ! command -v uv &> /dev/null; then
    echo "✨ Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    fi
fi

# 3. Setup project environment (for MLflow Tracking)
echo "🛠️ Syncing project environment..."
uv sync

# 4. Configure Services dynamically
UV_PATH=$(command -v uv)
CURRENT_USER=$(whoami)

echo "🔧 Configuring services for user $CURRENT_USER..."

# Update Tracking Server Service
sed -i "s|User=ubuntu|User=$CURRENT_USER|g" "$SERVER_SERVICE"
sed -i "s|Group=ubuntu|Group=$CURRENT_USER|g" "$SERVER_SERVICE"
sed -i "s|WorkingDirectory=/home/ubuntu/mlflow-tutorial|WorkingDirectory=$PROJECT_DIR|g" "$SERVER_SERVICE"
sed -i "s|ExecStart=/usr/local/bin/uv|ExecStart=$UV_PATH|g" "$SERVER_SERVICE"

# Update Static Docs Service
sed -i "s|User=ubuntu|User=$CURRENT_USER|g" "$DOCS_SERVICE"
sed -i "s|Group=ubuntu|Group=$CURRENT_USER|g" "$DOCS_SERVICE"
sed -i "s|WorkingDirectory=/home/ubuntu/mlflow-tutorial/_build/html|WorkingDirectory=$PROJECT_DIR/_build/html|g" "$DOCS_SERVICE"

# 5. Create Symlinks
echo "🔗 Symlinking services..."
sudo ln -sf "$PROJECT_DIR/$SERVER_SERVICE" "/etc/systemd/system/$SERVER_SERVICE"
sudo ln -sf "$PROJECT_DIR/$DOCS_SERVICE" "/etc/systemd/system/$DOCS_SERVICE"

# 6. Reload systemd and start
echo "⚙️ Starting services..."
sudo systemctl daemon-reload
sudo systemctl enable $SERVER_SERVICE $DOCS_SERVICE
sudo systemctl restart $SERVER_SERVICE $DOCS_SERVICE

echo "✅ Deployment complete!"
echo "📍 MLflow Tracking: http://$(hostname -I | awk '{print $1}'):5000"
echo "📖 Static Tutorial: http://$(hostname -I | awk '{print $1}'):8080"
