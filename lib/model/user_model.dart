enum UserRole {
  client,
  admin,
}

class User {
  final String? id;
  final String? userName;
  final String? email;
  final String? password;
  final String?role; // Change to String since it's expected to be a string
  final String? status;
  final int? latitudeUser;
  final int? longitudeUser;
  final String? numeroTel;

  User({
    required this.id,
    this.userName,
    this.email,
    this.password,
    this.role,
    this.status,
    this.latitudeUser,
    this.longitudeUser,
    this.numeroTel,
  });

  factory User.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return User(
        id: null,
        userName: null,
        email: null,
        password: null,
        role: "", // Default to an empty string if role is null
        status: '',
        latitudeUser: null,
        longitudeUser: null,
        numeroTel: null,
      );
    }

    return User(
      id: json['_id'] as String?,
      userName: json['UserName'] as String?,
      email: json['email'] as String? ?? "",
      password: json['password'] as String? ?? "",
      role: json['Role'] as String? ?? "", // Default to an empty string if role is null
      status: json['status'] as String? ?? '',
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
      'Role': role,
      'status': status,
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
