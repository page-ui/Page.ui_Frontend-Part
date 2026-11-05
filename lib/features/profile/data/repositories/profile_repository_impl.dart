import 'package:dartz/dartz.dart';
import 'package:page_ui/core/errors/exceptions.dart';
import 'package:page_ui/core/errors/failure.dart';
import 'package:page_ui/core/network/network_info.dart';
import 'package:page_ui/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:page_ui/features/profile/domain/entities/user_profile.dart';
import 'package:page_ui/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure.error());
    }

    try {
      final remoteProfile = await remoteDataSource.getUserProfile();
      return Right(remoteProfile);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateUserProfile({
    required String name,
    String? birthdate,
    String? photoUrl,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure.error());
    }

    try {
      final updatedProfile = await remoteDataSource.updateUserProfile(
        name: name,
        birthdate: birthdate,
        photoUrl: photoUrl,
      );
      return Right(updatedProfile);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
