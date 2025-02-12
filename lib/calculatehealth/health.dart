class HealthCalculator {
  double weight; // kg
  double height; // cm
  int age;
  String gender;
  int exerciseDays; // per week
  int calorieGoal; // kcal per day
  String dietPreference; // Plant-Based, Carbo Diet, etc.
  double sleepQuality; // 0.0 - 1.0 scale
  String exercisePreference; // Jogging, Walking, etc.

  HealthCalculator({
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.exerciseDays,
    required this.calorieGoal,
    required this.dietPreference,
    required this.sleepQuality,
    required this.exercisePreference,
  });


double calculateBMI() {
  return weight / ((height / 100) * (height / 100));
}

  // Calculate BMR (Basal Metabolic Rate) using Harris-Benedict Equation
  double calculateBMR() {
    String g = gender.toLowerCase();
    if (g == "male") {
      return 66.47 + (13.75 * weight) + (5.003 * height) - (6.755 * age);
    } else if (g == "female") {
      return 655.1 + (9.563 * weight) + (1.85 * height) - (4.676 * age);
    } else {
      return (calculateBMRForMale() + calculateBMRForFemale()) / 2;
    }
  }

  double calculateBMRForMale() {
    return 66.47 + (13.75 * weight) + (5.003 * height) - (6.755 * age);
  }

  double calculateBMRForFemale() {
    return 655.1 + (9.563 * weight) + (1.85 * height) - (4.676 * age);
  }

 

  // Calculate Daily Caloric Needs
  double calculateDailyCalories() {
    double bmr = calculateBMR();
    double activityMultiplier = (exerciseDays >= 5)
        ? 1.55
        : (exerciseDays >= 3)
            ? 1.3
            : 1.2;
    return bmr * activityMultiplier;
  }

  // Exercise Score (Based on Exercise Preference)
  double calculateExerciseScore() {
    Map<String, double> exerciseScores = {
      'Jogging': 20,
      'Walking': 12,
      'Hiking': 18,
      'Skating': 15,
      'Biking': 16,
      'Weightlift': 19,
      'Cardio': 20,
      'Yoga': 14,
      'Other': 10,
    };

    return (exerciseScores[exercisePreference] ?? 10) * (exerciseDays / 7);
  }

  // Sleep Score
  double calculateSleepScore() {
    return sleepQuality * 20; // Max 20 points for perfect sleep
  }

  // Diet Score (Based on Diet Preference)
  double calculateDietScore() {
    Map<String, double> dietScores = {
      'Plant Based': 20,
      'Carbo Diet': 12,
      'Specialized': 18,
      'Traditional': 15,
    };

    return dietScores[dietPreference] ?? 10;
  }

  // Overall Health Score (0-100%)
  double calculateHealthScore() {
    double calorieScore = (calorieGoal >= calculateDailyCalories() * 0.9 &&
            calorieGoal <= calculateDailyCalories() * 1.1)
        ? 20
        : 10;

    return calorieScore +
        calculateExerciseScore() +
        calculateSleepScore() +
        calculateDietScore();
  }
}
