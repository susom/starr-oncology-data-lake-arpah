# Security Policy

## Supported Versions

| Version | Supported          |
|---------|--------------------|
| latest  | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it responsibly.

**Do not open a public GitHub issue for security vulnerabilities.**

Instead, please send an email to the project maintainers with:

- A description of the vulnerability
- Steps to reproduce the issue
- Any potential impact

We will acknowledge receipt within 72 hours and provide an estimated timeline for a fix.

## Security Practices

- This project does not store or process credentials in the repository.
- All dependencies are tracked in `pyproject.toml` and `install.R`.
- PHI and sensitive data are never committed to version control.
- The `.gitignore` file is configured to prevent accidental commits of sensitive files.
