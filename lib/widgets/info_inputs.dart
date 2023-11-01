// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utilities/validate.dart';

Widget buildInfoInputs(
    nameController, ageController, weightController, heightController) {
  return Column(
    children: [
      SizedBox(
        height: Get.height * 0.08,
      ),
      Text(
        "Please enter your information!",
        style: TextStyle(
          color: Colors.black,
          fontSize: Get.width * 0.1,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(
        height: Get.height * 0.04,
      ),
      TextFormField(
        controller: nameController,
        validator: (value) => Validation.validateName(value),
        decoration: const InputDecoration(labelText: "Name"),
      ),
      TextFormField(
        controller: ageController,
        validator: (value) => Validation.validateAge(value),
        decoration: const InputDecoration(labelText: "Age"),
      ),
      TextFormField(
        controller: heightController,
        validator: (value) => Validation.validateHeight(value),
        decoration: const InputDecoration(labelText: "Height(cm)"),
      ),
      TextFormField(
        controller: weightController,
        validator: (value) => Validation.validateWeight(value),
        decoration: const InputDecoration(labelText: "Weight(kg)"),
      ),
    ],
  );
}
