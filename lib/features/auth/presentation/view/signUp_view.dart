import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:townteam_app/common/services/git_it_service.dart';
import 'package:townteam_app/features/auth/domain/repos/auth_repo.dart';
import 'package:townteam_app/features/auth/presentation/cuibts/signup_cubit/signup_cubit.dart';
import 'package:townteam_app/features/auth/presentation/widgets/signup_view_body_bloc_consumr.dart';

class SignupView extends StatefulWidget {
  static const String id = 'signup_page';

  const SignupView({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SignupCubit(
              getIt<AuthRepo>(),
            ),
        child: Scaffold(
          body: Builder(builder: (context) {
            return const SignupViewBlocConsumer();
          }),
        ));
  }
}

// import 'package:flutter/material.dart';

// class SignupView extends StatefulWidget {
//   static const String id = 'signup_page';

//   const SignupView({super.key});
//   @override
//   _SignupPageState createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupView> {
//   final _formKey = GlobalKey<FormState>();

//   final nameController = TextEditingController();
//   final surnameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final repeatPasswordController = TextEditingController();

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       // Process registration
//       print('All fields are valid');
//     } else {
//       _showWarningDialog();
//     }
//   }

//   void _showWarningDialog() {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//         title: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.warning_amber_rounded, size: 48, color: Colors.orange),
//             SizedBox(height: 10),
//             Text('WARNING!'),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               "Please complete all fields to",
//               style: TextStyle(fontSize: 20),
//             ),
//             Text('continue.', style: TextStyle(fontSize: 20)),
//           ],
//         ),
//         actions: [
//           Center(
//             child: SizedBox(
//               width: double.infinity,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 child: MaterialButton(
//                   onPressed: () => Navigator.of(ctx).pop(),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   color: const Color.fromARGB(255, 26, 118, 29),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 12.0,
//                     ),
//                     child: Text(
//                       "OK",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextField(
//     TextEditingController controller,
//     String label,
//     bool obscureText,
//   ) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       style: TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: TextStyle(color: Colors.white),
//         enabledBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.grey[600]!),
//         ),
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.white),
//         ),
//       ),
//       validator: (value) {
//         if (value == null || value.trim().isEmpty) {
//           return 'Field is required';
//         }
//         return null;
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
//         child: Form(
//           key: _formKey,
//           autovalidateMode: AutovalidateMode.disabled,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 _buildTextField(nameController, 'NAME', false),
//                 SizedBox(height: 12),
//                 _buildTextField(surnameController, 'SURNAME', false),
//                 SizedBox(height: 12),
//                 _buildTextField(emailController, 'EMAIL', false),
//                 SizedBox(height: 12),
//                 _buildTextField(passwordController, 'PASSWORD', true),
//                 SizedBox(height: 12),
//                 _buildTextField(
//                     repeatPasswordController, 'REPEAT PASSWORD', true),
//                 SizedBox(height: 50),
//                 MaterialButton(
//                   onPressed: _submitForm,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   color: Colors.grey[900],
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 16.0),
//                     child: Text(
//                       "SIGN UP",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         letterSpacing: 1.5,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
