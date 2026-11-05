<!--
Sync Impact Report:
- Version change: none -> 1.0.0
- List of modified principles:
  - PRINCIPLE_1: Clean Architecture Discipline
  - PRINCIPLE_2: State Management & Rebuild Performance
  - PRINCIPLE_3: Data Communication & Pagination
  - PRINCIPLE_4: Modern Dart & Code Quality
  - PRINCIPLE_5: Testing & Edge Cases
- Added sections:
  - Technical & Architectural Constraints (Section 2)
  - Code Integrity & Development Workflow (Section 3)
- Removed sections: None
- Templates requiring updates:
  - .specify/templates/plan-template.md (✅ updated)
  - .specify/templates/spec-template.md (✅ updated)
  - .specify/templates/tasks-template.md (✅ updated)
- Follow-up TODOs: None
-->

# PageUI Constitution

## Core Principles

### I. Clean Architecture Discipline
Layer boundaries (presentation -> domain -> data) must never be bypassed. Each layer has a single responsibility. UI handles rendering and local state, business logic belongs to UseCases/Cubits, and data layer maps API exceptions to typed Failure/Error classes before propagating.

### II. State Management & Rebuild Performance
Use `flutter_bloc` (Cubit) for all feature/application states. Keep the UI layer purely presentation-driven. Limit `setState` to local, transient UI states. Minimize rebuild scopes, utilize const constructors, and properly dispose of controllers and focus nodes.

### III. Data Communication & Pagination
Network communication uses `graphql_flutter` for operations, featuring automatic JWT token refresh. Large collections must use cursor-based pagination. File/image uploads must go via Minio using presigned PUT requests.

### IV. Modern Dart & Code Quality
Prefer native Dart 3+ features (sealed classes, pattern matching, switch expressions) to minimize boilerplate and avoid unnecessary code generation (e.g., Freezed/build_runner). Keep files and functions small, focused, and free of redundant comments.

### V. Testing & Edge Cases
Ensure high test coverage by writing unit tests for domain/data layers and widget tests for critical UI flows. Tests must be deterministic. Properly handle empty, error, and loading states without allowing silent failures.

## Technical & Architectural Constraints
The project is built on Flutter (SDK ^3.10.4) targeting Google Chrome (Web). It uses `get_it` for dependency injection, `go_router` for route declaration and guard-based redirects, and `flutter_secure_storage` and `hive` for persistent token storage and caching. All cross-feature utilities, services, or shared widgets must be located under the `core/` folder to prevent code duplication.

## Code Integrity & Development Workflow
Code reviews and automated tests must verify layer boundaries and security standards. Never hardcode tokens, secrets, or credentials, and avoid logging sensitive information. All external or API inputs must be safely validated.

## Governance
All code modifications, pull requests, and project extensions must conform to this Constitution. Changes to core guidelines require a formal amendment to this document, including incrementing the semantic version, and updating corresponding project templates (such as `.specify/templates/plan-template.md` and `GEMINI.md`).

**Version**: 1.0.0 | **Ratified**: 2026-06-26 | **Last Amended**: 2026-06-26
