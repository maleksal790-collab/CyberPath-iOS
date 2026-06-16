# Decision Log

## 2026-06-16: Local-First Native iOS Delivery

Decision: keep the iOS version as a native SwiftUI project with no third-party package dependencies.

Reason: this preserves offline use, keeps learner data private by default, and reduces release risk while the product is still being validated.

## 2026-06-16: Signing Outside Source Control

Decision: do not include certificates, provisioning profiles, or App Store credentials in the repository.

Reason: signing material is sensitive and must be handled through local keychain or encrypted CI secrets.

## 2026-06-16: Build Gate Before Production Test Target

Decision: use structure validation and simulator build as the current automated gate, with XCTest target creation documented as the next production requirement.

Reason: the current generated Xcode project contains one app target. Adding a full test target should be done on macOS/Xcode and validated with `xcodebuild test`.

