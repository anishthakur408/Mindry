import 'package:flutter/foundation.dart';
import '../models/journal_entry.dart';
import '../models/mood.dart';
import '../services/database_service.dart';

class JournalProvider extends ChangeNotifier {
  List<JournalEntry> _entries = [];

  List<JournalEntry> get entries => _entries;
  int get entryCount => _entries.length;

  // Load all entries from database
  Future<void> loadEntries() async {
    _entries = DatabaseService.getEntriesSorted();
    notifyListeners();
  }

  // Add new entry
  Future<void> addEntry(JournalEntry entry) async {
    await DatabaseService.addEntry(entry);
    await loadEntries();
  }

  // Update entry
  Future<void> updateEntry(JournalEntry entry) async {
    await DatabaseService.updateEntry(entry);
    await loadEntries();
  }

  // Delete entry
  Future<void> deleteEntry(String id) async {
    await DatabaseService.deleteEntry(id);
    await loadEntries();
  }

  // Get entry by ID
  JournalEntry? getEntryById(String id) {
    return DatabaseService.getEntryById(id);
  }

  // Get entries by date
  List<JournalEntry> getEntriesByDate(DateTime date) {
    return DatabaseService.getEntriesByDate(date);
  }

  // Get current streak
  int getCurrentStreak() {
    return DatabaseService.getCurrentStreak();
  }

  // Get mood distribution
  Map<Mood, int> getMoodDistribution() {
    return DatabaseService.getMoodDistribution();
  }
}
