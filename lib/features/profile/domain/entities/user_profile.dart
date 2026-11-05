class UserProfile {
  final String id;
  final String name;
  final String? birthdate;
  final String? photoUrl;

  const UserProfile({
    required this.id,
    required this.name,
    this.birthdate,
    this.photoUrl,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? birthdate,
    String? photoUrl,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      birthdate: birthdate ?? this.birthdate,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
