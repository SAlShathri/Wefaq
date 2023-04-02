import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wefaq/service/local_push_notification.dart';
import 'package:wefaq/splash.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //
  LocalNotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorSchemeSeed: const Color.fromARGB(255, 215, 189, 226),
          useMaterial3: true,
          brightness: Brightness.light),
      home: splash(),
    );
  }
}
