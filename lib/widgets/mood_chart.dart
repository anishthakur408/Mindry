import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/mood.dart';
import '../utils/constants.dart';

class MoodChartWidget extends StatelessWidget {
  final Map<Mood, int> moodDistribution;

  const MoodChartWidget({
    super.key,
    required this.moodDistribution,
  });

  // Get watercolor background for each mood
  Color _getMoodWatercolorBg(Mood mood) {
    switch (mood) {
      case Mood.amazing:
        return AppColors.watercolorYellow;
      case Mood.good:
        return AppColors.watercolorGreen;
      case Mood.okay:
        return AppColors.watercolorBlue;
      case Mood.bad:
        return AppColors.watercolorPurple;
      case Mood.terrible:
        return AppColors.watercolorPink;
      default:
        return AppColors.watercolorBlue; // Default color for unexpected mood
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasData = moodDistribution.values.any((count) => count > 0);

    if (!hasData) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.paperLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.sketchLight,
            width: 1.5,
          ),
        ),
        child: Text(
          'No data yet. Start journaling!',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.paperLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.sketchBorder,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: SizedBox(
        height: 200,
        child: PieChart(
          PieChartData(
            sectionsSpace: 3,
            centerSpaceRadius: 45,
            sections: _getSections(),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _getSections() {
    final sections = <PieChartSectionData>[];
    final total =
        moodDistribution.values.fold<int>(0, (sum, count) => sum + count);

    if (total == 0) return sections;

    moodDistribution.forEach((mood, count) {
      if (count > 0) {
        final percentage = (count / total * 100).toStringAsFixed(1);
        final watercolorBg = _getMoodWatercolorBg(mood);

        sections.add(
          PieChartSectionData(
            color: watercolorBg,
            value: count.toDouble(),
            title: '$percentage%',
            radius: 55,
            titleStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.inkDark,
            ),
            badgeWidget: Text(
              mood.emoji,
              style: const TextStyle(fontSize: 20),
            ),
            badgePositionPercentageOffset: 1.3,
          ),
        );
      }
    });

    return sections;
  }
}

class MoodTrendChart extends StatelessWidget {
  final List<Map<String, dynamic>> trendData;

  const MoodTrendChart({
    super.key,
    required this.trendData,
  });

  @override
  Widget build(BuildContext context) {
    if (trendData.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.paperLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.sketchLight,
            width: 1.5,
          ),
        ),
        child: Text(
          'No trend data available',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.paperLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.sketchBorder,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: SizedBox(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.only(right: 20, top: 20, bottom: 10),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppColors.sketchLight.withValues(alpha: 0.3),
                    strokeWidth: 1,
                    dashArray: [5, 5], // Sketch-style dashed line
                  );
                },
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: AppColors.sketchBorder,
                  width: 2,
                ),
              ),
              minY: 0,
              maxY: 4,
              lineBarsData: [
                LineChartBarData(
                  spots: _getSpots(),
                  isCurved: true,
                  color: AppColors.watercolorBlue,
                  barWidth: 3,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 5,
                        color: AppColors.watercolorPink,
                        strokeWidth: 2,
                        strokeColor: AppColors.sketchBorder,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.watercolorBlue.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<FlSpot> _getSpots() {
    final spots = <FlSpot>[];
    for (int i = 0; i < trendData.length; i++) {
      final data = trendData[i];
      if (data['hasEntry']) {
        spots.add(FlSpot(i.toDouble(), data['mood']));
      }
    }
    return spots;
  }
}
