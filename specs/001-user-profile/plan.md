# Implementation Plan: User Profile Management

**Branch**: `001-user-profile` | **Date**: 2026-06-26 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/001-user-profile/spec.md`

## Summary

Implement a user profile viewing and editing screen. Users can view their profile data (Name, Birthdate, Photo), edit it, and optionally upload a new image or remove the existing photo. Uploads to Minio storage are handled via presigned URLs, and saving is transactional (both file upload and textual profile details are saved concurrently on click of the "Save" button).

## Technical Context

**Language/Version**: Dart 3.x, Flutter SDK ^3.10.4

**Primary Dependencies**: `flutter_bloc` (Cubit), `graphql_flutter` (GraphQL client), `dio` (Minio direct upload), `get_it` (service locator), `go_router` (declarative routing)

**Storage**: `hive` (caching), `flutter_secure_storage` (auth token persistence)

**Testing**: `flutter test` for unit and widget testing

**Target Platform**: Web (Google Chrome)

**Project Type**: Flutter Web Application

**Performance Goals**: Profile details load in under 1 second; updates/uploads complete and refresh in under 3 seconds under normal network conditions.

**Constraints**: Strict Clean Architecture (UI -> Domain -> Data), native Dart 3 features (no Freezed or build_runner generators), no business logic in widgets.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principle I: Clean Architecture Discipline** - YES. Presentation (Cubit/View) depends only on Domain (UseCases/Entities), which in turn defines Repository interfaces implemented by Data sources. No boundaries are bypassed.
- **Principle II: State Management & Rebuild Performance** - YES. Using `UserProfileCubit` with distinct sealed-class states (`UserProfileLoaded`, `UserProfileEditing`, etc.). UI observes state. Rebuild scope is minimized.
- **Principle III: Data Communication & Pagination** - YES. GraphQL client used for queries/mutations. Token refresh handled by existing client configuration. Dio REST client utilized for PUT uploads to Minio.
- **Principle IV: Modern Dart & Code Quality** - YES. Adopting sealed classes, switch pattern matching, and records. No code generation.
- **Principle V: Testing & Edge Cases** - YES. Comprehensive test coverage planned for domain/data logic and presentation UI.

## Project Structure

### Documentation (this feature)

```text
specs/001-user-profile/
├── plan.md              # This file
├── research.md          # Research decisions
├── data-model.md        # Entities and state unions
├── quickstart.md        # Scenario-based validation guide
├── contracts/
│   └── profile-operations.graphql # GraphQL API contracts
└── tasks.md             # Tasks list (generated next)
```

### Source Code (repository root)

```text
lib/
├── config/
│   └── routes.dart             # Registers profile route (/profile)
└── features/
    └── profile/
        ├── data/
        │   ├── models/
        │   │   └── user_profile_model.dart
        │   ├── datasources/
        │   │   └── profile_remote_data_source.dart
        │   └── repositories/
        │       └── profile_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   └── user_profile.dart
        │   ├── repositories/
        │   │   └── profile_repository.dart
        │   └── usecases/
        │       ├── get_user_profile_usecase.dart
        │       └── update_user_profile_usecase.dart
        └── presentation/
            ├── cubit/
            │   └── user_profile_cubit.dart
            └── views/
                └── user_profile_view.dart

test/
└── features/
    └── profile/
        ├── data/
        │   └── repositories/
        │       └── profile_repository_impl_test.dart
        ├── domain/
        │   └── usecases/
        │       └── update_user_profile_usecase_test.dart
        └── presentation/
            └── cubit/
                └── user_profile_cubit_test.dart
```

**Structure Decision**: Single project layout matching the existing feature folders inside the `lib/features/` repository structure.

## Complexity Tracking

*No violations of the project Constitution are proposed. The layout fits standard Clean Architecture boundaries.*
