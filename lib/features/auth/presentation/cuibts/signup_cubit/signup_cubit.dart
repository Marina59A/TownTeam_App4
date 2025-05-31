// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:townteam_app/features/auth/domain/entites/user_entity.dart';
import 'package:townteam_app/features/auth/domain/repos/auth_repo.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this.authRepo) : super(SignupInitial());

  final AuthRepo authRepo;

  Future<void> createUserWithEmailAndPassword(
    // String name,
    // String surname,
    String email,
    String password, 
    String confirmPassword,
  ) async {
    emit(SignupLoading());
    final result = await authRepo.createUserWithEmailAndPassword(
      // name,
      // surname,
      email,
      password,
      confirmPassword,
    );
    result.fold(
      (failure) => emit(
        SignupFailure(
          message: failure.message,
        ),
      ),
      (userEntity) => emit(
        SignupSuccess(userEntity: userEntity),
      ),
    );
  }
}
