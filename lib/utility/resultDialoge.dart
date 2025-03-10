import 'package:fitcoach/theme/app_colors.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              icon,
              color: Colors.black,
              size: 50.0,
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
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.backgroundDark,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19)),
            ),
            onPressed: onButtonPressed ?? () => Navigator.of(context).pop(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: AppColors.textLight),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildContinueButton(VoidCallback onTap, String title) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.backgroundDark,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
    ),
    onPressed: () {
      onTap();
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title,
            style: TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
        SizedBox(width: 8),
        Icon(Icons.arrow_forward, color: AppColors.textLight),
      ],
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
