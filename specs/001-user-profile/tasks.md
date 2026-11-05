# Tasks: User Profile Management

**Input**: Design documents from `/specs/001-user-profile/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [x] T001 Create profile feature folder structure per implementation plan

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core data and network infrastructure required before user stories

- [x] T002 Create UserProfile domain entity in lib/features/profile/domain/entities/user_profile.dart
- [x] T003 Create UserProfileModel in lib/features/profile/data/models/user_profile_model.dart
- [x] T004 Define ProfileRepository interface in lib/features/profile/domain/repositories/profile_repository.dart
- [x] T005 Implement ProfileRemoteDataSource with GraphQL endpoints in lib/features/profile/data/datasources/profile_remote_data_source.dart
- [x] T006 Implement ProfileRepositoryImpl in lib/features/profile/data/repositories/profile_repository_impl.dart
- [x] T007 Register profile feature dependencies in lib/core/helpers/setup_service_locator_getit.dart

**Checkpoint**: Foundational layer complete.

---

## Phase 3: User Story 1 - View Profile Details (Priority: P1) 🎯 MVP

**Goal**: Allow authenticated users to view profile name, birthdate, and photo.

**Independent Test**: Navigate to `/profile` route and confirm data displays.

### Implementation for User Story 1

- [x] T008 [US1] Create GetUserProfileUseCase in lib/features/profile/domain/usecases/get_user_profile_usecase.dart
- [x] T009 [US1] Implement UserProfileCubit fetching states in lib/features/profile/presentation/cubit/user_profile_cubit.dart
- [x] T010 [US1] Create UserProfileView UI screen with placeholder avatar support in lib/features/profile/presentation/views/user_profile_view.dart
- [x] T011 [US1] Register profile route in lib/config/routes/on_generate_routes.dart

**Checkpoint**: User Story 1 is fully functional and testable.

---

## Phase 4: User Story 2 - Edit Profile Information (Priority: P1)

**Goal**: Support text fields editing (Name & Birthdate) with validation.

**Independent Test**: Click Edit, change text inputs, click Save, and confirm changes persist.

### Implementation for User Story 2

- [x] T012 [US2] Create UpdateUserProfileUseCase in lib/features/profile/domain/usecases/update_user_profile_usecase.dart
- [x] T013 [US2] Add text editing validations and save actions in lib/features/profile/presentation/cubit/user_profile_cubit.dart
- [x] T014 [US2] Update UserProfileView to support editable text inputs and date picker in lib/features/profile/presentation/views/user_profile_view.dart

**Checkpoint**: User Stories 1 and 2 work together.

---

## Phase 5: User Story 3 - Update Profile Photo (Priority: P2)

**Goal**: Support selecting, uploading, and removing profile photos.

**Independent Test**: Upload a photo, save, verify it loads; then click remove, save, and verify initials placeholder displays.

### Implementation for User Story 3

- [x] T015 [US3] Implement image selection and removal events in lib/features/profile/presentation/cubit/user_profile_cubit.dart
- [x] T016 [US3] Integrate Minio upload sequence and profile url mutations in lib/features/profile/presentation/cubit/user_profile_cubit.dart
- [x] T017 [US3] Add upload and removal triggers to UserProfileView in lib/features/profile/presentation/views/user_profile_view.dart

**Checkpoint**: All user stories functional.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Code cleanup, test coverage, and end-to-end validation.

- [x] T018 Write unit tests for ProfileRepositoryImpl in test/features/profile/data/repositories/profile_repository_impl_test.dart
- [x] X T019 Write unit tests for UserProfileCubit in test/features/profile/presentation/cubit/user_profile_cubit_test.dart
- [x] T020 Run validation scenarios from quickstart.md and confirm all pass

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Setup (Phase 1).
- **User Stories (Phases 3-5)**: Depend on Foundational (Phase 2).
- **Polish (Phase 6)**: Depends on all user stories being implemented.

### Parallel Opportunities

- Within Phase 2: Entity definition (`T002`) and Model definition (`T003`) can run in parallel.
- Within Phase 6: Test suites (`T018`, `T019`) can be written in parallel.
