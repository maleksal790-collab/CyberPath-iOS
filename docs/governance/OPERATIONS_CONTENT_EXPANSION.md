# Operations Content Expansion

## Purpose

This document defines the next native iOS learning-content expansion phase.

The current Swift data already includes foundation and networking learning sections. The next implementation step should expand the operations-oriented learning section in a controlled PR while keeping the existing native data model stable.

## Target topics

The intended content expansion should cover:

- response lifecycle
- identity review workflow
- alert review workflow
- weakness management workflow
- monitoring-rule lifecycle

## Data shape

Each topic should follow the same native Swift topic structure used in the completed learning migrations:

- `overview`
- `workplaceUse`
- `deepDive`
- `keyTerms`
- `relatedTopicIds`
- `quizzes`

## Delivery rules

Keep the implementation scoped to content data only unless a separate UX PR is opened.

Do not include:

- hosting changes
- release packaging changes
- unrelated UI redesign
- new app architecture
- new persistence schema

## Validation requirements

The implementation PR should pass:

- structure and policy validation
- project listing
- app build job

## Source note

The currently enabled web repository does not expose the earlier roadmap source path used by prior migrations. Because of that, this phase should be treated as native iOS content expansion rather than strict source parity until the original source data repository is available again.
