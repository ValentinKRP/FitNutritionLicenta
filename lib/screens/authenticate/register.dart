// ignore_for_file: prefer_const_constructors, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../services/auth.dart';
import '../../shared/loading.dart';
import '../../utilities/constants.dart';
import '../../widgets/info_inputs.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

class Register extends StatefulWidget {
  final Function? toggleView;

  const Register({Key? key, this.toggleView}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String activity = '';
  String? activityLvl;
  String goal = '';
  String? goal2;
  String? sex;
  String sexType = '';
  String email = '';
  String password = '';

  String error = '';

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

  Widget _buildSex() {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2(
        hint: Text(
          'Select your gender',
          style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
        ),
        isExpanded: true,
        value: sex,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          DropdownMenuItem(child: Text("Male"), value: 'M'),
          DropdownMenuItem(child: Text("Female"), value: 'F'),
        ],
        onChanged: (value) {
          setState(() {
            sexType = value as String;
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

  Widget _buildEmailSignUp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          "Email",
          style: kLabelStyle,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: TextFormField(
            validator: (val) => val!.isEmpty ? 'john@gmail.com' : null,
            onChanged: (val) {
              setState(() => email = val);
            },
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              color: Colors.black,
            ),
            decoration: const InputDecoration(
              errorStyle: TextStyle(fontSize: 15.0),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.black54,
              ),
              border: InputBorder.none,
              hintText: "john@gmail.com",
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordSignUp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Password",
          style: kLabelStyle.copyWith(color: Theme.of(context).primaryColor),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: TextFormField(
            validator: (val) => val!.isEmpty ? 'Enter a password' : null,
            onChanged: (val) {
              setState(() => password = val);
            },
            obscureText: true,
            style: TextStyle(color: Theme.of(context).primaryColor),
            decoration: const InputDecoration(
              errorStyle: TextStyle(fontSize: 15),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black54,
              ),
              border: InputBorder.none,
              hintText: "Enter a password",
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: true,
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      // Positioned.fill(
                      //   child: Image.asset(
                      //     "assets/background-wave.png",
                      //     fit: BoxFit.fitWidth,
                      //     alignment: Alignment.bottomCenter,
                      //   ),
                      // ),
                      SizedBox(
                        height: double.infinity,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 120.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const <Widget>[
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      "Create Account.",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Open Sans",
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    _buildEmailSignUp(),
                                    const SizedBox(
                                      height: 30.0,
                                    ),
                                    _buildPasswordSignUp(),
                                    const SizedBox(
                                      height: 30.0,
                                    ),
                                    buildInfoInputs(
                                        _nameController,
                                        _ageController,
                                        _weightController,
                                        _heightController),
                                    _buildSex(),
                                    _buildGoal(),
                                    _buildActivity(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15.0,
                                      ),
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 5.0,
                                          padding: const EdgeInsets.all(15.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          primary:
                                              Theme.of(context).primaryColor,
                                        ),
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() => loading = true);
                                            String name = _nameController.text;
                                            int age =
                                                int.parse(_ageController.text);
                                            double height = double.parse(
                                                _heightController.text);
                                            double weight = double.parse(
                                                _weightController.text);
                                            String sex = sexType;

                                            double activitylevel =
                                                double.parse(activity);
                                            String goalWanted = goal;
                                            await context
                                                .read<Auth>()
                                                .registerWithEmailAndPassword(
                                                    email: email,
                                                    password: password,
                                                    name: name,
                                                    age: age,
                                                    height: height,
                                                    weight: weight,
                                                    sex: sex,
                                                    activityLevel:
                                                        activitylevel,
                                                    goal: goalWanted)
                                                .catchError((exception) {
                                              if (mounted) {
                                                setState(
                                                  () {
                                                    error =
                                                        "Email is invalid or password is too short! Please try again.";
                                                    loading = false;
                                                  },
                                                );
                                              }
                                            });
                                          }
                                        },
                                        child: const Text(
                                          "SIGN UP",
                                          style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Comfortaa",
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      error,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 16.0),
                                    ),
                                    const SizedBox(
                                      height: 13.0,
                                    ),
                                    GestureDetector(
                                      onTap: () => widget.toggleView!(),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Already have an account? ',
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'Sign in',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
