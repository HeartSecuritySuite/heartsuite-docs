# Contributing to HeartSuite Documentation

Welcome! HeartSuite Core Secure is an enterprise-grade security suite built on a hardened Linux kernel. We greatly appreciate your help in improving our documentation. This guide explains how to contribute effectively to the HeartSuite docs.

## Ways to Contribute

- **Report issues**: Found a bug, outdated info, or confusing section? [Open an issue](https://github.com/HeartSecuritySuite/heartsuite-docs/issues).
- **Suggest improvements**: Ideas for new topics or better organization? Start a discussion.
- **Write content**: Add tutorials, guides, or clarify existing docs.
- **Review PRs**: Help maintain quality by reviewing others' contributions.
- **Translate**: Help make docs accessible in multiple languages.

## Getting Started

### Prerequisites
- Basic knowledge of Markdown and static site generators.
- Familiarity with HeartSuite Core Secure (see [core repo](https://github.com/HeartSecuritySuite/heartsuite-core-secure)).
- Git and GitHub account.

### Local Setup
1. **Clone the repo**:
   ```
   git clone https://github.com/HeartSecuritySuite/heartsuite-docs.git
   cd heartsuite-docs
   ```
2. **Install dependencies**:
   - Go 1.22+, Node.js 22+, Hugo 0.155+ (extended)
   - Run: `npm install`
3. **Preview locally**:
   - `npm run serve` — open http://localhost:1313

## Writing Guidelines

### Content Standards
- **Audience**: Technical users (admins, developers, security teams).
- **Tone**: Professional, clear, concise. Avoid jargon; explain when necessary.
- **Accuracy**: Base content on facts from code, testing, or official sources. Cite sources.
- **Structure**: Use H1/H2/H3, shortcodes (alerts, code blocks), cross-references.
- **Inclusivity**: Use gender-neutral language; avoid cultural biases.
- **Updates**: Check for outdated info during edits.

### Markdown Rules
- Use Hugo/Docsy syntax (tables, links, images).
- Frontmatter: `title`, `description`, `weight` (for ordering).
- Code blocks with syntax highlighting: ```bash, ```yaml, etc.
- Images: Store in page folder, use relative paths.
- Links: Use relative paths for internal docs.

### File Organization
- `content/en/` — all content goes here.
- Organize by topic: installation, whitelisting, maintenance, etc.
- Use index.md for section overviews.
- Follow existing naming: kebab-case, e.g., `vm-preparation.md`.

## Submission Process

### For Small Changes
1. Edit directly on GitHub (web editor) or locally.
2. Commit with clear message: "Clarify whitelisting basics".
3. Push/PR: Create PR to `main` for review.

### For Larger Changes
1. Create branch: `git checkout -b feature/new-tutorial`.
2. Make edits, preview locally.
3. Commit regularly with descriptive messages.
4. Push branch and create PR.
5. In PR description: Explain changes, why needed, screenshots if UI.

### Pull Request Guidelines
- **Title**: "Add guide: Securing VMs with HeartSuite".
- **Description**: Problem solved, approach, testing done.
- **Labels**: Use appropriate (bug, enhancement, documentation).
- **Drafts**: Mark as draft if work-in-progress.
- **Size**: Prefer focused PRs; split large ones.

## Review Process

### Reviewers
- Maintainers or docs team review within 3-5 business days.
- Feedback focuses on: clarity, accuracy, completeness, style.
- Revisions may be requested; iterate until approved.

### Merge Standards
- At least 1 approval required.
- CI checks must pass (build, links).
- Squash commits on merge.
- Release: Docs deploy automatically to GitHub Pages.

### Handling Feedback
- Be open to suggestions; docs improve collaboratively.
- Explain reasoning if disagreeing.
- Keep discussions respectful and on-topic.

## Code of Conduct

- Respect all contributors regardless of background, identity, or experience.
- Focus on constructive feedback.
- Harassment or inappropriate behavior will result in removal.
- See [Docsy conduct](https://www.docsy.dev/docs/community/contribute/code-of-conduct/) for full policy.

## Resources

- **Core Repo**: [heartsuite-core-secure](https://github.com/HeartSecuritySuite/heartsuite-core-secure)
- **Live Docs**: [docs.heartsecsuite.com](https://HeartSecuritySuite.github.io/heartsuite-docs/)
- **Hugo Docs**: [Hugo docs](https://gohugo.io/documentation/)
- **Docsy Guide**: [Docsy user guide](https://www.docsy.dev/docs/)
- **Questions?** Open an issue or email maintainers.

Thank you for helping make HeartSuite docs better! Every contribution matters. 🚀

© HeartSecuritySuite Authors. Licensed under Apache License 2.0.