import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitapp/auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage = "";
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: buildTitle(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isLogin)
              buildEntryField(title: 'name', controller: _controllerName),
            buildEntryField(
              title: 'email',
              controller: _controllerEmail,
            ),
            buildEntryField(title: 'password', controller: _controllerPassword, isPassword: true),
            buildErrorMessage(),
            buildSubmitButton(),
            buildSignUpOrSignIn(),
          ],
        ),
      ),
    );
  }

  Widget buildTitle() => const Text(
        'FitApp',
      );

  Widget buildEntryField({
    required String title,
    required TextEditingController controller,
    isPassword = false
  }) =>
      TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: title,
        ),
      );

  Widget buildErrorMessage() => Text(
        errorMessage ?? '',
      );

  Widget buildSubmitButton() => ElevatedButton(
        onPressed:
            isLogin ? signInWithEmailAndPassword : signUpWithEmailAndPassword,
        child: Text(
          isLogin ? 'Login' : 'Register',
        ),
      );

  Widget buildSignUpOrSignIn() => TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(
        isLogin ? 'Register instead' : 'Login instead',
      ));

  Future<void> signInWithEmailAndPassword() async {
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;
    try {
      await Auth().signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> signUpWithEmailAndPassword() async {
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;
    String name = _controllerName.text;
    try {
      await Auth().signUpWithEmailAndPassword(email: email, password: password);
      final user = FirebaseAuth.instance.currentUser!;
      user.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }
}
