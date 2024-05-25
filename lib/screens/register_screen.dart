import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.white),
          backgroundColor: AppColors.appBarColor,
          title: const Text(
            Strings.registerText,
            style: TextStyle(
                fontSize: 20,
                color: AppColors.white,
                fontWeight: FontWeight.w500),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                      // Check if password is 6 characters long and email matches the @gmail.com pattern
                      if (_password.length != 6 ||
                          !_email.endsWith('@gmail.com')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Password must be 6 characters long and check email'),
                          ),
                        );
                      }
                      await authService.registerWithEmailAndPassword(
                          _email, _password);
                      Navigator.pop(
                          context); // Go back to login screen after successful registration
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registration Failed')));
                    }
                  }
                },
                child: const Text(
                  Strings.registerText,
                  style: TextStyle(color: AppColors.appBarColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
