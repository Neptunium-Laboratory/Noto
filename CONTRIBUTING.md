# Contributing to Noto

Thank you for your interest in contributing to Noto. Contributions from developers, designers, writers, testers, and users help make the project more reliable, accessible, and useful.

This guide explains how to prepare a development environment, choose work, make changes, validate them, and submit a contribution for review. Please read it before opening an issue or pull request.

## Code of Conduct

All contributors are expected to communicate respectfully and constructively. We welcome people of different backgrounds, experience levels, and perspectives. Harassment, discrimination, personal attacks, and deliberately disruptive behavior are not acceptable.

If a disagreement occurs, focus discussion on the code, documentation, user experience, or project requirements rather than on individuals. Maintainers may close discussions or remove contributions that do not meet these expectations.

## Ways to Contribute

There are several valuable ways to support Noto:

| Contribution | Examples |
| --- | --- |
| Bug reports | Describe reproducible crashes, incorrect behavior, or regressions. |
| Feature proposals | Explain a user problem and suggest a focused solution. |
| Code contributions | Fix bugs, improve performance, add tests, or implement approved features. |
| Design contributions | Improve usability, accessibility, layout, icons, or visual consistency. |
| Documentation | Improve setup instructions, examples, terminology, and troubleshooting guidance. |
| Testing | Verify changes on supported platforms and report clear results. |
| Community support | Help answer questions and reproduce reported issues. |

Before beginning substantial work, open an issue or comment on an existing one. This helps prevent duplicate efforts and gives maintainers an opportunity to confirm the direction.

## Before You Start

Please review the project [README](README.md), search existing issues and pull requests, and check whether the work is already in progress. For large changes, wait for maintainer feedback before investing significant development time.

A contribution should have a clear purpose and a reasonable scope. Small, focused pull requests are easier to review, test, and merge than large changes that combine unrelated fixes.

## Development Requirements

Noto is built with Dart and Flutter. Install the Flutter SDK and configure the tools required for your target platform before starting development.

The following commands should succeed in a correctly configured environment:

```bash
flutter doctor
flutter --version
```

You should also have Git installed and access to a code editor that supports Dart and Flutter development.

## Set Up the Repository

Fork the repository on GitHub, then clone your fork locally:

```bash
git clone https://github.com/your-username/noto.git
cd noto
```

Add the upstream repository so that you can keep your local copy synchronized:

```bash
git remote add upstream https://github.com/noto-project/noto.git
git remote -v
```

Install project dependencies and verify the initial state:

```bash
flutter pub get
flutter analyze
flutter test
```

Replace the example repository URLs with the official repository URLs when the project is published.

## Create a Branch

Do not develop directly on the `main` branch. Create a focused branch from the latest upstream version:

```bash
git switch main
git fetch upstream
git pull --ff-only upstream main
git switch -c fix/short-description
```

Use a descriptive branch name that communicates the purpose of the work:

| Branch prefix | Appropriate use |
| --- | --- |
| `feature/` | A new user facing capability |
| `fix/` | A bug fix or regression correction |
| `docs/` | Documentation changes |
| `test/` | Test additions or test maintenance |
| `refactor/` | Internal restructuring without intended behavior changes |
| `chore/` | Maintenance, tooling, or dependency work |

Do not include spaces in branch names. Keep names short, specific, and easy to recognize.

## Development Workflow

A typical contribution follows this sequence:

1. Identify or discuss the issue.

1. Create a branch from the latest `main` branch.

1. Make the smallest complete change that solves the problem.

1. Add or update tests where behavior changes.

1. Update documentation when users or contributors need new information.

1. Format the code and run the project checks.

1. Commit the change with a clear message.

1. Push the branch and open a pull request.

1. Respond to review feedback and keep the branch updated if necessary.

Avoid unrelated formatting changes, opportunistic refactors, and changes to generated files unless they are required for the contribution.

## Dart and Flutter Standards

Write code that is readable, maintainable, and consistent with the existing project style. Prefer clear names and straightforward control flow over clever abstractions. Keep widgets and methods focused, and avoid introducing dependencies for small problems that can be solved with existing project capabilities.

When adding a new dependency, explain why it is needed and consider its maintenance, licensing, size, platform support, and security implications. Keep dependency changes isolated from unrelated feature work.

Use the project formatter rather than manually formatting Dart files:

```bash
dart format .
```

Run static analysis before submitting a pull request:

```bash
flutter analyze
```

If the project contains lint configuration, follow it as the source of truth. Do not suppress a warning without documenting why the suppression is necessary.

## Testing Expectations

Every behavior change should include appropriate validation. A bug fix should normally include a regression test that would fail without the fix. A new feature should include tests for its important states, error handling, and user visible behavior where practical.

Run the complete test suite with:

```bash
flutter test
```

For a focused test during development, use a test path or name filter:

```bash
flutter test test/path/to/example_test.dart
flutter test --name "descriptive test name"
```

When platform behavior is relevant, test on the affected platform and include the platform, operating system, Flutter version, and test result in the pull request.

## Documentation and User Experience

Documentation should use plain language and provide enough context for a new contributor or user to follow it without guessing. Keep commands copyable, identify expected prerequisites, and update examples when project behavior changes.

