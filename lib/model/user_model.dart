enum UserRole {
  client,
  admin,
}

class User {
  final String id;
  final String? userName;
  final String? email;
  final String? password;
  final UserRole role; // Make sure role is not nullable
  final int? latitudeUser;
  final int? longitudeUser;
  final String? numeroTel;

  User({
    required this.id,
    this.userName,
    this.email,
    this.password,
    required this.role, // Make role required in the constructor
    this.latitudeUser,
    this.longitudeUser,
    this.numeroTel,
  });

  factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['_id'] as String,
    userName: json['UserName'] as String?,
    email: json['email'] as String?,
    password: json['password'] as String?,
    role: (json['Role'] != null)
        ? UserRole.values.firstWhere(
            (element) => element.toString() == json['Role'],
            orElse: () => UserRole.admin,
          )
        : UserRole.admin,
    latitudeUser: json['latitudeUser'] as int?,
    longitudeUser: json['longitudeUser'] as int?,
    numeroTel: json['numeroTel'] as String?,
  );
}


  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'UserName': userName,
      'email': email,
      'password': password,
      'Role': role.toString(),
      'latitudeUser': latitudeUser,
      'longitudeUser': longitudeUser,
      'numeroTel': numeroTel,
    };
  }

  @override
  String toString() {
    return 'User(id: $id, userName: $userName, email: $email, password: $password, role: $role, latitudeUser: $latitudeUser, longitudeUser: $longitudeUser, numeroTel: $numeroTel)';
  }
}
