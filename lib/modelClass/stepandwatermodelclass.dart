class StepActivity {
  final int? id;
  final String? userId;
  final DateTime? date;
  final String? step;
  final String? kcal;
  final String? km;
  final String? minutes;

  StepActivity({
    this.id,
    this.userId,
    this.date,
    this.step,
    this.kcal,
    this.km,
    this.minutes,
  });

  factory StepActivity.fromJson(Map<String, dynamic> json) {
    return StepActivity(
      id: json['id'],
      userId: json['userId'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      step: json['step'] ?? '0',
      kcal: json['kcal'] ?? '0',
      km: json['km'] ?? '0',
      minutes: json['minutes'] ?? '0',
    );
  }
}




class WaterActivity {
  final int? id;
  final String? userId;
  final DateTime? date;
  final String? water;

  WaterActivity({
    this.id,
    this.userId,
    this.date,
    this.water,
  });

  factory WaterActivity.fromJson(Map<String, dynamic> json) {
    return WaterActivity(
      id: json['id'],
      userId: json['userId'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      water: json['water'] ?? '0',
    );
  }
}
