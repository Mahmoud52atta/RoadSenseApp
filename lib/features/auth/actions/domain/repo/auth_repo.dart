import 'package:dartz/dartz.dart';
import 'package:road_sense_app/core/errors/failuers.dart';
import 'package:road_sense_app/features/auth/actions/domain/entities/user_entity.dart';

abstract class AuthRepo {
  Future<Either<Failuers, UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
  });

  Future<Either<Failuers, UserEntity>> signInWithEmailAndPassword({
    String email,
    String password,
  });
}
