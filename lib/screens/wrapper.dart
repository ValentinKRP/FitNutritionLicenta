import 'package:fitnutrition/services/auth.dart';
import 'package:flutter/material.dart';
import '../screens/main/bottomnav.dart';
import 'package:provider/provider.dart';
import 'authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: context.read<Auth>().authStateChanged,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor),
              ),
            );
          }

          if (snapshot.data != null) {
            return const BottomNav();
          }
          return const Authenticate();
        });
  }
}
