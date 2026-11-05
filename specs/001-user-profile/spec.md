# Feature Specification: User Profile Management

**Feature Branch**: `001-user-profile`

**Created**: 2026-06-26

**Status**: Draft

**Input**: User description: "the loggined user can see his profile his name birthdate photo and can edit it"

## Clarifications

### Session 2026-06-26
- Q: Profile Photo Upload and Save Sequence → A: Defer Minio upload and DB update until the user clicks the "Save" button.
- Q: Profile Photo Deletion/Removal → A: Yes, allow removing the photo in edit mode, reverting to the initials placeholder upon saving.
- Q: Birthdate Validation Constraint → A: No age gate: any birthdate in the past is valid.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - View Profile Details (Priority: P1)

Logged-in users can navigate to their profile page to view their current profile details, including their full name, birthdate, and profile photo.

**Why this priority**: Core requirement for users to confirm their current identity and information stored on the platform.

**Independent Test**: Can be tested independently by logging in, navigating to the profile route, and verifying that the correct name, birthdate, and profile photo (or fallback avatar) are displayed.

**Acceptance Scenarios**:

1. **Given** an authenticated user is on the chat dashboard, **When** they click on the profile icon or menu option, **Then** they are navigated to their profile screen.
2. **Given** an authenticated user is on the profile screen, **When** the page loads, **Then** their name, birthdate, and profile photo (if set) are rendered.
3. **Given** an authenticated user has not uploaded a profile photo, **When** they view their profile, **Then** a placeholder avatar using their initials is displayed.

---

### User Story 2 - Edit Profile Information (Priority: P1)

Logged-in users can edit their profile information (name and birthdate) and save their changes. Any birthdate in the past is accepted without age gating.

**Why this priority**: Essential functionality to allow users to keep their personal details accurate and up to date.

**Independent Test**: Can be tested by entering edit mode, changing the name and birthdate values, saving, and verifying the updated values persist after refreshing.

**Acceptance Scenarios**:

1. **Given** an authenticated user is on the profile screen, **When** they click "Edit Profile", **Then** the details switch to editable form fields showing current values.
2. **Given** the profile edit form is active, **When** the user edits their name to a valid value and selects a birthdate from the date picker (any date in the past), then clicks "Save", **Then** the updated profile is saved and the screen displays the new details.
3. **Given** the profile edit form is active, **When** the user clicks "Cancel", **Then** all pending edits are discarded and the original profile details are restored.

---

### User Story 3 - Update Profile Photo (Priority: P2)

Logged-in users can upload a new profile photo, update their existing one, or remove it. Both the photo upload to Minio and the database record updates are deferred until the user clicks the "Save" button.

**Why this priority**: Enhances personalization and visual identification, but can be deployed separately from textual edits.

**Independent Test**: Can be tested by selecting an image file, triggering the upload on save, and verifying that the new profile image renders correctly.

**Acceptance Scenarios**:

1. **Given** the profile edit form is active, **When** the user clicks the profile photo edit trigger and selects a valid image file (PNG/JPEG, < 5MB), **Then** the local preview is updated but no upload or database save occurs.
2. **Given** a new photo is selected, **When** the user clicks "Save", **Then** the photo is uploaded to Minio, the database record is updated, and the updated profile photo is displayed.
3. **Given** the profile edit form is active, **When** the user clicks "Remove Photo" and clicks "Save", **Then** the photo URL is cleared in the database and the profile photo reverts to the initials-based placeholder.

---

### Edge Cases

- **Connectivity Failure during Save**: What happens if the network drops while saving? The app must show a friendly error banner and keep the edit form open with their inputs intact.
- **Minio Upload Failure**: If the image upload to Minio fails during the save process, the database update must be aborted, and the user must see an upload failure error message while the form remains editable.
- **Invalid Profile Inputs**: If the name is empty or birthdate is in the future, the save action must be blocked and inline validation errors must be displayed.
- **Large Image Upload**: If a user uploads an image larger than 5MB or of an unsupported format, the app must reject it and show an error notification.

## Detailed UI/UX Specifications

