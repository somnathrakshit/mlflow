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

## 🌐 Linux Deployment

To deploy this tutorial and the MLflow Tracking Server to a fresh Linux server:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/user/mlflow-tutorial.git
   cd mlflow-tutorial
   ```
2. **Run the deployment script**:
   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```
   *Note: The script will install `uv`, sync dependencies, and setup a `systemd` service via a symlink.*

3. **Manage the service**:
   ```bash
   # Check status
   sudo systemctl status mlflow-server
   
   # View logs
   journalctl -u mlflow-server -f
   ```

## 📚 Sitemap
- **Phase 1: Foundations**: Setup, Tracking, UI, Projects.
- **Phase 2: Intermediate**: Models, Registry, Recipes.
- **Phase 3: Advanced**: Serving, LLMOps, Orchestration.
- **Phase 4: Mastery**: Cloud, Lineage, Monitoring.

---
*Built with ❤️ using [Jupyter Book](https://jupyterbook.org)*
