# CyberPath iOS Delivery Pipeline

## Purpose

This pipeline governs how CyberPath iOS changes move from source change to verified mobile delivery.

## Delivery Stages

1. Change proposal through pull request.
2. Structure and policy validation.
3. Xcode project listing.
4. Simulator build.
5. Manual simulator smoke test.
6. Accessibility and privacy review.
7. Release-readiness approval.
8. Source package creation.
9. Mac/Xcode signing and TestFlight/App Store distribution when Apple credentials are available.

## Required Branch Controls

- All changes enter through pull request.
- At least one mobile maintainer review is required.
- Governance files require release-governance review.
- CI must pass before merge.
- Release packaging is manual through `workflow_dispatch`.

## CI Workflow

The GitHub Actions workflow is `.github/workflows/ios-governed-delivery.yml`.

It runs on macOS because Xcode and iOS Simulator tooling are required. The workflow validates structure, lists the Xcode project, builds the app, and can package a release source archive through a manual dispatch.

## Local Developer Flow

```bash
make validate
make build
make archive
make export
```

Set a different simulator when needed:

```bash
make build DESTINATION='platform=iOS Simulator,name=iPhone 16'
```

## Release Principle

The app is local-first and account-free. No cloud dependency is required for core workflows.
