import 'package:flutter/material.dart';
import 'package:townteam_app/features/auth/presentation/widgets/signin_view_bloc_consumer.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login_page';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return signinViewBlocConsumer();
  }
}
