import 'dart:math';

String passwordGanaretor(String input) {
  final random = Random();

  int randomNumber = random.nextInt(10000);

  String randomCapital = String.fromCharCode(random.nextInt(26) + 65);

  String result = '$input$randomNumber$randomCapital';

  return result;
}
