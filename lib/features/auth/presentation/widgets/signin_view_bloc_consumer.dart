import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:townteam_app/common/helper/const_function.dart';
import 'package:townteam_app/common/services/git_it_service.dart';
import 'package:townteam_app/common/utils/widgets/custom_progressHud.dart';
import 'package:townteam_app/features/auth/domain/repos/auth_repo.dart';
import 'package:townteam_app/features/auth/presentation/cuibts/signin_cubit/signin_cubit.dart';
import 'package:townteam_app/features/auth/presentation/widgets/signin_body.dart';

BlocProvider<SigninCubit> signinViewBlocConsumer() {
  return BlocProvider(
    create: (context) => SigninCubit(getIt.get<AuthRepo>()),
    child: Scaffold(
      body: BlocConsumer<SigninCubit, SigninState>(
        listener: (context, state) {
          if (state is SigninSuccess) {
            Navigator.pop(context); // Return to previous page (cart)
          }
          if (state is SigninFailure) {
            snackShow(context, state.message);
          }
        },
        builder: (context, state) {
          return CustomProgressHud(
              isLoading: state is SigninLoading ? true : false,
              child: const SignInBody());
        },
      ),
    ),
  );
}