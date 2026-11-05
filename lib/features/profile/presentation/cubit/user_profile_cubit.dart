import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_ui/features/chat/data/data_source/upload_service.dart';
import 'package:page_ui/features/profile/domain/entities/user_profile.dart';
import 'package:page_ui/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:page_ui/features/profile/domain/usecases/update_user_profile_usecase.dart';

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
  
  // Local image file data if a new photo is selected but not uploaded yet
  final Uint8List? localPhotoBytes;
  final String? localPhotoName;
  final String? localPhotoContentType;
  
  // Set to true if the photo was explicitly removed during edit session
  final bool isPhotoRemoved;

  UserProfileEditing({
    required this.originalProfile,
    required this.draftName,
    this.draftBirthdate,
    this.localPhotoBytes,
    this.localPhotoName,
    this.localPhotoContentType,
    this.isPhotoRemoved = false,
  });

  UserProfileEditing copyWith({
    String? draftName,
    String? draftBirthdate,
    Uint8List? localPhotoBytes,
    String? localPhotoName,
    String? localPhotoContentType,
    bool? isPhotoRemoved,
  }) {
    return UserProfileEditing(
      originalProfile: originalProfile,
      draftName: draftName ?? this.draftName,
      draftBirthdate: draftBirthdate ?? this.draftBirthdate,
      localPhotoBytes: localPhotoBytes ?? this.localPhotoBytes,
      localPhotoName: localPhotoName ?? this.localPhotoName,
      localPhotoContentType: localPhotoContentType ?? this.localPhotoContentType,
      isPhotoRemoved: isPhotoRemoved ?? this.isPhotoRemoved,
    );
  }
}

class UserProfileSaving extends UserProfileState {}

class UserProfileFailure extends UserProfileState {
  final String message;
  
  UserProfileFailure(this.message);
}

class UserProfileCubit extends Cubit<UserProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final UploadService uploadService;

  UserProfileCubit({
    required this.getUserProfileUseCase,
    required this.updateUserProfileUseCase,
    required this.uploadService,
  }) : super(UserProfileInitial());

  Future<void> fetchProfile() async {
    emit(UserProfileLoading());
    final result = await getUserProfileUseCase();
    result.fold(
      (failure) => emit(UserProfileFailure(failure.message)),
      (profile) => emit(UserProfileLoaded(profile)),
    );
  }

  void enterEditMode() {
    final currentState = state;
    if (currentState is UserProfileLoaded) {
      emit(UserProfileEditing(
        originalProfile: currentState.profile,
        draftName: currentState.profile.name,
        draftBirthdate: currentState.profile.birthdate,
      ));
    }
  }

  void exitEditMode() {
    final currentState = state;
    if (currentState is UserProfileEditing) {
      emit(UserProfileLoaded(currentState.originalProfile));
    }
  }

  void updateDraftName(String name) {
    final currentState = state;
    if (currentState is UserProfileEditing) {
      emit(currentState.copyWith(draftName: name));
    }
  }

  void updateDraftBirthdate(String? birthdate) {
    final currentState = state;
    if (currentState is UserProfileEditing) {
      emit(currentState.copyWith(draftBirthdate: birthdate));
    }
  }

  void selectLocalPhoto({
    required Uint8List bytes,
    required String name,
    required String contentType,
  }) {
    final currentState = state;
    if (currentState is UserProfileEditing) {
      emit(currentState.copyWith(
        localPhotoBytes: bytes,
        localPhotoName: name,
        localPhotoContentType: contentType,
        isPhotoRemoved: false,
      ));
    }
  }

  void removePhoto() {
    final currentState = state;
    if (currentState is UserProfileEditing) {
      emit(UserProfileEditing(
        originalProfile: currentState.originalProfile,
        draftName: currentState.draftName,
        draftBirthdate: currentState.draftBirthdate,
        localPhotoBytes: null,
        localPhotoName: null,
        localPhotoContentType: null,
        isPhotoRemoved: true,
      ));
    }
  }

  Future<void> saveProfile() async {
    final currentState = state;
    if (currentState is! UserProfileEditing) return;

    final String name = currentState.draftName.trim();
    if (name.isEmpty) {
      emit(UserProfileFailure("Name cannot be empty"));
      // Restore editing state after showing error
      emit(currentState);
      return;
    }

    if (name.length > 100) {
      emit(UserProfileFailure("Name cannot exceed 100 characters"));
      emit(currentState);
      return;
    }

    final birthdateStr = currentState.draftBirthdate;
    if (birthdateStr != null && birthdateStr.isNotEmpty) {
      try {
        final birthdate = DateTime.parse(birthdateStr);
        if (birthdate.isAfter(DateTime.now())) {
          emit(UserProfileFailure("Birthdate cannot be in the future"));
          emit(currentState);
          return;
        }
      } catch (_) {
        emit(UserProfileFailure("Invalid birthdate format"));
        emit(currentState);
        return;
      }
    }

    emit(UserProfileSaving());

    String? photoUrl = currentState.originalProfile.photoUrl;

    if (currentState.isPhotoRemoved) {
      photoUrl = null;
    } else if (currentState.localPhotoBytes != null) {
      try {
        photoUrl = await uploadService.upload(
          fileBytes: currentState.localPhotoBytes!,
          fileName: currentState.localPhotoName!,
          contentType: currentState.localPhotoContentType!,
        );
      } catch (e) {
        emit(UserProfileFailure("Photo upload failed: ${e.toString()}"));
        emit(currentState);
        return;
      }
    }

    final result = await updateUserProfileUseCase(
      name: name,
      birthdate: birthdateStr,
      photoUrl: photoUrl,
    );

    result.fold(
      (failure) {
        emit(UserProfileFailure(failure.message));
        emit(currentState);
      },
      (profile) => emit(UserProfileLoaded(profile)),
    );
  }
}
