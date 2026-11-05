import 'package:dartz/dartz.dart';
import 'package:page_ui/core/errors/failure.dart';
import 'package:page_ui/features/profile/domain/entities/user_profile.dart';
import 'package:page_ui/features/profile/domain/repositories/profile_repository.dart';

class GetUserProfileUseCase {
  final ProfileRepository profileRepository;

  GetUserProfileUseCase({required this.profileRepository});

  Future<Either<Failure, UserProfile>> call() {
    return profileRepository.getUserProfile();
  }
}
