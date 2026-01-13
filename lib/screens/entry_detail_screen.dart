import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/journal_entry.dart';
import '../models/mood.dart';
import '../providers/journal_provider.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import 'add_entry_screen.dart';

class EntryDetailScreen extends StatelessWidget {
  final String entryId;

  const EntryDetailScreen({super.key, required this.entryId});

  // Get watercolor background for each mood
  Color _getMoodWatercolorBg(JournalEntry entry) {
    switch (entry.mood) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<JournalProvider>();
    final entry = provider.getEntryById(entryId);

    if (entry == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Entry not found',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    final watercolorBg = _getMoodWatercolorBg(entry);

    return Scaffold(
      body: Container(
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
          child: Column(
            children: [
              _buildAppBar(context, entry),
              Expanded(
                child: SingleChildScrollView(
                  padding: ResponsiveHelper.getResponsivePadding(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMoodBadge(context, entry, watercolorBg),
                      const SizedBox(height: 24),
                      _buildTitle(context, entry),
                      const SizedBox(height: 16),
                      _buildMetadata(context, entry),
                      const SizedBox(height: 32),
                      _buildContent(context, entry),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, JournalEntry entry) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.paperMedium,
              side: BorderSide(
                color: AppColors.sketchBorder,
                width: 2,
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEntryScreen(entryId: entry.id),
                ),
              );
            },
            icon: const Icon(Icons.edit_rounded),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.watercolorYellow,
              side: BorderSide(
                color: AppColors.sketchBorder,
                width: 2,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _showDeleteDialog(context, entry),
            icon: const Icon(Icons.delete_rounded),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.watercolorPink,
              side: BorderSide(
                color: AppColors.sketchBorder,
                width: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodBadge(
      BuildContext context, JournalEntry entry, Color watercolorBg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: watercolorBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.sketchBorder,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: watercolorBg.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            entry.mood.emoji,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 12),
          Text(
            entry.mood.displayName,
            style: GoogleFonts.indieFlower(
              color: AppColors.inkDark,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, JournalEntry entry) {
    return Text(
      entry.title,
      style: GoogleFonts.indieFlower(
        fontSize: ResponsiveHelper.getResponsiveFontSize(context, 32),
        fontWeight: FontWeight.bold,
        color: AppColors.inkDark,
        height: 1.2,
      ),
    );
  }

  Widget _buildMetadata(BuildContext context, JournalEntry entry) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today_rounded,
          size: 18,
          color: AppColors.inkMedium,
        ),
        const SizedBox(width: 8),
        Text(
          DateFormat('EEEE, MMMM dd, yyyy').format(entry.createdAt),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(width: 16),
        Icon(
          Icons.access_time_rounded,
          size: 18,
          color: AppColors.inkMedium,
        ),
        const SizedBox(width: 8),
        Text(
          DateFormat('hh:mm a').format(entry.createdAt),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, JournalEntry entry) {
    return Container(
      padding: const EdgeInsets.all(24),
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
        // Subtle paper texture
        image: DecorationImage(
          image: AssetImage('assets/images/paper_texture.png'),
          repeat: ImageRepeat.repeat,
          opacity: 0.2,
        ),
      ),
      child: Text(
        entry.content,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.8,
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
              color: AppColors.inkDark,
            ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, JournalEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.paperLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColors.sketchBorder,
            width: 2,
          ),
        ),
        title: Text(
          'Delete Entry',
          style: GoogleFonts.indieFlower(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.inkDark,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this entry?',
          style: TextStyle(color: AppColors.inkMedium),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.inkMedium)),
          ),
          ElevatedButton(
            onPressed: () async {
              final provider = context.read<JournalProvider>();
              await provider.deleteEntry(entry.id);
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to previous screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Entry deleted'),
                    backgroundColor: AppColors.watercolorPink,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.watercolorPink,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
