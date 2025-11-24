class AppUser {
  final String uid;
  final String email;
  final String name;
  final String phone;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
  });

  // تحويل إلى Json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
    };
  }

  // تحميل من Firebase
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
