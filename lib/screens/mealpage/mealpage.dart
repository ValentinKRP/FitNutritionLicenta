import 'package:fitnutrition/services/firestore_db.dart';
import 'package:flutter/material.dart';
import './macrostile.dart';
import './meallist.dart';
import 'package:provider/provider.dart';

class MealPage extends StatefulWidget {
  const MealPage({Key? key}) : super(key: key);

  @override
  _MealPage createState() => _MealPage();
}

class _MealPage extends State<MealPage> {
  @override
  Widget build(BuildContext context) {
    Provider.of<FirestoreDb>(context, listen: false).getPerson();
    Provider.of<FirestoreDb>(context, listen: false).getMeals();
    Provider.of<FirestoreDb>(context, listen: false).getMealsUser();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: const <Widget>[
            MacroTile(),
            MealList(),
          ],
        ),
      ),
    );
  }
}
