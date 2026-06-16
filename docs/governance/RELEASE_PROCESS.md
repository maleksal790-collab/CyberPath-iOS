# Release Process

## Versioning

Use semantic versioning:

- Patch for fixes and copy/content corrections.
- Minor for learner-facing feature additions.
- Major for data migration or architecture changes that require explicit release planning.

## Pre-Release Checklist

1. Merge only through reviewed pull requests.
2. Confirm CI passes.
3. Complete manual simulator acceptance.
4. Confirm privacy/security review.
5. Update release notes.
6. Confirm bundle identifier and signing team.
7. Archive in Xcode or through `scripts/release/archive_release.sh`.
8. Export through `scripts/release/export_appstore.sh` or upload from Xcode using authorized Apple Developer credentials.
9. Submit to TestFlight first; production App Store release requires acceptance evidence.

## Rollback

For source release packages, rollback means restoring the previous tagged source package. For App Store releases, rollback is handled through phased release pause or replacement build submission.

## Signing

Signing is intentionally excluded from source control. Future CI signing must use GitHub Actions encrypted secrets and a dedicated Apple Developer role.
