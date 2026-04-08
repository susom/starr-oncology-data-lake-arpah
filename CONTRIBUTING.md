# Contributing to STARR-ONCOLOGY Data Lake ARPA-H

Thank you for your interest in contributing to this project.

## Getting Started

1. Fork the repository and clone your fork locally.
2. Open the project in VS Code and reopen in the devcontainer (see [README.md](README.md)).
3. Create a new branch for your changes:
   ```sh
   git checkout -b feature/your-feature-name
   ```

## Development Environment

This project uses a devcontainer with:
- **R 4.4** (primary language, via `rocker/rstudio` base image)
- **Python >= 3.12** (for data processing utilities)
- **Quarto** (for rendering `.qmd` documents)

See the [README.md](README.md) for detailed setup instructions.

## Making Changes

1. Make your changes in a feature branch.
2. Ensure any new `.qmd` files render correctly with Quarto.
3. Follow existing code style and conventions.
4. Commit with clear, descriptive messages.

## Submitting a Pull Request

1. Push your branch to your fork.
2. Open a Pull Request against the `main` branch.
3. Fill out the pull request template.
4. Wait for review — all PRs require at least one approval before merging.

## Reporting Issues

- Use GitHub Issues to report bugs or request features.
- Include steps to reproduce for bug reports.
- Check existing issues before creating a new one.

## Code of Conduct

Be respectful and constructive in all interactions. We are committed to providing a welcoming and inclusive experience for everyone.
