import 'package:fitnutrition/services/firestore_db.dart';
import 'package:flutter/material.dart';
import '../../model/meal_model2.dart';
import '../../model/tracked_food.dart';
import '../../services/current_date.dart';

import 'package:provider/provider.dart';

class FoodPage extends StatefulWidget {
  final String mealName;
  final MealModel2 food;
  final List<MealModel2>? meals;
  final bool? isSearch;

  const FoodPage(this.mealName, this.food, this.meals,
      {this.isSearch, Key? key})
      : super(key: key);
  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final _foodFormKey = GlobalKey<FormState>();
  double userInputServing = 1.0;
  var dropDownValue = "g";
  var dropDownValues = <String>[];
  List<MealModel2> meals = [];

  @override
  Widget build(BuildContext context) {
    var mealUserListprovider = Provider.of<FirestoreDb>(context, listen: true);
    meals = mealUserListprovider.mealListUser;
    TrackedFood food = TrackedFood(
        widget.food.name,
        widget.food.carbohydrates,
        widget.food.protein,
        widget.food.fat,
        widget.food.serving,
        widget.food.unit);

    var foodMap = food.toMap();
    String carbsPerServing =
        foodMap.containsKey('carbohydrates') ? foodMap['carbohydrates'] : "0";
    String fatPerServing = foodMap.containsKey('fat') ? foodMap['fat'] : "0";
    String proteinPerServing =
        foodMap.containsKey('protein') ? foodMap['protein'] : "0";

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text(
          widget.food.name,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: "OpenSans",
            fontSize: 25,
          ),
        ),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // ignore: prefer_const_constructors
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
          ),
          Form(
            key: _foodFormKey,
            child: form(carbsPerServing, fatPerServing, proteinPerServing),
          ),
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                )),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .60,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8.0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(40.0),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Daily Value",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        ),
                        Column(
                          children: nutritionTiles(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> nutritionTiles() {
    var widgets = <Widget>[];
    TrackedFood food = TrackedFood(
        widget.food.name,
        widget.food.carbohydrates,
        widget.food.protein,
        widget.food.fat,
        widget.food.serving,
        widget.food.unit);
    for (int i = 0; i < food.toMap().length; i++) {
      List<String> name =
          food.toMap().keys.map((name) => name.toString()).toList();
      List<String> val =
          food.toMap().values.map((val) => val.toString()).toList();
      widgets.add(
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: Text(name[i])),
              Expanded(child: Text(val[i])),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  List<String> appropriateDropDownvalues() {
    TrackedFood food = TrackedFood(
        widget.food.name,
        widget.food.carbohydrates,
        widget.food.protein,
        widget.food.fat,
        widget.food.serving,
        widget.food.unit);
    if (food.unit == "g" || food.unit == "oz") {
      return ["g", "serving"];
    } else {
      return ["cups", "mL", "tsp", "tbsp", "serving"];
    }
  }

  Widget form(
      String carbsPerServing, String fatPerServing, String proteinPerServing) {
    dropDownValues = appropriateDropDownvalues();
    return SizedBox(
      width: MediaQuery.of(context).size.width * .7,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              macroDisplay("Carbs", carbsPerServing),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        initialValue: "1",
                        keyboardType: TextInputType.number,
                        onChanged: (String? value) {
                          if (value == null) {
                            setState(() {
                              userInputServing = 0.0;
                            });
                          } else {
                            setState(() {
                              userInputServing = double.parse(value);
                            });
                          }
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: dropDownValue,
                          labelStyle: const TextStyle(
                              color: Colors.black, fontFamily: "OpenSans"),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              macroDisplay("Protein", proteinPerServing),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      "Unit",
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.black,
                          fontSize: 15),
                    ),
                    DropdownButton(
                      underline: Container(
                        color: Colors.black,
                      ),
                      value: dropDownValue,
                      onChanged: (String? unit) {
                        setState(() {
                          dropDownValue = unit!;
                        });
                      },
                      items: dropDownValues
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              macroDisplay("Fat", fatPerServing),
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    if (_foodFormKey.currentState!.validate()) {
                      String currDate =
                          context.read<CurrentDateProvider>().currentDateSt;
                      var foods = widget.food;

                      double cal;

                      if (dropDownValue == "g") {
                        cal = (double.parse(foods.carbohydrates) *
                                        userInputServing /
                                        double.parse(foods.serving) +
                                    double.parse(foods.protein) *
                                        userInputServing /
                                        double.parse(foods.serving)) *
                                4.0 +
                            double.parse(foods.fat) *
                                userInputServing /
                                double.parse(foods.serving) *
                                9.0;
                        context.read<FirestoreDb>().createNewMeals(MealModel2(
                            calories: (cal / double.parse(foods.serving))
                                .toStringAsFixed(2),
                            when: widget.mealName,
                            date: currDate,
                            name: foods.name,
                            carbohydrates: (double.parse(foods.carbohydrates) *
                                    userInputServing /
                                    double.parse(foods.serving))
                                .toStringAsFixed(2),
                            protein: (double.parse(foods.protein) *
                                    userInputServing /
                                    double.parse(foods.serving))
                                .toStringAsFixed(2),
                            fat: (double.parse(foods.fat) *
                                    userInputServing /
                                    double.parse(foods.serving))
                                .toStringAsFixed(2),
                            unit: dropDownValue,
                            serving: userInputServing.toString()));
                      } else {
                        cal = (double.parse(foods.carbohydrates) *
                                        userInputServing +
                                    double.parse(foods.protein) *
                                        userInputServing) *
                                4.0 +
                            double.parse(foods.fat) * userInputServing * 9.0;
                        context.read<FirestoreDb>().createNewMeals(MealModel2(
                            calories: cal.round().toString(),
                            when: widget.mealName,
                            date: currDate,
                            name: foods.name,
                            carbohydrates: (double.parse(foods.carbohydrates) *
                                    userInputServing)
                                .round()
                                .toString(),
                            protein:
                                (double.parse(foods.protein) * userInputServing)
                                    .round()
                                    .toString(),
                            fat: (double.parse(foods.fat) * userInputServing)
                                .round()
                                .toString(),
                            unit: dropDownValue,
                            serving: userInputServing.toString()));
                      }

                      Navigator.pop(context);
                    } else {
                      return;
                    }
                  },
                  icon: const Icon(Icons.add, color: Colors.black),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  String calculateMacroValues(double macroPerServing) {
    TrackedFood food = TrackedFood(
        widget.food.name,
        widget.food.carbohydrates,
        widget.food.protein,
        widget.food.fat,
        widget.food.serving,
        widget.food.unit);
    double serving = userInputServing;
    if (dropDownValue == 'serving') {
      return (macroPerServing * serving).toStringAsPrecision(3);
    } else if (dropDownValues.contains("g")) {
      return ((macroPerServing / double.parse(food.serving)) * serving)
          .toStringAsPrecision(3);
    }

    return macroPerServing.toString();
  }

  Widget macroDisplay(String macro, String macroPerServing) {
    return Expanded(
      flex: 1,
      child: Column(
        children: <Widget>[
          Text(
            macro,
            style: const TextStyle(
                fontFamily: 'OpenSans', color: Colors.black, fontSize: 15),
          ),
          Text(
            calculateMacroValues(double.parse(macroPerServing)) + " g",
            style: const TextStyle(
                fontFamily: 'OpenSans', color: Colors.black, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
