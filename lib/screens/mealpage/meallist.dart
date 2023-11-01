import 'package:fitnutrition/model/meal_model2.dart';
import 'package:fitnutrition/screens/search/search.dart';
import 'package:fitnutrition/services/current_date.dart';
import 'package:fitnutrition/services/firestore_db.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class MealList extends StatefulWidget {
  const MealList({Key? key}) : super(key: key);

  @override
  _MealListState createState() => _MealListState();
}

class _MealListState extends State<MealList> {
  @override
  Widget build(BuildContext context) {
    var meal2 = Provider.of<FirestoreDb>(context);
    String currentdate =
        Provider.of<CurrentDateProvider>(context).currentDateSt;

    List<MealModel2> b = [];
    List<MealModel2> l = [];
    List<MealModel2> d = [];

    for (MealModel2 m in meal2.mealList) {
      var currentMeal = m;
      if (currentMeal.when == "breakfast" && currentMeal.date == currentdate) {
        b.add(currentMeal);
      }
      if (currentMeal.when == "lunch" && currentMeal.date == currentdate) {
        l.add(currentMeal);
      }
      if (currentMeal.when == "dinner" && currentMeal.date == currentdate) {
        d.add(currentMeal);
      }
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  width: MediaQuery.of(context).size.width * .8,
                  child: const Center(
                    child: Text(
                      "Breakfast",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 15,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Search("breakfast"),
                      ),
                    );
                  },
                  color: Theme.of(context).primaryColor,
                  icon: const Icon(Icons.add_circle),
                ),
              ],
            ),
            Container(
              decoration: b.isNotEmpty
                  ? BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15.0)),
                    )
                  : null,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var currentMeal = b[index];
                    return listCreator(currentMeal, context);
                  },
                  itemCount: b.length),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  ),
                  width: MediaQuery.of(context).size.width * .8,
                  child: const Center(
                    child: Text(
                      "Lunch",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 15,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const Search("lunch");
                        },
                      ),
                    );
                  },
                  color: Theme.of(context).primaryColor,
                  icon: const Icon(Icons.add_circle),
                ),
              ],
            ),
            Container(
              decoration: l.isNotEmpty
                  ? BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15.0)),
                    )
                  : null,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var currentMeal = l[index];
                    return listCreator(currentMeal, context);
                  },
                  itemCount: l.length),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  ),
                  width: MediaQuery.of(context).size.width * .8,
                  child: const Center(
                    child: Text(
                      "Dinner",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 15,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const Search("dinner");
                        },
                      ),
                    );
                  },
                  color: Theme.of(context).primaryColor,
                  icon: const Icon(Icons.add_circle),
                ),
              ],
            ),
            Container(
              decoration: d.isNotEmpty
                  ? BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15.0)),
                    )
                  : null,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var currentMeal = d[index];
                    return listCreator(currentMeal, context);
                  },
                  itemCount: d.length),
            ),
          ],
        ),
      ),
    );
  }

  InkWell listCreator(MealModel2 currentMeal, BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      currentMeal.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: "OpenSans"),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          currentMeal.carbohydrates + "C",
                          style: const TextStyle(
                              fontFamily: "OpenSans", fontSize: 10),
                        ),
                        Text(
                          currentMeal.protein + "P",
                          style: const TextStyle(
                              fontFamily: "OpenSans", fontSize: 10),
                        ),
                        Text(
                          currentMeal.fat + "F",
                          style: const TextStyle(
                              fontFamily: "OpenSans", fontSize: 10),
                        ),
                        GestureDetector(
                          onTap: () {
                            context
                                .read<FirestoreDb>()
                                .deleteMeal(currentMeal.id);
                          },
                          child: const Icon(
                            Icons.delete,
                            size: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  currentMeal.serving + " " + currentMeal.unit,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
