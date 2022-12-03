import 'package:dartz/dartz.dart';
import 'package:flutter_auth/domain/entity/role_entity.dart';

abstract class AuthUseCase<String, Params> {
  Future<Either<String, RoleEnum>> singIn(Params params);
  Future<Either<String, bool>> signUp(Params params);
}
