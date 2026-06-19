import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rawg_app/app/constants/firebase_constants.dart';
import 'package:rawg_app/app/theme/app_theme.dart';
import 'package:rawg_app/firebase_options.dart';
import 'package:rawg_app/presentation/pages/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GoogleSignIn.instance.initialize(
    serverClientId: FirebaseConstants.googleWebClientId,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RAWG',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      builder: (context, child) {
        return DefaultTextStyle.merge(
          style: const TextStyle(fontFamily: AppTheme.fontFamily),
          child: child!,
        );
      },
      home: const AuthGate(),
    );
  }
}
