# Data Model: User Profile Management

This document defines the schemas and state interfaces for User Profile Management.

## Entities

### UserProfile

Represents the authenticated user's profile details.

| Field | Type | Description | Constraints |
|---|---|---|---|
| `id` | `String` | Unique user/profile identifier. | Non-empty |
| `name` | `String` | Full name of the user. | 1 to 100 characters |
| `birthdate` | `String` | User's birthdate (ISO 8601 format: `YYYY-MM-DD`). | Nullable, must not be in the future |
| `photoUrl` | `String` | URL of the profile photo. | Nullable, valid URI |

## BLoC / Cubit State Union

The feature uses a state union represented via Dart sealed classes:

```dart
sealed class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserProfile profile;
  
  UserProfileLoaded(this.profile);
}

class UserProfileEditing extends UserProfileState {
  final UserProfile originalProfile;
  final String draftName;
  final String? draftBirthdate;
  final String? draftPhotoPath; // Local file preview path/bytes if modified
  
  UserProfileEditing({
    required this.originalProfile,
    required this.draftName,
    this.draftBirthdate,
    this.draftPhotoPath,
  });
}

class UserProfileSaving extends UserProfileState {}

class UserProfileFailure extends UserProfileState {
  final String message;
  
  UserProfileFailure(this.message);
}
```
