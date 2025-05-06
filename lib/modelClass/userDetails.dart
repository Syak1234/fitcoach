class Userdetails {
  String username = "";

  String token = "";
  String userId = "";

  Userdetails({
    required this.username,
    required this.token,
    required this.userId,
  });
}

class UserAssessmentDetaiils {
  String fitnessGoal = "";
  String gender = "";
  String weight = "";
  String height = "";
  String age = "";
  String previousFitnessExperience = "";
  String specificDiet = "";
  String daysCommit = "";
  List specificExperiencePreferance = [];
  String calorieyGoal = "";
  String sleepQuality = "";
  String profileimage = "";

  UserAssessmentDetaiils({
    required this.fitnessGoal,
    required this.gender,
    required this.weight,
    required this.height,
    required this.previousFitnessExperience,
    required this.specificDiet,
    required this.daysCommit,
    required this.specificExperiencePreferance,
    required this.calorieyGoal,
    required this.sleepQuality,
    required this.age,
    required this.profileimage,
  });
}
