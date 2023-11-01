// ignore_for_file: prefer_const_constructors, body_might_complete_normally_nullable

import 'package:fitnutrition/model/person_model.dart';
import 'package:fitnutrition/services/firestore_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/auth.dart';
import '../../utilities/validate.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _weightController = TextEditingController();
  String activity = '';
  String? activityLvl;
  String goal = '';
  String? goal2;

  Widget _buildActivity() {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2(
        hint: Text(
          'Select activity level',
          style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
        ),
        isExpanded: true,
        value: activityLvl,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          DropdownMenuItem(
              child: Text("Sedentary (little or no exercise)"), value: '1.2'),
          DropdownMenuItem(
              child: Text("Lightly active (exercise 1-3 days/week)"),
              value: '1.375'),
          DropdownMenuItem(
              child: Text("Moderately active (exercise 3-5 days/week)"),
              value: '1.55'),
          DropdownMenuItem(
              child: Text("Active (exercise 6-7 days/week)"), value: '1.725'),
          DropdownMenuItem(
              child: Text("Very active (hard exercise 6-7 days/week)"),
              value: '1.9'),
        ],
        onChanged: (value) {
          setState(() {
            activity = value as String;
          });
        },
        buttonHeight: 60,
        itemHeight: 60,
      ),
    );
  }

  Widget _buildGoal() {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2(
        hint: Text(
          'Select your goal',
          style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
        ),
        isExpanded: true,
        value: goal2,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          DropdownMenuItem(child: Text("Lose weight"), value: 'lose'),
          DropdownMenuItem(
              child: Text("Maintain your weight"), value: 'maintain'),
          DropdownMenuItem(child: Text("Gain muscle"), value: 'gain'),
        ],
        onChanged: (value) {
          setState(() {
            goal = value as String;
          });
        },
        validator: (value) {
          if (value == null) {
            return 'Please select gender.';
          }
        },
        buttonHeight: 40,
        itemHeight: 40,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var nutrition = Provider.of<FirestoreDb>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: "OpenSans",
              fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
              onPressed: () async {
                await context.read<Auth>().signOut();
              },
              icon: const Icon(Icons.person, color: Colors.white),
              label: const Text(
                'Log Out',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: "OpenSans"),
              ))
        ],
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(fit: StackFit.expand, children: <Widget>[
            SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Update Your Goals",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'OpenSans',
                              fontSize: 20),
                        ),
                      ),
                    ),
                    Form(
                      key: _formkey,
                      child: SizedBox(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: Get.height * 0.08,
                            ),
                            TextFormField(
                              controller: _weightController,
                              validator: (value) =>
                                  Validation.validateWeight(value),
                              decoration: const InputDecoration(
                                  labelText: "Weight(kg)"),
                            ),
                            _buildActivity(),
                            _buildGoal(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                    ),
                                    child: const Text(
                                      "SET NEW GOALS",
                                      style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          color: Colors.white),
                                    ),
                                    onPressed: () {
                                      if (_formkey.currentState!.validate()) {
                                        var p = nutrition.person;
                                        double weight = double.parse(
                                            _weightController.text);
                                        double activitylevel =
                                            double.parse(activity);
                                        String goalWanted = goal;
                                        context.read<FirestoreDb>().setNewGoals(
                                            weight: weight,
                                            activityLevel: activitylevel,
                                            goal: goalWanted,
                                            personModel: p);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text("Goals has been updated"),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Please check your inputs."),
                                          ),
                                        );
                                      }
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget macroTextFeild(String name, PersonModel tracker, double macro,
      TextEditingController controller) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name.length > 7
                  ? name.toUpperCase().substring(0, 4) + "S"
                  : name.toUpperCase(),
              style: const TextStyle(
                  fontFamily: "OpenSans", fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            controller: controller,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a number.';
              }
              tracker.personalNutrients.containsKey(name)
                  ? tracker.personalNutrients[name] = double.parse(value)
                  : tracker.personalNutrients
                      .putIfAbsent(name, () => double.parse(value));
              return null;
            },
          ),
        ],
      ),
    );
  }
}
