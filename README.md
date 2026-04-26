# MLflow Beginner to Advanced Mastery Book

This repository contains a comprehensive Jupyter Book tutorial for MLflow, covering everything from basic experiment tracking to advanced LLMOps and model serving.

## 🚀 Features
- **14 Detailed Lessons**: Progressive curriculum from Foundations to Mastery.
- **Modern Tech Stack**: Blazing fast dependency management with `uv`.
- **Interactive**: Integrated Google Colab buttons for all notebooks.
- **Production Ready**: Includes `systemd` configuration for Linux deployment.

## 🛠️ Local Development

1. **Clone the repository**:
   ```bash
   git clone <repo-url>
   cd mlflow
   ```
2. **Setup environment**:
   ```bash
   # Install dependencies and setup virtualenv
   uv sync
   ```
3. **Build the book**:
   ```bash
   uv run jupyter book build --html
   ```
4. **Start local preview**:
   ```bash
   # Open _build/html/index.html in your browser
   ```

## 📚 Sitemap
- **Phase 1: Foundations**: Setup, Tracking, UI, Projects.
- **Phase 2: Intermediate**: Models, Registry, Recipes.
- **Phase 3: Advanced**: Serving, LLMOps, Orchestration.
- **Phase 4: Mastery**: Cloud, Lineage, Monitoring.

*Built with ❤️ using [Jupyter Book](https://jupyterbook.org)*
