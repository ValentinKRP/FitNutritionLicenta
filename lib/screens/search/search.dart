import 'dart:async';

import 'package:fitnutrition/services/current_date.dart';
import 'package:fitnutrition/services/firestore_db.dart';
import 'package:flutter/material.dart';
import '../../model/meal_model2.dart';
import '../../model/tracked_food.dart';
import '../search/createnewfood.dart';
import '../search/foodpage.dart';
import '../../services/food_db.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  final String mealName;
  const Search(this.mealName, {Key? key}) : super(key: key);
  @override
  _SearchTestState createState() => _SearchTestState();
}

class _SearchTestState extends State<Search> {
  List<TrackedFood> searchedFoods = [];
  TextEditingController searchQueary = TextEditingController();
  List<MealModel2> mealModelList = [];
  Timer? _debounce;
  String currentDate = "";

  @override
  void initState() {
    context.read<FoodDB>().searchList.clear();
    super.initState();
  }

  @override
  void dispose() {
    if (_debounce != null) {
      _debounce!.cancel();
    }
    searchQueary.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    mealModelList = Provider.of<FoodDB>(context).searchList;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    currentDate = Provider.of<CurrentDateProvider>(context).currentDateSt;
    return searchPage();
  }

  Widget searchPage() {
    var tracker = Provider.of<FirestoreDb>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CreateNewFoodPage(widget.mealName, tracker.mealListUser),
              ),
            );
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.add,
            size: 35,
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    searchView(),
                    myFoodsView(),
                  ],
                ),
              ),
            ],
          ),
        ),
        appBar: myAppBar(),
      ),
    );
  }

  PreferredSizeWidget myAppBar() {
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 100,
            height: 50,
            child: TextFormField(
              decoration: const InputDecoration(isDense: true),
              onEditingComplete: () {
                searchQueary.clear();
              },
              onChanged: (String val) {
                if (_debounce?.isActive ?? false) _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  if (val.isNotEmpty) {
                    context.read<FoodDB>().foodQueryForId(
                        val.trim(), widget.mealName, currentDate);
                  } else {
                    context.read<FoodDB>().clearList();
                  }
                });
              },
              controller: searchQueary,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            context.read<FoodDB>().foodQueryForId(
                searchQueary.text, widget.mealName, currentDate);
            searchQueary.clear();
          },
        ),
      ],
      centerTitle: false,
      title: Text(
        widget.mealName.substring(0, 1).toUpperCase() +
            widget.mealName.substring(1, widget.mealName.length),
      ),
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      bottom: const TabBar(tabs: <Widget>[
        Tab(
          text: 'SEARCH',
        ),
        Tab(
          text: "MY FOODS",
        ),
      ]),
    );
  }

  Widget myFoodsView() {
    var tracker = Provider.of<FirestoreDb>(context, listen: true);

    return ListView.builder(
        itemCount: tracker.mealListUser.length,
        itemBuilder: (BuildContext context, int index) {
          MealModel2 f = tracker.mealListUser[index];
          TrackedFood food = TrackedFood(
              f.name, f.carbohydrates, f.protein, f.fat, f.serving, f.unit);

          return Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FoodPage(widget.mealName, f, tracker.mealList),
                  ),
                );
              },
              title: Text(food.name),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(food.serving + " " + food.unit),
                  IconButton(
                    onPressed: () {
                      context.read<FirestoreDb>().deleteUserMeal(f.id);
                    },
                    icon: const Icon(Icons.delete),
                  )
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(food.carbohydrates +
                      "C " +
                      food.protein +
                      "P " +
                      food.fat +
                      "F "),
                  Text(food.calculateCalories() + " CAL"),
                ],
              ),
            ),
          );
        });
  }

  Widget searchView() {
    return ListView.builder(
        itemCount: mealModelList.length,
        itemBuilder: (BuildContext context, int index) {
          MealModel2 mealModel = mealModelList[index];
          TrackedFood food = TrackedFood(
              mealModel.name,
              mealModel.carbohydrates,
              mealModel.protein,
              mealModel.fat,
              mealModel.serving,
              mealModel.unit);
          return Card(
            child: ListTile(
              onTap: () {
                searchQueary.clear();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FoodPage(widget.mealName, mealModel, mealModelList),
                  ),
                );
              },
              title: Text(food.name),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(food.serving + " " + food.unit),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(food.carbohydrates +
                      "C " +
                      food.protein +
                      "P " +
                      food.fat +
                      "F "),
                  Text(food.calculateCalories() + " CAL"),
                ],
              ),
            ),
          );
        });
  }
}
