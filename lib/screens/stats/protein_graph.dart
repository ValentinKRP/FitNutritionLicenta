import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../../model/mealmodel.dart';
import '../../model/tracked_food.dart';

import '../../services/firestore_db.dart';

class ProteinGraph extends StatefulWidget {
  const ProteinGraph({Key? key}) : super(key: key);

  @override
  _ProteinGraphState createState() => _ProteinGraphState();
}

class _ProteinGraphState extends State<ProteinGraph> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> proteinsSPot = [];

    var nutrition = Provider.of<FirestoreDb>(context, listen: true);
    DateTime currentDatetime = DateTime.now();
    String currDate = DateTime.now().day.toString() +
        "/" +
        DateTime.now().month.toString() +
        "/" +
        DateTime.now().year.toString();

    for (double i = 0; i < 7; i++) {
      List<MealModel> meals = [
        MealModel("", [TrackedFood("", "0.0", "0.0", "0.0", "0.0", "0.0")])
      ];

      for (var meal in nutrition.mealList) {
        if (meal.date == currDate) {
          meals.add(MealModel(meal.name, [
            TrackedFood(meal.name, meal.carbohydrates, meal.protein, meal.fat,
                meal.serving, meal.unit)
          ]));
        }
      }
      var proteinsPerMeal =
          meals.map((meal) => meal.calculateProtein()).toList();
      double totalProteins =
          proteinsPerMeal.reduce((value, element) => value + element);

      proteinsSPot.add(FlSpot(6 - i, totalProteins / 100));

      currentDatetime = currentDatetime.subtract(const Duration(days: 1));
      currDate = currentDatetime.day.toString() +
          "/" +
          currentDatetime.month.toString() +
          "/" +
          currentDatetime.year.toString();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Text("Proteins",
                style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
          ),
          Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.70,
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 18.0, left: 12.0, top: 24, bottom: 12),
                    child: LineChart(
                      mainData(proteinsSPot),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 3:
        text = const Text('Last 7 days', style: style);
        break;

      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromARGB(255, 4, 66, 129),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '100g';
        break;
      case 2:
        text = '200g';
        break;
      case 3:
        text = '300g';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData(carbsSpot) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color.fromARGB(255, 100, 168, 224),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color.fromARGB(255, 82, 164, 230),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(
              color: const Color.fromARGB(255, 53, 152, 233), width: 1)),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 4,
      lineBarsData: [
        LineChartBarData(
          spots: carbsSpot,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        )
      ],
    );
  }
}
