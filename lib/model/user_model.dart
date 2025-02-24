class UserModel {
  final String uid;
  final String email;
  final String username;
  final bool isOnline;
  final int lastActive;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.isOnline,
    required this.lastActive,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      isOnline: data['is_online'] == 'true',
      lastActive: int.parse(data['last_active'] ?? '0'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'is_online': isOnline.toString(),
      'last_active': lastActive.toString(),
    };
  }
}
