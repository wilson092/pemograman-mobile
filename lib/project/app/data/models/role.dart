class Role {
  final int id;
  final String name;
  final String badge;
  final int userCount;
  final String description;
  final String permissionLabel;

  const Role({
    required this.id,
    required this.name,
    required this.badge,
    required this.userCount,
    required this.description,
    required this.permissionLabel,
  });

  Role copyWith({
    int? id,
    String? name,
    String? badge,
    int? userCount,
    String? description,
    String? permissionLabel,
  }) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      badge: badge ?? this.badge,
      userCount: userCount ?? this.userCount,
      description: description ?? this.description,
      permissionLabel: permissionLabel ?? this.permissionLabel,
    );
  }
}
