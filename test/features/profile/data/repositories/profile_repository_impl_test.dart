import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:page_ui/core/errors/exceptions.dart';
import 'package:page_ui/core/errors/failure.dart';
import 'package:page_ui/core/errors/error_model.dart';
import 'package:page_ui/core/errors/app_operation.dart';
import 'package:page_ui/core/network/network_info.dart';
import 'package:page_ui/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:page_ui/features/profile/data/models/user_profile_model.dart';
import 'package:page_ui/features/profile/data/repositories/profile_repository_impl.dart';

import 'profile_repository_impl_test.mocks.dart';

@GenerateMocks([ProfileRemoteDataSource, NetworkInfo])
void main() {
  late ProfileRepositoryImpl repository;
  late MockProfileRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockProfileRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProfileRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tProfileModel = UserProfileModel(
    id: 'user_123',
    name: 'John Doe',
    birthdate: '1995-05-15',
    photoUrl: 'https://example.com/photo.jpg',
  );

  group('getUserProfile', () {
    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getUserProfile()).thenAnswer((_) async => tProfileModel);

      await repository.getUserProfile();

      verify(mockNetworkInfo.isConnected);
    });

    test('should return remote data when the call is successful', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getUserProfile()).thenAnswer((_) async => tProfileModel);

      final result = await repository.getUserProfile();

      verify(mockRemoteDataSource.getUserProfile());
      expect(result, equals(const Right(tProfileModel)));
    });

    test('should return ServerFailure when the call is unsuccessful', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getUserProfile()).thenThrow(
        ServerException(
          ErrorModel(status: 500, errorMessage: 'Internal Server Error'),
          operation: AppOperation.generic,
        ),
      );

      final result = await repository.getUserProfile();

      verify(mockRemoteDataSource.getUserProfile());
      expect(result.isLeft(), true);
    });

    test('should return NetworkFailure when offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.getUserProfile();

      verifyNoMoreInteractions(mockRemoteDataSource);
      expect(result.isLeft(), true);
    });
  });

  group('updateUserProfile', () {
    test('should return updated profile when repository call is successful', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.updateUserProfile(
        name: 'John Doe',
        birthdate: '1995-05-15',
        photoUrl: 'https://example.com/photo.jpg',
      )).thenAnswer((_) async => tProfileModel);

      final result = await repository.updateUserProfile(
        name: 'John Doe',
        birthdate: '1995-05-15',
        photoUrl: 'https://example.com/photo.jpg',
      );

      verify(mockRemoteDataSource.updateUserProfile(
        name: 'John Doe',
        birthdate: '1995-05-15',
        photoUrl: 'https://example.com/photo.jpg',
      ));
      expect(result, equals(const Right(tProfileModel)));
    });
  });
}
