class AppUser {
  final String id;
  final String name;
  final String email;
  final String? profilePicture;
  final DateTime joiningDate;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture,
    required this.joiningDate,
  });

  AppUser copyWith({
    String? name,
    String? email,
    String? profilePicture,
    DateTime? joiningDate,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      joiningDate: joiningDate ?? this.joiningDate,
    );
  }
}
