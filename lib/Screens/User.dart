
class User {
  late String name;
  late String gender;
  late String email;
  late String studentId;
  late int level;
  late String password;
  late String profilePhotoUrl; // Now optional

  User({
    required this.name,
    required this.gender,
    required this.email,
    required this.studentId,
    required this.level,
    required this.password,
    this.profilePhotoUrl = '', // Default value
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'email': email,
      'student_id': studentId,
      'level': level,
      'password': password,
      'profile_photo_url': profilePhotoUrl, // Include profile photo URL
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      gender: map['gender'],
      email: map['email'],
      studentId: map['student_id'],
      level: map['level'],
      password: map['password'],
      profilePhotoUrl: map['profile_photo_url'] ?? '', // Assign profile photo URL
    );
  }

  void updateDetails({
    String? name,
    String? gender,
    String? email,
    String? studentId,
    int? level,
    String? password,
    String? profilePhotoUrl, // Update profile photo URL
  }) {
    if (name != null) this.name = name;
    if (gender != null) this.gender = gender;
    if (email != null) this.email = email;
    if (studentId != null) this.studentId = studentId;
    if (level != null) this.level = level;
    if (password != null) this.password = password;
    if (profilePhotoUrl != null) this.profilePhotoUrl = profilePhotoUrl;
  }

  void updateProfilePhotoUrl(String url) {
    this.profilePhotoUrl = url;
  }
}
