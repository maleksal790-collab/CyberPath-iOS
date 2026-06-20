# Phase Ten Content Plan

## Purpose

This note defines the next controlled native iOS learning-content phase after the completed foundation, networking, and operations notes.

## Target areas

The next implementation phase should expand:

- governance learning material
- risk decision learning material
- compliance and evidence learning material
- shared responsibility learning material
- access-control learning material

## Expected data shape

Each future topic should follow the same native Swift topic structure already used in prior migrations:

- `overview`
- `workplaceUse`
- `deepDive`
- `keyTerms`
- `relatedTopicIds`
- `quizzes`

## Delivery boundaries

Keep implementation work scoped to learning data unless a separate UX PR is created.

Do not include:

- hosting changes
- release packaging changes
- unrelated UI redesign
- new app architecture
- new persistence schema

## Validation requirements

A future implementation PR should pass:

- structure and policy validation
- project listing
- app build job

## Review rule

If the source data repository is unavailable, treat the work as native iOS expansion rather than strict web-source parity.
