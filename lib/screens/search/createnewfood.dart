import 'package:fitnutrition/model/meal_model2.dart';
import 'package:fitnutrition/services/current_date.dart';
import 'package:fitnutrition/services/firestore_db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateNewFoodPage extends StatefulWidget {
  final String mealName;
  final List<MealModel2> userFoodsOld;
  const CreateNewFoodPage(this.mealName, this.userFoodsOld, {Key? key})
      : super(key: key);

  @override
  _CreateNewFoodPageState createState() => _CreateNewFoodPageState();
}

class _CreateNewFoodPageState extends State<CreateNewFoodPage> {
  final _foodFormKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var carbsController = TextEditingController();
  var proteinController = TextEditingController();
  var fatController = TextEditingController();
  var servingSizeController = TextEditingController();
  var dropDownValue = "g";
  var dropDownValues = ["g", "cups", "mL"];

  @override
  void dispose() {
    nameController.dispose();
    carbsController.dispose();
    proteinController.dispose();
    fatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const <Widget>[
            Text("Create New Food"),
          ],
        ),
      ),
      body: Form(
        key: _foodFormKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              macroFeild("Name", nameController, false),
              macroFeild("Carbohydrates (g)", carbsController, true),
              macroFeild("Protein (g)", proteinController, true),
              macroFeild("Fat (g)", fatController, true),
              servingSizeFeild(),
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  if (_foodFormKey.currentState!.validate()) {
                    String currDate =
                        context.read<CurrentDateProvider>().currentDateSt;
                    var cal = (double.parse(carbsController.text) +
                                double.parse(proteinController.text)) *
                            4.0 +
                        double.parse(fatController.text) * 9.0;

                    context.read<FirestoreDb>().createNewUserMeal(MealModel2(
                        calories: cal.toString(),
                        when: widget.mealName,
                        date: currDate,
                        name: nameController.text,
                        carbohydrates: carbsController.text,
                        protein: proteinController.text,
                        fat: fatController.text,
                        unit: dropDownValue,
                        serving: servingSizeController.text));

                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget servingSizeFeild() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              "Serving Size",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a number' : null,
                    onChanged: (t) {
                      debugPrint(servingSizeController.text);
                    },
                    controller: servingSizeController,
                  ),
                ),
                DropdownButton(
                  underline: Container(
                    color: Theme.of(context).primaryColor,
                  ),
                  value: dropDownValue,
                  onChanged: (String? unit) {
                    setState(() {
                      dropDownValue = unit ?? "";
                    });
                    debugPrint(dropDownValue);
                  },
                  items: dropDownValues
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget macroFeild(
      String macro, TextEditingController controller, bool numeric) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              macro,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 100,
              height: 50,
              child: TextFormField(
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a number' : null,
                onChanged: (t) {
                  debugPrint(controller.text);
                },
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
