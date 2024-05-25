import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:todo_app/constants/colors.dart';

import 'model/task_model.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyDj78ksshOf2ThyFKpu9FDdPwsS8S0TOGM',
    appId: '1:744851389631:android:76d1383a9594caccac5a0a',
    projectId: 'todo-app-a8a78',
    messagingSenderId: '',
  ));
  tz.initializeTimeZones();
  NotificationService().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => TaskService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager',
        theme: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppColors.appBarColor, // Set cursor color here
          ),
        ),
        home: Consumer<AuthService>(
          builder: (context, authService, _) {
            switch (authService.status) {
              case AuthStatus.authenticated:
                return HomeScreen();
              default:
                return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
