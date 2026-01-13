import 'package:flutter/material.dart';
import '../models/mood.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';

class MoodSelector extends StatelessWidget {
  final Mood? selectedMood;
  final Function(Mood) onMoodSelected;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
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
        return AppColors.watercolorBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getResponsiveValue(
        context,
        mobile: 20.0,
        tablet: 24.0,
        desktop: 28.0,
      )),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 20),
                ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: isMobile ? 12 : 16,
            runSpacing: 12,
            alignment: WrapAlignment.spaceEvenly,
            children: Mood.values.map((mood) {
              final isSelected = selectedMood == mood;
              final watercolorBg = _getMoodWatercolorBg(mood);

              return GestureDetector(
                onTap: () => onMoodSelected(mood),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isMobile ? 70 : 80,
                  height: isMobile ? 90 : 100,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    // Watercolor splash background
                    color: isSelected ? watercolorBg : AppColors.paperLight,
                    borderRadius: BorderRadius.circular(16),
                    // Hand-drawn circle border
                    border: Border.all(
                      color: isSelected
                          ? AppColors.sketchBorder
                          : AppColors.sketchLight,
                      width: isSelected ? 2.5 : 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: watercolorBg.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        mood.emoji,
                        style: TextStyle(
                          fontSize: isSelected ? 32 : 28,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        mood.displayName,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.inkDark,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
