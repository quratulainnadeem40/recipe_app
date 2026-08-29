class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? profileImage;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profileImage,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? profileImage,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileImage': profileImage,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileImage: map['profileImage'],
    );
  }
}
