# Page.ui

Page.ui is a Flutter application organized with a clean-architecture, feature-first structure. The codebase separates responsibilities into `data`, `domain`, and `presentation` layers and centralizes shared infrastructure in `core`.

## Highlights
- Clean architecture (data/domain/presentation) per feature
- BLoC state management
- GraphQL networking
- Local persistence (Hive + Secure Storage)
- Dependency injection with GetIt
- Custom theming, assets, and fonts

## Project Structure
- `lib/config/` routing, themes, generated assets
- `lib/core/` shared utilities, constants, errors, network, cache, helpers
- `lib/features/`
  - `auth/` authentication flows
  - `chat/` chat UI and logic
  - `intro_screens/` splash and onboarding
- `lib/main.dart` app bootstrap
- `lib/main_app.dart` root widget and theme setup

## Requirements
- Flutter SDK (Dart SDK ^3.10.4)

## Getting Started
```bash
flutter pub get
flutter run
```

## Common Tasks
```bash
# Static analysis
flutter analyze

# Unit/widget tests
flutter test
```

## Assets and Fonts
- Images: `assets/images/`
- Fonts: `assets/fonts/` (StoryScript, Audiowide)

## Notes
- The app uses GraphQL configuration in `lib/core/database/api/`.
- Dependency registration is in `lib/core/helpers/setup_service_locator_getit.dart`.

## License
Private project. All rights reserved.
