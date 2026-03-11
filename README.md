# HeartSuite Documentation

Welcome to the official documentation for **HeartSuite Core Secure** — the enterprise-grade security suite built on a hardened Linux kernel.

Built with [Hugo](https://gohugo.io/) and the [Docsy](https://www.docsy.dev/) theme.

## Live Site
[docs.heartsuite.com](https://HeartSecuritySuite.github.io/heartsuite-docs/)

## Quick Start
1. **Clone the Repo**:
   ```
   git clone https://github.com/HeartSecuritySuite/heartsuite-docs.git
   cd heartsuite-docs
   ```
2. **Install Dependencies** (Go 1.22+, Node 22+, Hugo 0.155+ extended):
   ```
   npm install
   ```
3. **Serve Locally**:
   ```
   npm run serve
   ```
   Open [http://localhost:1313](http://localhost:1313).

## Repository Structure
```
content/en/           # Markdown source (edit here)
assets/               # Custom CSS/images
config/               # Hugo/Docsy config
layouts/              # Custom page layouts (optional)
themes/               # Hugo themes (managed by Hugo modules)
.github/workflows/    # GitHub Actions for deployment
```
- Content lives in `content/en/` — organized by topic (introduction, installation, whitelisting, troubleshooting).
- Changes auto-deploy via GitHub Actions on push to `main`.

## Contributing
1. **Fork** this repo.
2. **Branch** from `main`: `git checkout -b feature/your-doc-updates`.
3. **Edit** Markdown files in `content/en/`.
4. **Preview** locally (`npm run serve`).
5. **Commit & Push**: Clear messages, e.g., "Add VM preparation instructions".
6. **PR** to `main` for review.

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Deployment
- **Automated**: Pushes to `main` trigger GitHub Actions to build and deploy to GitHub Pages.
- **Source**: [heartsuite-core-secure](https://github.com/HeartSecuritySuite/heartsuite-core-secure) (kernel & tools repo).
- **Issues**: [heartsuite-docs issues](https://github.com/HeartSecuritySuite/heartsuite-docs/issues).

## License
Apache License 2.0 — see [LICENSE](LICENSE).

© HeartSecuritySuite Authors.
