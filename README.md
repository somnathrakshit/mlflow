# MLflow Beginner to Advanced Mastery Book

This repository contains a comprehensive Jupyter Book tutorial for MLflow, covering everything from basic experiment tracking to advanced LLMOps and model serving.

## 🚀 Features
- **14 Detailed Lessons**: Progressive curriculum from Foundations to Mastery.
- **Modern Tech Stack**: Managed with `uv` for speed and reproducibility.
- **Interactive**: Integrated Google Colab buttons for all notebooks.
- **Production Ready**: Includes `systemd` configuration for Linux deployment.

## 🛠️ Local Development

1. **Install uv**:
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```
2. **Setup environment**:
   ```bash
   uv sync
   ```
3. **Build the book**:
   ```bash
   uv run jupyter-book build --html
   ```
4. **Start local preview**:
   ```bash
   uv run jupyter-book start
   ```

## 🌐 Linux Deployment (Low Resource)

This setup is optimized for servers with limited RAM/CPU. We build the site locally on your Windows machine and serve the static HTML on the server.

1. **Build locally (on your PC)**:
   ```bash
   uv run jupyter-book build --html
   ```

2. **Push to Server**:
   Ensure `_build/html` is committed and pushed to your repository (the `.gitignore` has been updated to allow this).

3. **Run the deployment script (on server)**:
   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```

4. **Access your services**:
   - **MLflow Tracking**: Port `5000`
   - **Tutorial Book**: Port `8080` (Static server)

## 📊 Management
```bash
# Check status of both services
sudo systemctl status mlflow-server
sudo systemctl status mlflow-docs

# View logs
journalctl -u mlflow-server -f
journalctl -u mlflow-docs -f
```

## 📚 Sitemap
- **Phase 1: Foundations**: Setup, Tracking, UI, Projects.
- **Phase 2: Intermediate**: Models, Registry, Recipes.
- **Phase 3: Advanced**: Serving, LLMOps, Orchestration.
- **Phase 4: Mastery**: Cloud, Lineage, Monitoring.

## ☁️ Exposing via Cloudflare Tunnels

If you already have `cloudflared` set up on your server, you can expose the MLflow tracking server (port 5000) securely without opening firewall ports.

1. **Route the DNS**:
   ```bash
   # Replace <NAME> with your tunnel name and <HOSTNAME> with your desired subdomain
   cloudflared tunnel route dns <NAME> mlflow.yourdomain.com
   ```

2. **Add to Ingress Config**:
   Edit `/etc/cloudflared/config.yml` and add the MLflow service:
   ```yaml
   ingress:
     - hostname: mlflow.yourdomain.com
       service: http://localhost:5000
     # Ensure your existing services and the default 404 rule remain below
     - service: http_status:404
   ```

3. **Restart Cloudflared**:
   ```bash
   sudo cloudflared service uninstall
   sudo cloudflared service install
   sudo systemctl restart cloudflared
   ```

---
*Built with ❤️ using [Jupyter Book](https://jupyterbook.org)*
