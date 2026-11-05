import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:page_ui/core/errors/failure.dart';
import 'package:page_ui/features/chat/data/data_source/upload_service.dart';
import 'package:page_ui/features/profile/domain/entities/user_profile.dart';
import 'package:page_ui/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:page_ui/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:page_ui/features/profile/presentation/cubit/user_profile_cubit.dart';

import 'user_profile_cubit_test.mocks.dart';

@GenerateMocks([GetUserProfileUseCase, UpdateUserProfileUseCase, UploadService])
void main() {
  late UserProfileCubit cubit;
  late MockGetUserProfileUseCase mockGetUserProfileUseCase;
  late MockUpdateUserProfileUseCase mockUpdateUserProfileUseCase;
  late MockUploadService mockUploadService;

  setUp(() {
    mockGetUserProfileUseCase = MockGetUserProfileUseCase();
    mockUpdateUserProfileUseCase = MockUpdateUserProfileUseCase();
    mockUploadService = MockUploadService();
    cubit = UserProfileCubit(
      getUserProfileUseCase: mockGetUserProfileUseCase,
      updateUserProfileUseCase: mockUpdateUserProfileUseCase,
      uploadService: mockUploadService,
    );
  });

  tearDown(() {
    cubit.close();
  });

  const tProfile = UserProfile(
    id: 'user_123',
    name: 'John Doe',
    birthdate: '1995-05-15',
    photoUrl: 'https://example.com/photo.jpg',
  );

  group('fetchProfile', () {
    test('should emit [UserProfileLoading, UserProfileLoaded] when successful', () async {
      when(mockGetUserProfileUseCase()).thenAnswer((_) async => const Right(tProfile));

      final expectedStates = [
        isA<UserProfileLoading>(),
        isA<UserProfileLoaded>(),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.fetchProfile();
    });

    test('should emit [UserProfileLoading, UserProfileFailure] when unsuccessful', () async {
      when(mockGetUserProfileUseCase()).thenAnswer(
        (_) async => Left(Failure(message: 'Fetch failed')),
      );

      final expectedStates = [
        isA<UserProfileLoading>(),
        isA<UserProfileFailure>(),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.fetchProfile();
    });
  });

  group('edit profile', () {
    test('should change state to UserProfileEditing when enterEditMode is called', () {
      cubit.emit(UserProfileLoaded(tProfile));
      cubit.enterEditMode();

      expect(cubit.state, isA<UserProfileEditing>());
      final editingState = cubit.state as UserProfileEditing;
      expect(editingState.draftName, equals('John Doe'));
      expect(editingState.draftBirthdate, equals('1995-05-15'));
    });

    test('should discard draft and emit UserProfileLoaded when exitEditMode is called', () {
      cubit.emit(UserProfileEditing(
        originalProfile: tProfile,
        draftName: 'Jane Doe',
        draftBirthdate: '2000-01-01',
      ));
      cubit.exitEditMode();

      expect(cubit.state, isA<UserProfileLoaded>());
      final loadedState = cubit.state as UserProfileLoaded;
      expect(loadedState.profile, equals(tProfile));
    });
  });

  group('saveProfile', () {
    test('should emit [UserProfileSaving, UserProfileLoaded] when save is successful', () async {
      cubit.emit(UserProfileEditing(
        originalProfile: tProfile,
        draftName: 'Jane Doe',
        draftBirthdate: '1995-05-15',
      ));

      when(mockUpdateUserProfileUseCase(
        name: 'Jane Doe',
        birthdate: '1995-05-15',
        photoUrl: 'https://example.com/photo.jpg',
      )).thenAnswer((_) async => Right(tProfile.copyWith(name: 'Jane Doe')));

      final expectedStates = [
        isA<UserProfileSaving>(),
        isA<UserProfileLoaded>(),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.saveProfile();
    });

    test('should validate empty name and emit error without saving', () async {
      cubit.emit(UserProfileEditing(
        originalProfile: tProfile,
        draftName: '',
        draftBirthdate: '1995-05-15',
      ));

      final expectedStates = [
        isA<UserProfileFailure>(),
        isA<UserProfileEditing>(),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.saveProfile();
      verifyZeroInteractions(mockUpdateUserProfileUseCase);
    });

    test('should upload photo if local photo selected', () async {
      final localBytes = Uint8List.fromList([1, 2, 3]);
      cubit.emit(UserProfileEditing(
        originalProfile: tProfile,
        draftName: 'John Doe',
        draftBirthdate: '1995-05-15',
        localPhotoBytes: localBytes,
        localPhotoName: 'test.png',
        localPhotoContentType: 'image/png',
      ));

      when(mockUploadService.upload(
        fileBytes: localBytes,
        fileName: 'test.png',
        contentType: 'image/png',
      )).thenAnswer((_) async => 'https://example.com/new_photo.jpg');

      when(mockUpdateUserProfileUseCase(
        name: 'John Doe',
        birthdate: '1995-05-15',
        photoUrl: 'https://example.com/new_photo.jpg',
      )).thenAnswer((_) async => Right(tProfile.copyWith(photoUrl: 'https://example.com/new_photo.jpg')));

      await cubit.saveProfile();

      verify(mockUploadService.upload(
        fileBytes: localBytes,
        fileName: 'test.png',
        contentType: 'image/png',
      ));
    });
  });
}
