class User {
  final String imagePath;
  final String name;
  final String email;
  final String phoneNumber;
  final String about;

  User(
      {required this.imagePath,
      required this.name,
      required this.email,
      required this.phoneNumber,
      required this.about});

  User copy({
    String? imagePath,
    String? name,
    String? email,
    String? phoneNumber,
    String? about,
  }) =>
      User(
          imagePath: imagePath ?? this.imagePath,
          name: name ?? this.name,
          email: email ?? this.email,
          phoneNumber: phoneNumber ?? this.phoneNumber,
          about: about ?? this.about);

  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'about': about,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        imagePath: json['imagePath'],
        name: json['name'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        about: json['about'],
      );
}
