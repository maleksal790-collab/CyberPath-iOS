# Security And Privacy

## Data Model

CyberPath iOS is local-first. Learner progress, notes, quiz history, scenario evidence, and diagnostic state are stored locally through app persistence.

## Privacy Position

- No account is required.
- No analytics SDK is included.
- No backend service is required.
- No cloud synchronization is included.
- No formal certification claim is made.

## Sensitive Data Controls

- Do not commit provisioning profiles.
- Do not commit certificates.
- Do not commit private keys.
- Do not commit App Store Connect credentials.
- Use GitHub Actions secrets or local keychain storage for future signing automation.

## Export Controls

Progress export is user-controlled. Exported learner notes and evidence may contain personal study material, so support documentation must treat exports as user-owned private files.

## Security Review Gate

Security review is required when a change introduces:

- Network access.
- Account creation.
- Cloud sync.
- Analytics.
- AI tutoring.
- File import/export format changes.
- External package dependencies.

