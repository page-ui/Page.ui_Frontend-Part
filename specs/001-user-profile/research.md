# Research: User Profile Management

This document details the architectural and research decisions made for implementing the User Profile feature.

## Technical Research & Decisions

### 1. Photo Selection on Flutter Web
- **Decision**: Use a file picker interface optimized for web (e.g., native browser file inputs via HTML wrapper or `image_picker` package supporting web platform).
- **Rationale**: Flutter Web has specific constraints regarding files. Reading files as bytes (`Uint8List`) is necessary to perform a PUT request to the Minio presigned URL via `Dio`.
- **Alternatives Considered**: 
  - Standard `file_picker` package (rejected to avoid introducing extra dependencies unless necessary, preferring native Flutter web-compatible picker).

### 2. Deferring Media Upload and Saving Sequence
- **Decision**: Maintain a local reference to the selected image bytes (`Uint8List`) and file name in the Cubit state. When the user clicks "Save", first perform the presigned URL request and file upload to Minio (if a new image is selected). Once successful, trigger the GraphQL `updateUserProfile` mutation with the uploaded photo URL and other text fields in a single execution flow.
- **Rationale**: Aligns with the user's choice (Option C) to minimize early network overhead and ensure atomic saves where both image upload and record changes succeed together or fail safely.
- **Alternatives Considered**: 
  - Uploading immediately on selection (rejected per user feedback).

### 3. State Management Structure
- **Decision**: Define a single `UserProfileCubit` to coordinate the profile view, edit transition, local input buffering (during edit mode), file upload triggers, and mutation saves.
- **Rationale**: Consolidates state logic in one clean component, avoiding multiple cubits for a relatively simple CRUD feature. It manages UI state cleanly.
- **Alternatives Considered**: Separating into `UserProfileViewCubit` and `UserProfileEditCubit` (rejected as overengineering for a single screen).

### 4. Photo Deletion/Removal Flow
- **Decision**: When the user removes their profile photo, set `photoUrl` to `null` (or empty string depending on GraphQL schema capability) in the mutation variables. The backend maps this to delete the record association, reverting the UI to the initials-based placeholder.
- **Rationale**: Simple, direct, and adheres to Option A selected during clarification.
