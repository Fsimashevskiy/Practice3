import 'package:flutter_auth/domain/entity/Sotrudnik_entity.dart';

import '../../domain/entity/role_entity.dart';

class User extends UserEntity {
  int? id;
  late String name;
  late String surname;
  late String patronymic;
  late String login;
  late String password;
  late int roleId;
  late String phoneNumber;
  late String email;

  User(
      {required this.name,
      required this.surname,
      required this.patronymic,
      required this.login,
      required this.password,
      required this.phoneNumber,
      required this.email,
      required this.roleId})
      : super(
            name: name,
            surname: surname,
            patronymic: patronymic,
            login: login,
            password: password,
            roleId: roleId,
            phoneNumber: phoneNumber,
            email: email);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'patronymic': patronymic,
      'login': login,
      'password': password,
      'roleId': roleId,
      'phoneNumber': phoneNumber,
      'email': email
    };
  }

  factory User.toFromMap(Map<String, dynamic> json) {
    return User(
        name: json['name'],
        surname: json['surname'],
        patronymic: json['patronymic'],
        login: json['login'],
        password: json['password'],
        roleId: RoleEnum.values
            .firstWhere(
              (element) => element.id == (json['roleId'] as int),
            )
            .id,
        phoneNumber: json['phoneNumber'],
        email: json['email']);
  }
}
