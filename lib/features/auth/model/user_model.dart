// class UserModel {
//   final String uid;
//   final String name;
//   final String email;

//   UserModel({
//     required this.uid,
//     required this.name,
//     required this.email,
//   });

//   // Convert UserModel into Map
//   Map<String, dynamic> toMap() {
//     return {
//       'uid': uid,
//       'name': name,
//       'email': email,
//     };
//   }

//   // Convert Map into UserModel
//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       uid: map['uid'] ?? '',
//       name: map['name'] ?? '',
//       email: map['email'] ?? '',
//     );
//   }
// }
class UserModel {
  final String uid;
  final String name;
  final String email;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
  });

  // Convert UserModel into Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
    };
  }

  // Convert Map into UserModel
  factory UserModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }
}