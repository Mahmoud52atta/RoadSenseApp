import 'package:dartz/dartz.dart';
import 'package:road_sense_app/core/errors/exceptions.dart';
import 'package:road_sense_app/core/errors/failuers.dart';
import 'package:road_sense_app/core/services/firebase_auth_service.dart';
import 'package:road_sense_app/features/auth/actions/data/models/user_model.dart';
import 'package:road_sense_app/features/auth/actions/domain/entities/user_entity.dart';
import 'package:road_sense_app/features/auth/actions/domain/repo/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;

  AuthRepoImpl({required this.firebaseAuthService});
  @override
  Future<Either<Failuers, UserEntity>> createUserWithEmailAndPassword({
    String? email,
    String? password,
    String? name,
    String? phone,
  }) async {
    try {
      var user = await firebaseAuthService.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      return right(UserModel.fromFirebaseUser(user));
    } on ServerException catch (e) {
      return left(ServerFailuer(e.message));
    } catch (e) {
      return left(ServerFailuer('An unknown error occurred,try again later.'));
    }
  }

  @override
  Future<Either<Failuers, UserEntity>> signInWithEmailAndPassword({
    String? email,
    String? password,
  }) async {
    try {
      var user = await firebaseAuthService.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      return right(UserModel.fromFirebaseUser(user));
    } on ServerException catch (e) {
      return left(ServerFailuer(e.message));
    } catch (e) {
      return left(ServerFailuer('An unknown error occurred,try again later.'));
    }
  }
}
