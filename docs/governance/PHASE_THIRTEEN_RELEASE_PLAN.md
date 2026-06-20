# Phase Thirteen Release Plan

## Purpose

This note defines the final release-readiness planning phase for the native iOS app.

The previous governed phases prepared learning content, reference data planning, and interface planning. This phase prepares the final verification path before external distribution work.

## Target checks

Before release work, verify:

- app builds successfully
- main screens load correctly
- learning topics render correctly
- quiz flow works correctly
- progress state remains stable
- import and export behavior still works
- documentation is current

## Packaging readiness

The final release phase should confirm:

- bundle identifier
- signing expectations
- build configuration
- archive path
- export settings
- validation checklist
- known limitations

## Delivery boundaries

Do not combine final release readiness with large content or UX changes.

Do not include:

- unrelated UI redesign
- new persistence schema
- new app architecture
- unreviewed source migrations

## Validation requirements

The final PR should pass:

- structure and policy validation
- project listing
- app build job

## Review rule

Release readiness should be treated as a gate, not a feature dump. Any large unfinished item should become a follow-up issue or separate PR.
