# Phase Twelve UX Plan

## Purpose

This note defines the controlled user-interface phase after the main learning and reference data planning phases.

The goal is to prepare navigation and screen work without changing the current app architecture prematurely.

## Target screens

Future implementation should expose the expanded data through focused SwiftUI screens:

- glossary screen
- reference screen
- comparison screen
- metric screen
- tool category screen

## Navigation expectations

The UX phase should keep navigation predictable:

- use existing tab and navigation patterns where possible
- avoid replacing the app shell in the same PR
- preserve existing progress, bookmarks, and quiz behavior
- keep topic detail behavior stable

## Delivery boundaries

Do not include:

- hosting changes
- release packaging changes
- new persistence schema
- unrelated visual redesign
- large architecture rewrite

## Validation requirements

A future implementation PR should pass:

- structure and policy validation
- project listing
- app build job

## Review rule

Split UI work if a single PR becomes too large. Prefer one navigation foundation PR followed by separate screen PRs if needed.
