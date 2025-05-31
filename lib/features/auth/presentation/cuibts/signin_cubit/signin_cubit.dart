// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:townteam_app/features/auth/domain/entites/user_entity.dart';
import 'package:townteam_app/features/auth/domain/repos/auth_repo.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit(this.authRepo) : super(SigninInitial());
  final AuthRepo authRepo;

  Future<void> SigninUser(
    String name,
    String email,
  ) async {
    emit(SigninLoading());
    final result = await authRepo.signInWithEmailAndPassword(
      name,
      email,
    );
    result.fold(
      (failure) => emit(
        SigninFailure(
          message: failure.message,
        ),
      ),
      (userEntity) => emit(
        SigninSuccess(userEntity: userEntity),
      ),
    );
  }
}
