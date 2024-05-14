import 'package:flutter/material.dart';
import 'package:your_eyes/shared_preferences.dart';
import 'package:your_eyes/splashscreen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await cachHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
     // home: SplashScreen(),
      home: SplashScreen(),
    );
  }
}