User facing changes should consider keyboard navigation, readable contrast, touch targets, error states, empty states, loading states, and responsive layouts. Include screenshots or a short recording in the pull request when the visual behavior is difficult to understand from code alone.

## Commit Messages

Use concise commit messages that explain the change. A preferred format is:

```
category: concise description
```

Examples include:

```
fix: prevent duplicate note saves
feat: add note search filtering
docs: clarify local setup steps
test: cover empty note state
```

Keep commits focused. If a pull request contains several logically separate changes, split them into separate commits or separate pull requests when practical.

## Pull Requests

Before opening a pull request, confirm that the branch contains only the intended changes and that the checks pass locally.

A useful pull request description includes:

| Section | What to include |
| --- | --- |
| Summary | A short explanation of what changed. |
| Motivation | The user problem, issue, or reason for the change. |
| Implementation | Important design or technical decisions. |
| Testing | Commands run and platforms tested. |
| Screenshots | Before and after images for visual changes. |
| Follow up | Known limitations or intentionally deferred work. |

Use a clear title and link the relevant issue when one exists. If the pull request is not ready for review, mark it as a draft.

A pull request may be asked to change when it has unclear scope, insufficient tests, unrelated edits, failing checks, undocumented behavior, or a design that does not fit the project. Review feedback is part of the collaboration process, not a rejection of the contributor.

Maintainers may request changes, approve, merge, close, or defer a pull request based on project priorities and quality requirements. Approval does not guarantee an immediate merge.

## Reporting Bugs

Before opening a bug report, search existing issues to check whether the problem is already known. A useful report should include the following information:

- A concise title that describes the problem.

- The expected behavior.

- The actual behavior.

- Steps to reproduce the issue.

- The affected platform and operating system.

- The Noto version or commit.

- The Flutter and Dart versions.

- Relevant logs, screenshots, or a minimal reproduction.

Remove passwords, access tokens, personal data, private files, and other sensitive information before posting logs or screenshots.

## Requesting Features

Feature requests should begin with the user problem rather than only a proposed implementation. Explain who benefits, how the current behavior falls short, what a successful outcome looks like, and whether there are alternative solutions.

A feature request is a discussion, not a promise of implementation. The maintainers may ask for clarification, suggest a smaller scope, defer the idea, or decide that it does not fit the project's goals.

## Security Issues

Do not publish security vulnerabilities, private credentials, or exploit details in a public issue. Report security concerns privately through the repository's designated security contact or GitHub security reporting workflow when available.

Until a vulnerability has been assessed, avoid sharing details publicly or creating a proof of concept that could expose users to harm.

## Forks and Support Policy

Noto welcomes experimentation and independent forks. However, **unofficial forks are separate projects and are not supported by the Noto maintainers**.

The Noto team is not responsible for the behavior, releases, security, hosting, documentation, changes, or user support of any fork. Issues caused by modifications in a fork should be reported to the maintainers of that fork, not to the Noto project.

If a fork changes the application name, package identifiers, branding, dependencies, backend services, build configuration, or source code, those changes are outside the scope of official Noto support. Fork maintainers are responsible for maintaining their own branches, releases, issue trackers, and user communications.

Contributions made against the official Noto repository are welcome when they follow this guide. A pull request to the official repository does not create a support obligation for an unrelated fork, and support for an unofficial fork does not create a support obligation for the official Noto project.

## Licensing and Contributor Rights

Noto is distributed under the [MIT License](LICENSE). By submitting a contribution, you confirm that you have the right to submit it and that your contribution can be distributed under the MIT License. Do not submit code, images, text, or other material copied from a source whose terms do not permit this use.

Unless a different agreement is explicitly stated for a specific contribution, submitted contributions are intended to be distributed under the same MIT License as the project. If the repository later adopts a contributor license agreement or additional contribution terms, those requirements will be documented here and in the pull request workflow.

## Maintainer Contact

For general questions, use GitHub Discussions or open an issue when the topic is appropriate for public project discussion. For sensitive matters, use the private contact method documented in the repository.

Please do not use issues to request support for unofficial forks. Contact the maintainers of the relevant fork instead.

## Final Checklist

Before submitting a pull request, confirm the following:

```
[ ] The change has a clear purpose and focused scope.
[ ] I checked existing issues and pull requests.
[ ] I created the branch from the latest main branch.
[ ] I formatted the Dart code.
[ ] flutter analyze passes.
[ ] flutter test passes.
[ ] I added or updated tests where appropriate.
[ ] I updated documentation where needed.
[ ] I removed unrelated changes.
[ ] I included testing details in the pull request description.
[ ] I removed secrets and private information from the submission.
```

Thank you for helping improve Noto and for making the project welcoming to future contributors.

## References

[1]: https://dart.dev/guides "Dart documentation"

[2]: https://docs.flutter.dev/ "Flutter documentation"

[3]: https://docs.github.com/en/get-started/quickstart/github-glossary "GitHub glossary"

<div align="center">
<img src="assets/logo-favicon.png" alt="Neptunium Laboratory logo" width="72" />
    

  <sub>Developed by <strong>Neptunium Laboratory</strong></sub>
</div>
