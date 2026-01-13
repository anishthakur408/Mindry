import '../models/journal_entry.dart';
import '../models/mood.dart';
import 'database_service.dart';

class InsightsService {
  // Generate insights based on journal patterns
  static List<String> generateInsights() {
    final insights = <String>[];
    final entries = DatabaseService.getAllEntries();

    if (entries.isEmpty) {
      return ['Start journaling to see personalized insights!'];
    }

    // Streak insight
    final streak = DatabaseService.getCurrentStreak();
    if (streak > 0) {
      insights.add('🔥 You\'re on a $streak-day streak! Keep it up!');
    }

    // Mood insights
    final moodDistribution = DatabaseService.getMoodDistribution();
    final dominantMood = _getDominantMood(moodDistribution);
    if (dominantMood != null) {
      insights.add(
          '${dominantMood.emoji} Most of your recent mood has been ${dominantMood.displayName.toLowerCase()}');
    }

    // Frequency insight
    final thisWeekCount = _getEntriesThisWeek().length;
    if (thisWeekCount >= 5) {
      insights
          .add('⭐ Amazing! You\'ve journaled $thisWeekCount times this week!');
    } else if (thisWeekCount > 0) {
      insights.add(
          '📝 You\'ve journaled $thisWeekCount time${thisWeekCount > 1 ? 's' : ''} this week');
    }

    // Consistency insight
    if (entries.length >= 7) {
      final consistency = _calculateConsistency();
      if (consistency > 0.7) {
        insights.add('💪 You\'re very consistent with your journaling!');
      }
    }

    // Positive mood trend
    final recentPositiveTrend = _hasPositiveMoodTrend();
    if (recentPositiveTrend) {
      insights.add('📈 Your mood has been improving lately!');
    }

    // Word count insight
    final avgWordCount = _getAverageWordCount();
    if (avgWordCount > 100) {
      insights.add(
          '✍️ You express yourself deeply with ${avgWordCount.toInt()} words on average');
    }

    if (insights.isEmpty) {
      insights.add('Keep journaling to unlock insights!');
    }

    return insights;
  }

  static Mood? _getDominantMood(Map<Mood, int> distribution) {
    int maxCount = 0;
    Mood? dominantMood;

    distribution.forEach((mood, count) {
      if (count > maxCount) {
        maxCount = count;
        dominantMood = mood;
      }
    });

    return maxCount > 0 ? dominantMood : null;
  }

  static List<JournalEntry> _getEntriesThisWeek() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    return DatabaseService.getAllEntries().where((entry) {
      return entry.createdAt.isAfter(weekStart);
    }).toList();
  }

  static double _calculateConsistency() {
    final entries = DatabaseService.getAllEntries();
    if (entries.isEmpty) return 0;

    final sortedEntries = entries
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final firstDate = sortedEntries.first.createdAt;
    final lastDate = sortedEntries.last.createdAt;
    final daysDiff = lastDate.difference(firstDate).inDays + 1;

    if (daysDiff == 0) return 0;

    return entries.length / daysDiff;
  }

  static bool _hasPositiveMoodTrend() {
    final entries = DatabaseService.getEntriesSorted();
    if (entries.length < 5) return false;

    final recentEntries = entries.take(5).toList();
    final olderEntries = entries.skip(5).take(5).toList();

    if (olderEntries.isEmpty) return false;

    final recentAvg =
        recentEntries.map((e) => e.mood.index).reduce((a, b) => a + b) /
            recentEntries.length;
    final olderAvg =
        olderEntries.map((e) => e.mood.index).reduce((a, b) => a + b) /
            olderEntries.length;

    return recentAvg > olderAvg;
  }

  static double _getAverageWordCount() {
    final entries = DatabaseService.getAllEntries();
    if (entries.isEmpty) return 0;

    final totalWords = entries.fold<int>(0, (sum, entry) {
      return sum + entry.content.split(RegExp(r'\s+')).length;
    });

    return totalWords / entries.length;
  }

  // Get mood trend data for charts (last 7 days)
  static List<Map<String, dynamic>> getMoodTrendData() {
    final data = <Map<String, dynamic>>[];
    final now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final entries = DatabaseService.getEntriesByDate(date);

      double avgMood = 0;
      if (entries.isNotEmpty) {
        avgMood = entries.map((e) => e.mood.index).reduce((a, b) => a + b) /
            entries.length;
      }

      data.add({
        'date': date,
        'mood': avgMood,
        'hasEntry': entries.isNotEmpty,
      });
    }

    return data;
  }
}
