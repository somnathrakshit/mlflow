#!/bin/bash

# Deployment script for MLflow Jupyter Book Server
# Assuming a fresh Linux (Ubuntu/Debian) install

set -e

PROJECT_DIR=$(pwd)
SERVICE_NAME="mlflow-server.service"

echo "🚀 Starting deployment of MLflow Server..."

# 1. Update system and install dependencies
echo "📦 Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y curl git python3-pip

# 2. Install uv (if not already installed)
if ! command -v uv &> /dev/null; then
    echo "✨ Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    # Add uv to PATH for the current script execution
    export PATH="$HOME/.local/bin:$PATH"
    # Persist to bashrc for future sessions
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    fi
fi

# 3. Setup project environment
echo "🛠️ Syncing project environment..."
uv sync

# 4. Update service file with correct uv path and user
UV_PATH=$(command -v uv)
CURRENT_USER=$(whoami)
echo "🔧 Configuring service for user $CURRENT_USER with uv at $UV_PATH..."
sed -i "s|User=ubuntu|User=$CURRENT_USER|g" "$SERVICE_NAME"
sed -i "s|Group=ubuntu|Group=$CURRENT_USER|g" "$SERVICE_NAME"
sed -i "s|WorkingDirectory=/home/ubuntu/mlflow-tutorial|WorkingDirectory=$PROJECT_DIR|g" "$SERVICE_NAME"
sed -i "s|ExecStart=/usr/local/bin/uv|ExecStart=$UV_PATH|g" "$SERVICE_NAME"

# 5. Create Symlink for systemd service
echo "🔗 Symlinking service file..."
sudo ln -sf "$PROJECT_DIR/$SERVICE_NAME" "/etc/systemd/system/$SERVICE_NAME"

# 5. Reload systemd and start service
echo "⚙️ Reloading systemd and starting service..."
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME
sudo systemctl restart $SERVICE_NAME

echo "✅ Deployment complete!"
echo "📍 MLflow is running at: http://$(hostname -I | awk '{print $1}'):5000"
echo "📖 You can check logs with: journalctl -u $SERVICE_NAME -f"
