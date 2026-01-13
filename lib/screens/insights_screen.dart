import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/mood.dart';
import '../providers/journal_provider.dart';
import '../services/insights_service.dart';
import '../widgets/mood_chart.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Paper texture background
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/paper_texture.png'),
          repeat: ImageRepeat.repeat,
          opacity: 0.4,
        ),
        color: AppColors.backgroundColor,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.getResponsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Insights',
                style: GoogleFonts.indieFlower(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 36),
                  fontWeight: FontWeight.bold,
                  color: AppColors.inkDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Discover patterns in your journaling',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              ),
              const SizedBox(height: 32),
              _buildAIInsights(context),
              const SizedBox(height: 24),
              _buildMoodDistribution(context),
              const SizedBox(height: 24),
              _buildMoodTrend(context),
              const SizedBox(height: 24),
              _buildStats(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIInsights(BuildContext context) {
    final insights = InsightsService.generateInsights();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('✨', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 8),
            Text(
              'AI Insights',
              style: GoogleFonts.indieFlower(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 24),
                fontWeight: FontWeight.bold,
                color: AppColors.inkDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...insights.map((insight) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                // Speech bubble style
                color: AppColors.watercolorBlue,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.sketchBorder,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 6,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      insight,
                      style: TextStyle(
                        color: AppColors.inkDark,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildMoodDistribution(BuildContext context) {
    return Consumer<JournalProvider>(
      builder: (context, provider, child) {
        final distribution = provider.getMoodDistribution();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mood Distribution',
              style: GoogleFonts.indieFlower(
                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 22),
                fontWeight: FontWeight.bold,
                color: AppColors.inkDark,
              ),
            ),
            const SizedBox(height: 16),
            MoodChartWidget(moodDistribution: distribution),
            const SizedBox(height: 16),
            _buildMoodLegend(context, distribution),
          ],
        );
      },
    );
  }

  Widget _buildMoodLegend(
      BuildContext context, Map<dynamic, int> distribution) {
    // Helper function to get watercolor for mood
    Color getMoodColor(dynamic mood) {
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

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: distribution.entries.map((entry) {
        final color = getMoodColor(entry.key);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.sketchBorder,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(entry.key.emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(
                '${entry.value}',
                style: TextStyle(
                  color: AppColors.inkDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMoodTrend(BuildContext context) {
    final trendData = InsightsService.getMoodTrendData();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mood Trend (Last 7 Days)',
          style: GoogleFonts.indieFlower(
            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 22),
            fontWeight: FontWeight.bold,
            color: AppColors.inkDark,
          ),
        ),
        const SizedBox(height: 16),
        MoodTrendChart(trendData: trendData),
      ],
    );
  }

  Widget _buildStats(BuildContext context) {
    return Consumer<JournalProvider>(
      builder: (context, provider, child) {
        final totalEntries = provider.entryCount;
        final streak = provider.getCurrentStreak();

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.watercolorPink,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.sketchBorder,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 6,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Statistics',
                style: GoogleFonts.indieFlower(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 22),
                  fontWeight: FontWeight.bold,
                  color: AppColors.inkDark,
                ),
              ),
              const SizedBox(height: 20),
              _buildStatRow(context, '📝', 'Total Entries', '$totalEntries'),
              const SizedBox(height: 12),
              _buildStatRow(context, '🔥', 'Current Streak',
                  '$streak day${streak != 1 ? 's' : ''}'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatRow(
      BuildContext context, String emoji, String label, String value) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.inkDark,
                ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.indieFlower(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.inkDark,
          ),
        ),
      ],
    );
  }
}
