import 'package:firebase_auth/firebase_auth.dart';
import 'package:road_sense_app/core/errors/exceptions.dart';

class FirebaseAuthService {
  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw ServerException('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw ServerException('The account already exists for that email.');
      } else {
        throw ServerException(
          e.message ?? 'An unknown error occurred,try again later.',
        );
      }
    } catch (e) {
      throw ServerException('An unknown error occurred,try again later.');
    }
  }

  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw ServerException('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw ServerException('Wrong password provided for that user.');
      } else {
        throw ServerException(
          e.message ?? 'An unknown error occurred,try again later.',
        );
      }
    } catch (e) {
      throw ServerException('An unknown error occurred,try again later.');
    }
  }
}
