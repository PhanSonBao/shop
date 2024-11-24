import 'package:flutter/material.dart';
import 'package:shop/entry_point.dart';
import 'package:shop/route/router.dart' as router;
import 'package:shop/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/route/screen_export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop Template by The Flutter Way',
      theme: AppTheme.lightTheme(context),
      themeMode: ThemeMode.light,
      // Use a StreamBuilder to listen to Firebase Auth state changes
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Check if the authentication state is ready
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            if (user == null) {
              return const OnBordingScreen();
            } else {
              return const EntryPoint(); // Replace with your home screen widget
            }
          }

          // While waiting for the authentication state to be ready, show a loading indicator
          return const Center(child: CircularProgressIndicator());
        },
      ),
      onGenerateRoute: router.generateRoute,
    );
  }
}
