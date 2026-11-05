import 'package:dartz/dartz.dart';
import 'package:page_ui/core/errors/failure.dart';
import 'package:page_ui/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfile>> getUserProfile();
  Future<Either<Failure, UserProfile>> updateUserProfile({
    required String name,
    String? birthdate,
    String? photoUrl,
  });
}
