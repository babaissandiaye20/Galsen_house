import 'role.dart';

class User {
  final int id;
  final String prenom;
  final String nom;
  final String? region;
  final String? commune;
  final String email;
  final String password;
  final String? telephone;
  final Role role;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.prenom,
    required this.nom,
    this.region,
    this.commune,
    required this.email,
    required this.password,
    this.telephone,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      prenom: json['prenom'] as String,
      nom: json['nom'] as String,
      region: json['region'] as String?,
      commune: json['commune'] as String?,
      email: json['email'] as String,
      password: json['password'] as String,
      telephone: json['telephone'] as String?,
      role: Role.fromJson(json['role'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prenom': prenom,
      'nom': nom,
      'region': region,
      'commune': commune,
      'email': email,
      'password': password,
      'telephone': telephone,
      'role': role.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get fullName => '$prenom $nom';

  bool get isProprietaire => role.name == RoleType.PROPRIETAIRE;
  bool get isClient => role.name == RoleType.CLIENT;
  bool get isAdmin => role.name == RoleType.ADMIN;

  User copyWith({
    int? id,
    String? prenom,
    String? nom,
    String? region,
    String? commune,
    String? email,
    String? password,
    String? telephone,
    Role? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      prenom: prenom ?? this.prenom,
      nom: nom ?? this.nom,
      region: region ?? this.region,
      commune: commune ?? this.commune,
      email: email ?? this.email,
      password: password ?? this.password,
      telephone: telephone ?? this.telephone,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, fullName: $fullName, email: $email, role: ${role.name}}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
