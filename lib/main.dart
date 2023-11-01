import 'package:firebase_core/firebase_core.dart';
import 'package:fitnutrition/services/current_date.dart';
import 'package:fitnutrition/services/firestore_db.dart';
import 'services/food_db.dart';
import 'package:flutter/material.dart';
import './screens/wrapper.dart';
import './services/auth.dart';
import 'package:provider/provider.dart';

import 'services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: FirestoreDb(),
        ),
        ChangeNotifierProvider.value(
          value: CurrentDateProvider(),
        ),
        ChangeNotifierProvider.value(
          value: FoodDB(),
        ),
        Provider(
          create: (_) => Auth(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blueAccent,
          secondaryHeaderColor: Colors.deepPurple,
          fontFamily: "OpenSans",
          textTheme: const TextTheme(
            bodyText1: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
          ),
        ),
        home: const Wrapper(),
      ),
    );
  }
}
