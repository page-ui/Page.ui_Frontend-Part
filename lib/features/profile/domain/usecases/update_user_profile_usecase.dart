import 'package:dartz/dartz.dart';
import 'package:page_ui/core/errors/failure.dart';
import 'package:page_ui/features/profile/domain/entities/user_profile.dart';
import 'package:page_ui/features/profile/domain/repositories/profile_repository.dart';

class UpdateUserProfileUseCase {
  final ProfileRepository profileRepository;

  UpdateUserProfileUseCase({required this.profileRepository});

  Future<Either<Failure, UserProfile>> call({
    required String name,
    String? birthdate,
    String? photoUrl,
  }) {
    return profileRepository.updateUserProfile(
      name: name,
      birthdate: birthdate,
      photoUrl: photoUrl,
    );
  }
}
