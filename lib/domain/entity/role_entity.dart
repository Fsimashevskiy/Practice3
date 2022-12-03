class RoleEntity {
  int? id;
  late String role;

  RoleEntity({required this.role});
}
enum RoleEnum {
  anonymous(
    id: 0,
    role: 'anonymous',
  ),
  admin(
    id: 1,
    role: 'Администратор',
  ),
  user(
    id: 2,
    role: 'Клиент',
  );

  const RoleEnum({
    required this.id,
    required this.role,
  });

  final int id;
  final String role;
}