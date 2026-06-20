# Phase Eleven Data Plan

## Purpose

This note defines the controlled support-data phase for the native iOS app.

The app already has expanded foundation and networking learning content. The next data phase should prepare shared reference data that future UI screens can display.

## Target datasets

The intended data groups are:

- glossary entries
- port and protocol reference entries
- framework comparison entries
- metric reference entries
- tool-category reference entries

## Expected structure

Each dataset should be modeled with small native Swift structs before UI work begins.

Recommended files:

- `GlossaryData.swift`
- `PortReferenceData.swift`
- `FrameworkReferenceData.swift`
- `MetricReferenceData.swift`
- `ToolReferenceData.swift`

## Delivery boundaries

Keep this phase data-only unless a later UX PR is opened.

Do not include:

- hosting changes
- release packaging changes
- unrelated UI redesign
- new persistence schema

## Validation requirements

A future implementation PR should pass:

- structure and policy validation
- project listing
- app build job

## Review rule

Keep data additions small enough for review. If a dataset becomes too large, split it into separate PRs.
