import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:fivoza_learning/core/common/app/providers/password_provider.dart';
import 'package:fivoza_learning/core/common/app/providers/user_provider.dart';
import 'package:fivoza_learning/core/res/colours.dart';
import 'package:fivoza_learning/core/res/fonts.dart';
import 'package:fivoza_learning/core/services/injection_container.dart';
import 'package:fivoza_learning/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/services/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PasswordProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Fivoza Learning',
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch(accentColor: Colours.primaryColour),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: Fonts.poppins,
          appBarTheme: const AppBarTheme(color: Colors.transparent),
        ),
        onGenerateRoute: generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
