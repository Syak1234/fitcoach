class MealItem {
  final String id;
  final String name;
  final String protein;
  final String fat;
  final String carbohydrates;
  final String kcal;
  final String servingSize;
  final String dataSource;
  final String proteinPercentage;
  final String fatPercentage;
  final String carbohydratePercentage;

  MealItem({
    required this.id,
    required this.name,
    required this.protein,
    required this.fat,
    required this.carbohydrates,
    required this.kcal,
    required this.servingSize,
    required this.dataSource,
    required this.proteinPercentage,
    required this.fatPercentage,
    required this.carbohydratePercentage,
  });

  factory MealItem.fromMap(Map<String, dynamic> json) {
    return MealItem(
      id: (json['id'] ?? '0').toString(),
      name: json['name']?.toString() ?? '',
      protein: json['protein']?.toString() ?? '0',
      fat: json['fat']?.toString() ?? '0',
      carbohydrates: json['carbohydrates']?.toString() ?? '0',
      kcal: json['kcal']?.toString() ?? '0',
      servingSize: json['servingSize']?.toString() ?? '',
      dataSource: json['dataSource']?.toString() ?? '',
      proteinPercentage: json['proteinPercentage']?.toString() ?? '0',
      fatPercentage: json['fatPercentage']?.toString() ?? '0',
      carbohydratePercentage: json['carbohydratePercentage']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "protein": protein,
      "fat": fat,
      "carbohydrates": carbohydrates,
      "kcal": kcal,
      "servingSize": servingSize,
      "dataSource": dataSource,
      "proteinPercentage": proteinPercentage,
      "fatPercentage": fatPercentage,
      "carbohydratePercentage": carbohydratePercentage,
    };
  }
}

class Meal {
  final String id;
  final String mealName;
  final String userId;
  final List<MealItem> mealItems;

  Meal({
    required this.id,
    required this.mealName,
    required this.userId,
    required this.mealItems,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    var items = (json['mealItems'] as List)
        .map((item) => MealItem.fromMap(item))
        .toList();

    return Meal(
      id: json['id']?.toString() ?? '0',
      mealName: json['mealName']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      mealItems: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "mealName": mealName,
      "userId": userId,
      "mealItems": mealItems.map((item) => item.toJson()).toList(),
    };
  }
}
