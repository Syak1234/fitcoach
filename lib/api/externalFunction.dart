import 'dart:math';

String passwordGanaretor(String input) {
  final random = Random();

  int randomNumber = random.nextInt(10000);
  int randomNumber2 = 55;

  String randomCapital = String.fromCharCode(random.nextInt(26) + 65);
  String randomCapital2 = "D";

  String result = '$input$randomNumber2$randomCapital2';

  return result;
}
