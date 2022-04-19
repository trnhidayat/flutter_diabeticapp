import 'package:flutter/material.dart';
import 'package:flutter_application_1/wrapper.dart';
import 'package:provider/provider.dart';
import 'auth_services.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
        value: AuthServices.firebaseUserStream,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
          ),
          home: Wrapper(),
        )
    );
  }
}