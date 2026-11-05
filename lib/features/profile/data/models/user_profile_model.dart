import 'package:page_ui/features/profile/domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.name,
    super.birthdate,
    super.photoUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      birthdate: json['birthdate'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'birthdate': birthdate,
      'photoUrl': photoUrl,
    };
  }
}
