import 'package:flutter/material.dart';

class CurrentDateProvider extends ChangeNotifier {
  String currentDateSt = DateTime.now().day.toString() +
      "/" +
      DateTime.now().month.toString() +
      "/" +
      DateTime.now().year.toString();

  DateTime currentDate = DateTime.now();

  void timrPre() {
    currentDate = currentDate.subtract(const Duration(days: 1));

    currentDateSt = currentDate.day.toString() +
        "/" +
        currentDate.month.toString() +
        "/" +
        currentDate.year.toString();
    notifyListeners();
  }

  void timrNext() {
    currentDate = currentDate.add(const Duration(days: 1));

    currentDateSt = currentDate.day.toString() +
        "/" +
        currentDate.month.toString() +
        "/" +
        currentDate.year.toString();
    notifyListeners();
  }
}
