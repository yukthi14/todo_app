import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants/colors.dart';

import '../constants/strings.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
          backgroundColor: AppColors.appBarColor,
          title: const Text(
            Strings.loginText,
            style: TextStyle(
                fontSize: 20,
                color: AppColors.white,
                fontWeight: FontWeight.w500),
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: Strings.emailText,
                  labelStyle: const TextStyle(color: AppColors.appBarColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.appBarColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 12.0,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Strings.enterEmail;
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: Strings.passwordText,
                  labelStyle: const TextStyle(color: AppColors.appBarColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.appBarColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 12.0,
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Strings.enterPassword;
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try {
                      await authService.signInWithEmailAndPassword(
                          _email, _password);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(Strings.loginFailed)));
                    }
                  }
                },
                child: const Text(
                  Strings.loginText,
                  style: TextStyle(color: AppColors.appBarColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: const Text(Strings.registerText,
                    style: TextStyle(color: AppColors.appBarColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
