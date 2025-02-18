import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

// class StepsViewModel extends BaseViewModel {}

class StepsViewModel extends BaseViewModel {
  List<Color> layerColors = [
    AppColors.primaryorange,
    AppColors.gray80,
    AppColors.blue60
  ];

  List<double> percentages = [0.7, 0.4, 0.5]; // Dynamic percentages

  void updateLayerData(List<double> newPercentages, List<Color> newColors) {
    percentages = newPercentages;
    layerColors = newColors;
    notifyListeners();
  }
}

class StepsUI extends StatelessWidget {
  final StepsViewModel model;
  StepsUI({required this.model});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        for (int i = 0; i < model.percentages.length; i++)
          Padding(
            padding: EdgeInsets.all(i * 25), // Dynamic margin for each layer
            child: Container(
              width: 350 - (i * 10),
              height: 350 - (i * 10),
              // margin: EdgeInsets.all(0), // Extra margin to prevent overlap
              child: CircularProgressIndicator(
                value: model.percentages[i],
                strokeWidth: 20,
                backgroundColor: AppColors.backgroundLight,
                valueColor: AlwaysStoppedAnimation<Color>(model.layerColors[i]),
              ),
            ),
          ),
        Positioned(
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Image.asset(
                'assets/utility/image.png',
                width: 30,
                height: 30,
                color: AppColors.textDark,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StepsTakenScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Steps Taken",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textDark),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: AppColors.textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          Center(
            child: Container(
              width: 280,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ViewModelBuilder<StepsViewModel>.reactive(
                    viewModelBuilder: () => StepsViewModel(),
                    builder: (context, model, child) => StepsUI(model: model),
                  ),
                  // Icon(
                  //   Icons.directions_walk,
                  //   size: 40,
                  //   color: Colors.black,
                  // ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "2,574",
            style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark),
          ),
          Text(
            "total steps",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.gray,
            ),
          ),
          SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCard("578", "kcal", AppColors.primaryorange,
                    Icons.local_fire_department),
                _buildInfoCard(
                    "7.5", "kilometer", AppColors.gray80, Icons.place),
                _buildInfoCard(
                    "25", "minute", AppColors.blue60, Icons.access_time),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      String value, String label, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: AppColors.textLight, size: 30),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: AppColors.gray),
        ),
      ],
    );
  }
}
