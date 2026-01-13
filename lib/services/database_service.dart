import 'package:hive/hive.dart';
import '../models/journal_entry.dart';
import '../models/mood.dart';
import '../utils/constants.dart';

class DatabaseService {
  static Box<JournalEntry>? _journalBox;

  // Initialize Hive and open boxes
  static Future<void> init() async {
    _journalBox = await Hive.openBox<JournalEntry>(AppConstants.journalBoxName);
  }

  // Get all journal entries
  static List<JournalEntry> getAllEntries() {
    return _journalBox?.values.toList() ?? [];
  }

  // Get entries sorted by date (newest first)
  static List<JournalEntry> getEntriesSorted() {
    final entries = getAllEntries();
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }

  // Get entries for a specific date
  static List<JournalEntry> getEntriesByDate(DateTime date) {
    return getAllEntries().where((entry) {
      return entry.createdAt.year == date.year &&
          entry.createdAt.month == date.month &&
          entry.createdAt.day == date.day;
    }).toList();
  }

  // Get entries for a month
  static List<JournalEntry> getEntriesByMonth(int year, int month) {
    return getAllEntries().where((entry) {
      return entry.createdAt.year == year && entry.createdAt.month == month;
    }).toList();
  }

  // Add new entry
  static Future<void> addEntry(JournalEntry entry) async {
    await _journalBox?.put(entry.id, entry);
  }

  // Update existing entry
  static Future<void> updateEntry(JournalEntry entry) async {
    entry.updatedAt = DateTime.now();
    await _journalBox?.put(entry.id, entry);
  }

  // Delete entry
  static Future<void> deleteEntry(String id) async {
    await _journalBox?.delete(id);
  }

  // Get entry by ID
  static JournalEntry? getEntryById(String id) {
    return _journalBox?.get(id);
  }

  // Get total count
  static int getTotalCount() {
    return _journalBox?.length ?? 0;
  }

  // Get entries by mood
  static List<JournalEntry> getEntriesByMood(Mood mood) {
    return getAllEntries().where((entry) => entry.mood == mood).toList();
  }

  // Get mood distribution
  static Map<Mood, int> getMoodDistribution() {
    final distribution = <Mood, int>{};
    for (var mood in Mood.values) {
      distribution[mood] = 0;
    }

    for (var entry in getAllEntries()) {
      distribution[entry.mood] = (distribution[entry.mood] ?? 0) + 1;
    }

    return distribution;
  }

  // Get current streak (consecutive days with entries)
  static int getCurrentStreak() {
    final entries = getEntriesSorted();
    if (entries.isEmpty) return 0;

    int streak = 0;
    DateTime currentDate = DateTime.now();

    for (int i = 0; i < 365; i++) {
      final hasEntry = entries.any((entry) =>
          entry.createdAt.year == currentDate.year &&
          entry.createdAt.month == currentDate.month &&
          entry.createdAt.day == currentDate.day);

      if (hasEntry) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else if (i == 0) {
        // Check yesterday for grace period
        currentDate = currentDate.subtract(const Duration(days: 1));
        final hasYesterdayEntry = entries.any((entry) =>
            entry.createdAt.year == currentDate.year &&
            entry.createdAt.month == currentDate.month &&
            entry.createdAt.day == currentDate.day);

        if (hasYesterdayEntry) {
          streak++;
          currentDate = currentDate.subtract(const Duration(days: 1));
        } else {
          break;
        }
      } else {
        break;
      }
    }

    return streak;
  }

  // Clear all data
  static Future<void> clearAll() async {
    await _journalBox?.clear();
  }
}
