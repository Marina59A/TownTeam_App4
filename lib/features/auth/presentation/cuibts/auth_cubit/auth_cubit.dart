import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:townteam_app/features/auth/domain/entites/user_entity.dart';
import 'package:townteam_app/features/auth/domain/repos/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  Future<void> signUp({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    emit(AuthLoading());
    final result = await authRepo.createUserWithEmailAndPassword(
      email,
      password,
      confirmPassword,
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final result = await authRepo.signInWithEmailAndPassword(
      email,
      password,
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  void logout() {
    emit(AuthInitial());
  }
}
