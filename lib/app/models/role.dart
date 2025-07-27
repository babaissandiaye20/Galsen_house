enum RoleType {
  CLIENT,
  PROPRIETAIRE,
  ADMIN,
}

class Role {
  final int id;
  final RoleType name;

  Role({
    required this.id,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] as int,
      name: RoleType.values.firstWhere(
        (e) => e.toString().split('.').last == json['name'],
        orElse: () => RoleType.CLIENT,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name.toString().split('.').last,
    };
  }

  @override
  String toString() {
    return 'Role{id: $id, name: $name}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Role && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