### 1. Page Layout & Component Arrangement
- The profile screen uses a clean, centered card container.
- At the top center, the profile avatar is displayed (120x120px circular display). In edit mode, a camera overlay icon is displayed on hover over the avatar.
- Below the avatar, the Name and Birthdate are rendered.
- In view mode, fields are displayed as read-only text labels. A primary action button "Edit Profile" is displayed at the bottom of the card.
- In edit mode, the fields convert to form input fields (Name text field and Birthdate date picker field). "Save" and "Cancel" buttons are aligned horizontally at the bottom.

### 2. Loading State
- The profile data fetch uses `Skeletonizer` to render smooth loading skeletons matching the card layout.

### 3. Fallback Avatar Style
- If the user has no profile photo, the avatar displays as a circle container filled with a neutral theme color, overlaying the user's uppercase initials in white bold text.

### 4. Edit Indicators & Input Feedback
- Input fields in edit mode feature a subtle accent border. Fields modified by the user but unsaved display a status indicator (e.g., an asterisk or modified label) and a warning dialog is displayed if the user tries to click "Cancel" with unsaved changes.
- Validation failures are displayed immediately below the corresponding input fields in inline red validation helper text:
  - Empty name: "Name cannot be empty"
  - Future birthdate: "Birthdate cannot be in the future"

### 5. Interaction States (Buttons)
- Buttons feature smooth hover color transitions, focus ring outlines on keyboard focus, and 50% opacity when disabled (e.g., during saving operations).

### 6. Date Picker component
- Clicking the birthdate input field opens a modal calendar dialog wrapper to select a date. Manual keyboard text entry is blocked to avoid parsing errors.

### 7. Photo Selection Feedback
- When a local file is chosen in edit mode, the selected image is immediately rendered in the circular avatar preview, replacing the previous photo or placeholder avatar in the local state.

## Detailed Security & Data Integrity Specifications

### 1. Authorization Gate
- All profile screens and backend mutations are guarded. The UI redirects unauthenticated users to `/login`.
- The GraphQL client automatically attaches the JWT auth token to the request headers. The backend resolves user context from the token, ensuring a user can only query and mutate their own profile record.

### 2. JWT Lifespan & Refresh
- If the token expires during an active session, the GraphQL `ErrorLink` transparently handles refreshing the token in the background before retrying the failed operation. If refresh fails, the user is redirected to the login page.

### 3. Input Sanitization
- All text inputs (e.g., name field) are sanitized on submit to strip dangerous HTML, CSS, or script tags before sending the mutation.

### 4. Media Restrictions
- File selection blocks any file that is not JPEG or PNG, or that exceeds 5MB in size.
- The backend maps uploads to secure URLs, keeping the direct storage bucket private.

### 5. Security & Validation Logging
- Failed unauthorized updates or validation errors are logged locally and sent to the centralized logging service, including the error code and user session metadata (omitting passwords or raw secrets).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST show the profile view only to authenticated users (unauthenticated users must be redirected to login).
- **FR-002**: System MUST display the user's name, birthdate (formatted appropriately, e.g., YYYY-MM-DD), and profile photo.
- **FR-003**: System MUST provide an edit mode where fields can be modified.
- **FR-004**: System MUST validate that the name is not empty or longer than 100 characters.
- **FR-005**: System MUST validate that the birthdate is not in the future.
- **FR-006**: System MUST persist the updated profile information to the backend database upon saving.
- **FR-007**: System MUST support uploading JPEG and PNG images for profile photos up to 5MB.
- **FR-008**: System MUST support removing the profile photo and resetting it to the initials-based placeholder upon saving.
- **FR-009**: System MUST defer profile photo upload to Minio and database update until the user clicks the "Save" button.

### Key Entities

- **UserProfile**: Represents the user's personal details.
  - `id`: Unique identifier (string).
  - `name`: Full name of the user (string).
  - `birthdate`: Birthdate of the user (date/string).
  - `photoUrl`: URL of the profile photo (string, optional).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can successfully view their profile details in less than 1 second from clicking the profile link under normal network conditions.
- **SC-002**: Users can complete editing and saving their name and birthdate in under 3 clicks (Edit -> Change -> Save).
- **SC-003**: Profile updates (including photo uploads) complete and render the updated state to the user in under 3 seconds under normal network conditions.

## Assumptions

- **Authentication Presence**: An active user session with JWT tokens already exists.
- **Media Upload Channel**: Photo uploads can utilize the existing Minio storage architecture via presigned URLs.
- **Date Picking UI**: A standard native or web-friendly date picker widget is available for selecting birthdates.
