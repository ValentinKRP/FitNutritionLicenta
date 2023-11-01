import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnutrition/model/tracked_food.dart';
import 'package:flutter/material.dart';
import 'package:fitnutrition/services/current_date.dart';
import '../../model/mealmodel.dart';
import 'package:provider/provider.dart';

import '../../services/firestore_db.dart';

class MacroTile extends StatefulWidget {
  const MacroTile({Key? key}) : super(key: key);

  @override
  _MacroTileState createState() => _MacroTileState();
}

class _MacroTileState extends State<MacroTile> {
  String getMonth(String num) {
    switch (num) {
      case "01":
        {
          return "Jan";
        }
      case "02":
        {
          return "Feb";
        }
      case "03":
        {
          return "Mar";
        }
      case "04":
        {
          return "Apr";
        }
      case "05":
        {
          return "May";
        }
      case "06":
        {
          return "June";
        }
      case "07":
        {
          return "July";
        }
      case "08":
        {
          return "Aug";
        }
      case "09":
        {
          return "Sept";
        }
      case "10":
        {
          return "Oct";
        }
      case "11":
        {
          return "Nov";
        }
      default:
        {
          return "Dec";
        }
    }
  }

  String getFormattedDate(DateTime dateTime) {
    DateTime now = dateTime;
    DateTime date = DateTime(now.year, now.month, now.day);
    String dateString = date.toString();
    String year = dateString.substring(0, 4);
    String month = getMonth(dateString.substring(5, 7));
    String day = dateString.substring(8, 10);
    return month + " " + day + ", " + year;
  }

  bool showMacros = true;
  String macrosStatement = "Hide Macronutrients";
  String currDateTitleSt = "";
  DateTime currDateTitle = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final Stream<DocumentSnapshot<Map<String, dynamic>>> _usersStream =
        FirebaseFirestore.instance.collection('Tracker').doc(uid).snapshots();
    currDateTitleSt = Provider.of<CurrentDateProvider>(context).currentDateSt;
    currDateTitle = Provider.of<CurrentDateProvider>(context).currentDate;

    return SafeArea(
      child: StreamBuilder(
        stream: _usersStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          var userDocument = snapshot.data;
          var macros = userDocument!["personalNutrients"];
          List<MealModel> meals = [
            MealModel("", [TrackedFood("", "0.0", "0.0", "0.0", "0.0", "0.0")])
          ];

          var mealList = Provider.of<FirestoreDb>(context);
          String currDate =
              Provider.of<CurrentDateProvider>(context).currentDateSt;
          for (var meal in mealList.mealList) {
            if (meal.date == currDate) {
              meals.add(MealModel(meal.name, [
                TrackedFood(meal.name, meal.carbohydrates, meal.protein,
                    meal.fat, meal.serving, meal.unit)
              ]));
            }
          }

          var caloriesPerMeal =
              meals.map((meal) => meal.calculateCalories()).toList();
          var carbsPerMeal =
              meals.map((meal) => meal.calculateCarbs()).toList();
          var fatPerMeal = meals.map((meal) => meal.calculateFat()).toList();
          var proteinPerMeal =
              meals.map((meal) => meal.calculateProtein()).toList();

          double totalCalories =
              caloriesPerMeal.reduce((value, element) => value + element);
          double totalCarbs =
              carbsPerMeal.reduce((value, element) => value + element);
          double totalFat =
              fatPerMeal.reduce((value, element) => value + element);
          double totalProtein =
              proteinPerMeal.reduce((value, element) => value + element);

          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .3,
            padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
            child: Scaffold(
              body: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: dateAndArrows(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: calorieBar(totalCalories, macros),
                  ),
                  Container(
                    child: macroPanel(
                        totalCalories,
                        macros["calories"]!.round(),
                        "CAL",
                        Theme.of(context).primaryColor,
                        45),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        macroPanel(
                          totalCarbs,
                          macros["carbohydrates"]!.round(),
                          "CARBS",
                          Theme.of(context).secondaryHeaderColor,
                        ),
                        macroPanel(
                          totalProtein,
                          macros["protein"]!.round(),
                          "PRO",
                          Theme.of(context).secondaryHeaderColor,
                        ),
                        macroPanel(
                          totalFat,
                          macros["fat"]!.round(),
                          "FAT",
                          Theme.of(context).secondaryHeaderColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget calorieBar(double totalCalories, Map<String, dynamic> macros) {
    return Material(
      elevation: 5,
      child: Stack(
        children: <Widget>[
          Container(
            height: 10,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          Container(
            height: 10,
            width: (totalCalories / macros["calories"]!.round()) *
                (MediaQuery.of(context).size.width),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
        ],
      ),
      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
    );
  }

  Widget dateAndArrows() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            context.read<CurrentDateProvider>().timrPre();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.blueGrey,
          ),
        ),
        Text(
          getFormattedDate(currDateTitle),
          style: const TextStyle(
              fontSize: 20,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey),
        ),
        GestureDetector(
          onTap: () {
            context.read<CurrentDateProvider>().timrNext();
          },
          child: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }

  Widget macroPanel(double consumed, int total, String macro, Color color,
      [double? size]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          consumed.toInt().toString(),
          style: TextStyle(
              color: color, fontSize: size ?? 35, fontFamily: "OpenSans"),
        ),
        SizedBox(
          child: Column(
            children: <Widget>[
              Text(
                macro,
                textAlign: TextAlign.left,
                style: TextStyle(color: color, fontFamily: "OpenSans"),
              ),
              Text(
                "/" + total.toString(),
                textAlign: TextAlign.left,
                style: TextStyle(color: color, fontFamily: "OpenSans"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
