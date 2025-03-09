import 'package:flutter/material.dart';

Widget resultDialog({
  required BuildContext context,
  required String title,
  required String message,
  required IconData icon,
  required Color iconBackgroundColor,
  required String buttonText,
  VoidCallback? onButtonPressed,
}) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    backgroundColor: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              icon,
              color: Colors.black,
              size: 30.0,
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
            ),
            onPressed: onButtonPressed ?? () => Navigator.of(context).pop(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(buttonText, style: const TextStyle(color: Colors.white)),
                const SizedBox(width: 8.0),
                const Icon(Icons.arrow_right_alt, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// Usage Example:
// showDialog(
//   context: context,
//   builder: (context) => customDialog(
//     context: context,
//     title: 'Error Occurred!',
//     message: 'Something went wrong. Please try again.',
//     icon: Icons.error,
//     iconBackgroundColor: Colors.redAccent,
//     buttonText: 'Retry',
//     onButtonPressed: () {
//       Navigator.of(context).pop();
//       // Add custom retry logic here
//     },
//   ),
// );
