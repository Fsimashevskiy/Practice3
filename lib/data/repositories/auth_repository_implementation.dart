import 'package:dartz/dartz.dart';
import 'package:flutter_auth/data/model/Sotrudnik.dart';
import 'package:flutter_auth/domain/repositories/auth_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../../common/data_base_request.dart';
import '../../core/db/data_base_helper.dart';
import '../../domain/entity/role_entity.dart';

class AuthRepositoryImplementation implements AuthRepository {
  final _db = DataBaseHelper.instance.dataBase;

  String table = DataBaseRequest.tableUsers;

  @override
  Future<Either<String, RoleEnum>> signIn(String login, String password) async {
    try {
      var user = await _db.query(
        table,
        where: 'login = ?',
        whereArgs: [login],
      );

      if (user.isEmpty) {
        return Left('There is no such user');
      }

      if (user.first['password'] != password) {
        return Left('User password is incorrect');
      }

      return Right(RoleEnum.values[(user.first['roleId'] as int)]);
    } on DatabaseException catch (error) {
      return Left(error.result.toString());
    }
  }

  @override
  Future<Either<String, bool>> signUp(String login, String password) async {
    try {
      _db.insert(
          table,
          User(
                  login: login,
                  password: password,
                  roleId: RoleEnum.user.id,
                  name: "default2",
                  surname: "default2",
                  patronymic: "default2",
                  phoneNumber: "default2",
                  email: "default2")
              .toMap());
      return Right(true);
    } on DatabaseException catch (e) {
      return Left("Error");
    }
  }

  @override
  Future<Either<String, bool>> checkLoginExists(String login) async {
    try {
      var user = await _db.query(
        table,
        where: 'login = ?',
        whereArgs: [login],
      );
      if (user.isEmpty) {
        return Left('There is no such user');
      }
      return Right(true);
    } on DatabaseException catch (e) {
      return Left("Error");
    }
  }
}
