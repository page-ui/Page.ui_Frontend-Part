# Quickstart Validation Guide: User Profile Management

This guide documents the runnable scenarios to validate the User Profile Management feature end-to-end.

## Scenario 1: Viewing Profile details
- **Prerequisites**: An authenticated session (valid JWT stored in storage).
- **Execution**:
  1. Open the web browser and navigate to the application.
  2. Click on the profile navigation icon.
  3. Ensure the name, birthdate, and avatar/initials load correctly from the `GetUserProfile` query response.
- **Expected Outcome**: Profile details are displayed within 1 second.

## Scenario 2: Editing Profile Text fields (Name & Birthdate)
- **Prerequisites**: Loaded profile.
- **Execution**:
  1. Click "Edit Profile".
  2. Modify the Name field to "Jane Doe".
  3. Select a birthdate in the past from the date picker (e.g., "1995-10-15").
  4. Click "Save".
- **Expected Outcome**: Form closes, and the updated profile fields are rendered with the new details.

## Scenario 3: Uploading a Profile Photo
- **Prerequisites**: Loaded profile in edit mode.
- **Execution**:
  1. Click the edit photo button.
  2. Select an image file (JPEG or PNG, < 5MB).
  3. Notice the preview changes to the selected image.
  4. Click "Save".
  5. Verify the network log shows:
     - `GetProfilePhotoUploadUrl` mutation executed.
     - HTTP PUT request to Minio presigned URL with the file bytes (completed with 200 OK).
     - `UpdateUserProfile` mutation executed with the new `photoUrl`.
- **Expected Outcome**: Profile photo updates and displays the new image.

## Scenario 4: Removing Profile Photo
- **Prerequisites**: Profile with an existing photo.
- **Execution**:
  1. Click "Edit Profile".
  2. Click "Remove Photo".
  3. Click "Save".
- **Expected Outcome**: Profile photo disappears, and the placeholder avatar with initials is shown.
