import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/journal_entry.dart';
import '../models/mood.dart';
import '../providers/journal_provider.dart';
import '../widgets/mood_selector.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';

class AddEntryScreen extends StatefulWidget {
  final String? entryId;

  const AddEntryScreen({super.key, this.entryId});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  Mood? _selectedMood;
  bool _isEditing = false;
  JournalEntry? _existingEntry;

  @override
  void initState() {
    super.initState();
    if (widget.entryId != null) {
      _isEditing = true;
      _loadEntry();
    }
  }

  void _loadEntry() {
    final provider = context.read<JournalProvider>();
    _existingEntry = provider.getEntryById(widget.entryId!);
    if (_existingEntry != null) {
      _titleController.text = _existingEntry!.title;
      _contentController.text = _existingEntry!.content;
      _selectedMood = _existingEntry!.mood;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all fields'),
          backgroundColor: AppColors.watercolorPink,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a mood'),
          backgroundColor: AppColors.watercolorPink,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final provider = context.read<JournalProvider>();

    if (_isEditing && _existingEntry != null) {
      // Update existing entry
      _existingEntry!.title = _titleController.text;
      _existingEntry!.content = _contentController.text;
      _existingEntry!.mood = _selectedMood!;
      await provider.updateEntry(_existingEntry!);
    } else {
      // Create new entry
      final entry = JournalEntry(
        id: const Uuid().v4(),
        title: _titleController.text,
        content: _contentController.text,
        mood: _selectedMood!,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await provider.addEntry(entry);
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Entry updated! ✓' : 'Entry saved! ✓',
          ),
          backgroundColor: AppColors.watercolorGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              _buildAppBar(),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ResponsiveHelper.getMaxContentWidth(context),
                    ),
                    child: SingleChildScrollView(
                      padding: ResponsiveHelper.getResponsiveHorizontalPadding(
                              context)
                          .copyWith(top: 24, bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitleField(),
                          const SizedBox(height: 24),
                          MoodSelector(
                            selectedMood: _selectedMood,
                            onMoodSelected: (mood) {
                              setState(() => _selectedMood = mood);
                            },
                          ),
                          const SizedBox(height: 24),
                          _buildContentField(),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _saveEntry,
                              child: Text(
                                _isEditing ? 'Update Entry' : 'Save Entry',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
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
          const SizedBox(width: 16),
          Text(
            _isEditing ? 'Edit Entry' : 'New Entry',
            style: GoogleFonts.indieFlower(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 28),
              fontWeight: FontWeight.bold,
              color: AppColors.inkDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      style: GoogleFonts.indieFlower(
        fontSize: ResponsiveHelper.getResponsiveFontSize(context, 22),
        fontWeight: FontWeight.w600,
        color: AppColors.inkDark,
      ),
      decoration: InputDecoration(
        hintText: 'Entry title...',
        hintStyle: GoogleFonts.indieFlower(
          fontSize: ResponsiveHelper.getResponsiveFontSize(context, 22),
          color: AppColors.textSecondary,
        ),
        prefixIcon: Icon(
          Icons.title_rounded,
          color: AppColors.inkMedium,
        ),
      ),
    );
  }

  Widget _buildContentField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.paperLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.sketchBorder,
          width: 1.5,
        ),
        // Lined paper effect
        image: DecorationImage(
          image: AssetImage('assets/images/paper_texture.png'),
          repeat: ImageRepeat.repeat,
          opacity: 0.2,
        ),
      ),
      child: TextField(
        controller: _contentController,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.8,
              color: AppColors.inkDark,
            ),
        decoration: InputDecoration(
          hintText: 'Write your thoughts...',
          hintStyle: TextStyle(
            fontStyle: FontStyle.italic,
            color: AppColors.textSecondary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
        maxLines: ResponsiveHelper.getResponsiveValue(
          context,
          mobile: 12,
          tablet: 15,
          desktop: 18,
        ),
        textAlignVertical: TextAlignVertical.top,
      ),
    );
  }
}
