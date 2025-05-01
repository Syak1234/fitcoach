class MealItem {
  final int id;
  final String name;
  final int protein;
  final int fat;
  final int carbohydrates;
  final int kcal;
  final String servingSize;
  final String dataSource;
  final int proteinPercentage;
  final int fatPercentage;
  final int carbohydratePercentage;

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

  // Factory constructor
  factory MealItem.fromMap(Map<String, dynamic> json) {
    return MealItem(
      id: (json['id'] ?? 0) as int,
      name: json['name'] ?? '',
      protein: _parseToInt(json['protein']),
      fat: _parseToInt(json['fat']),
      carbohydrates: _parseToInt(json['carbohydrates']),
      kcal: _parseToInt(json['kcal']),
      servingSize: json['servingSize'] ?? '',
      dataSource: json['dataSource'] ?? '',
      proteinPercentage: _parseToInt(json['proteinPercentage']),
      fatPercentage: _parseToInt(json['fatPercentage']),
      carbohydratePercentage: _parseToInt(json['carbohydratePercentage']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // "id": id ?? 0,
      "protein": protein ?? 0,
      "fat": fat ?? 0,
      "carbohydrates": carbohydrates ?? 0,
      "kcal": kcal ?? 0,
      "servingSize": servingSize ?? "0",
      "dataSource": dataSource ?? "Unknown",
      "name": name ?? "Unknown",
      "proteinPercentage": proteinPercentage ?? 0,
      "fatPercentage": fatPercentage ?? 0,
      "carbohydratePercentage": carbohydratePercentage ?? 0,
    };
  }

  // Static method to safely parse and convert to int
  static int _parseToInt(dynamic value) {
    var parsedValue = double.tryParse(value.toString());
    if (parsedValue == null || parsedValue.isNaN || parsedValue.isInfinite) {
      return 0;
    }
    return parsedValue.toInt();
  }
}

class Meal {
  final int id;
  final String mealName;
  final String userId;
  final List<MealItem> mealItems;

  Meal({
    required this.id,
    required this.mealName,
    required this.userId,
    required this.mealItems,
  });

  // Factory constructor
  factory Meal.fromJson(Map<String, dynamic> json) {
    var items = (json['mealItems'] as List)
        .map((item) => MealItem.fromMap(item))
        .toList();

    return Meal(
      id: json['id'],
      mealName: json['mealName'],
      userId: json['userId'],
      mealItems: items,
    );
  }
}
