import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:townteam_app/features/auth/presentation/cuibts/signup_cubit/signup_cubit.dart';
import 'package:townteam_app/features/auth/presentation/view/login_page.dart';
import 'package:townteam_app/features/auth/presentation/widgets/signup_body.dart';

class SignupViewBlocConsumer extends StatelessWidget {
  const SignupViewBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          Navigator.of(context).pushReplacementNamed(LoginPage.id);
        } else if (state is SignupFailure) {
          print('Signup Failure: ${state.message}'); 
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is SignupLoading,
          child: const SignUpBody(),
        );
      },
    );
  }
}