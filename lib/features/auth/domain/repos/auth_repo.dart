import 'package:dartz/dartz.dart';
import 'package:townteam_app/common/errors/failures.dart';
import 'package:townteam_app/features/auth/domain/entites/user_entity.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
     String email, String password, String confirmPassword);
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
      String email, String password);
}