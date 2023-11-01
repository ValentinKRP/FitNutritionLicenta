class MealApiModel {
  int? fdcId;
  String? description;
  String? dataType;
  String? publicationDate;
  String? brandOwner;
  String? gtinUpc;
  List<FoodNutrients>? foodNutrients;

  MealApiModel(
      {this.fdcId,
      this.description,
      this.dataType,
      this.publicationDate,
      this.brandOwner,
      this.gtinUpc,
      this.foodNutrients});

  MealApiModel.fromJson(Map<String, dynamic> json) {
    fdcId = json['fdcId'];
    description = json['description'];
    dataType = json['dataType'];
    publicationDate = json['publicationDate'];
    brandOwner = json['brandOwner'];
    gtinUpc = json['gtinUpc'];
    if (json['foodNutrients'] != null) {
      foodNutrients = <FoodNutrients>[];
      json['foodNutrients'].forEach((v) {
        foodNutrients!.add(FoodNutrients.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fdcId'] = fdcId;
    data['description'] = description;
    data['dataType'] = dataType;
    data['publicationDate'] = publicationDate;
    data['brandOwner'] = brandOwner;
    data['gtinUpc'] = gtinUpc;
    if (foodNutrients != null) {
      data['foodNutrients'] = foodNutrients!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodNutrients {
  String? number;
  String? name;
  double? amount;
  String? unitName;
  String? derivationCode;
  String? derivationDescription;

  FoodNutrients(
      {this.number,
      this.name,
      this.amount,
      this.unitName,
      this.derivationCode,
      this.derivationDescription});

  FoodNutrients.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    name = json['name'];
    amount = json['amount'].toDouble();
    unitName = json['unitName'];
    derivationCode = json['derivationCode'];
    derivationDescription = json['derivationDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['name'] = name;
    data['amount'] = amount;
    data['unitName'] = unitName;
    data['derivationCode'] = derivationCode;
    data['derivationDescription'] = derivationDescription;
    return data;
  }
}
