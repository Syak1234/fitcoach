import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TrainingDayScreen extends StatefulWidget {
  const TrainingDayScreen({super.key});

  @override
  State<TrainingDayScreen> createState() => _TrainingDayScreenState();
}

class _TrainingDayScreenState extends State<TrainingDayScreen> {
  DateTime currentDate = DateTime.now();

  final List<StatData> stats = const [
    StatData(
        label: 'Consumed',
        kcal: 2569,
        percent: 0.97,
        colors: [Colors.cyan, Colors.green, Colors.red]),
    StatData(
        label: 'Burned',
        kcal: 2630,
        percent: 1.0,
        colors: [Colors.teal, Colors.purple]),
    StatData(label: 'Over', kcal: 9, percent: 0.05, colors: [Colors.grey]),
  ];

  final List<NutrientData> nutrients = const [
    NutrientData(
        label: 'Energy', current: 2569.4, goal: 2560.0, color: Colors.red),
    NutrientData(
        label: 'Protein', current: 235.0, goal: 250.0, color: Colors.teal),
    NutrientData(
        label: 'Net Carbs', current: 300.1, goal: 300.0, color: Colors.green),
    NutrientData(label: 'Fat', current: 34.9, goal: 40.0, color: Colors.red),
  ];

  void _changeDate(int offset) {
    setState(() {
      currentDate = currentDate.add(Duration(days: offset));
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime todayDateOnly =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    String formattedDate = DateFormat("MMM d").format(todayDateOnly);
    String dayName = DateFormat('EEEE').format(todayDateOnly);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
                onTap: () => _changeDate(-1),
                child: const Icon(Icons.arrow_back_ios, size: 20)),
            const SizedBox(width: 8),
            Text(formattedDate,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            GestureDetector(
                onTap: () => _changeDate(1),
                child: const Icon(Icons.arrow_forward_ios, size: 20)),
          ],
        ),
        leading: const Icon(Icons.check_circle, color: Colors.teal),
        actions: const [
          Icon(Icons.add, color: Colors.teal),
          SizedBox(width: 16),
          Icon(Icons.more_horiz, color: Colors.teal),
          SizedBox(width: 16),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$dayName - Training Day',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.teal),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'ENERGY SUMMARY',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: stats.map((stat) => CircleStat(stat: stat)).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) => _dot(index == 0)),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'TARGETS',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          // NutrientBar widgets vertically scrollable
          Column(
            children: nutrients
                .map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: NutrientBar(data: e),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _dot(bool selected) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? Colors.black : Colors.grey[300],
        ),
      );
}

class StatData {
  final String label;
  final int kcal;
  final double percent;
  final List<Color> colors;

  const StatData({
    required this.label,
    required this.kcal,
    required this.percent,
    required this.colors,
  });
}

class CircleStat extends StatelessWidget {
  final StatData stat;

  const CircleStat({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomPaint(
          size: const Size(100, 100),
          painter: HalfGradientCirclePainter(
              percent: stat.percent.clamp(0.0, 1.0), colors: stat.colors),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Center(
              child: Text(
                '${stat.kcal}\nkcal',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(stat.label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            if (stat.label == 'Over')
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(Icons.error, size: 16, color: Colors.red),
              ),
          ],
        )
      ],
    );
  }
}

class HalfGradientCirclePainter extends CustomPainter {
  final double percent;
  final List<Color> colors;

  HalfGradientCirclePainter({required this.percent, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 10.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2;

    final backgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    final sweepAngle = 2 * 3.141592653589793 * percent;

    final gradientPaint = Paint()
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: 3.141592653589793 * 2,
        tileMode: TileMode.clamp,
        stops: [0.0, 0.5, 0.5, 1.0],
        colors: colors.length >= 2
            ? [colors[0], colors[0], colors[1], colors[1]]
            : [colors[0], colors[0], colors[0], colors[0]],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2,
      sweepAngle,
      false,
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class NutrientData {
  final String label;
  final double current;
  final double goal;
  final Color color;

  const NutrientData({
    required this.label,
    required this.current,
    required this.goal,
    required this.color,
  });

  double get percent => (current / goal).clamp(0.0, 1.0);
}

class NutrientBar extends StatelessWidget {
  final NutrientData data;

  const NutrientBar({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final percent = data.percent;
    final isFull = percent >= 1.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${data.label} - ${data.current.toStringAsFixed(1)} / ${data.goal.toStringAsFixed(1)} ${data.label == 'Energy' ? 'kcal' : 'g'}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Stack(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percent,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: data.color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('${(percent * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isFull ? Colors.red : Colors.black)),
        ],
      ),
    );
  }
}
