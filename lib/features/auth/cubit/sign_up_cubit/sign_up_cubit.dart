import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:road_sense_app/config/app_config.dart';
import 'package:road_sense_app/features/auth/actions/domain/entities/user_entity.dart';
import 'package:road_sense_app/features/auth/actions/domain/repo/auth_repo.dart';

part 'sign_up_state.dart';

class AuthCubit extends Cubit<AuthState> {
  static AuthCubit get to => getIt.get();
  AuthCubit(this.authRepo) : super(AuthInitial());

  final AuthRepo authRepo;
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    emit(AuthLoading());
    final result = await authRepo.createUserWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );

    result.fold((failure) {
      emit(AuthFailure(failure.message));
      log('SignUp Failure: ${failure.message}');
    }, (userEntity) => emit(AuthSuccess(userEntity)));
  }

  Future<void> SignIn({required String email, required String password}) async {
    emit(AuthLoading());
    final result = await authRepo.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    result.fold((failure) {
      emit(AuthFailure(failure.message));
      log('SignIn Failure: ${failure.message}');
    }, (userEntity) => emit(AuthSuccess(userEntity)));
  }
}
