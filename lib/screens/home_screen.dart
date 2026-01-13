import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/journal_provider.dart';
import '../widgets/entry_card.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import 'add_entry_screen.dart';
import 'entry_detail_screen.dart';
import 'calendar_screen.dart';
import 'todo_screen.dart';
import 'insights_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const _HomeContent(),
    const CalendarScreen(),
    const TodoScreen(),
    const InsightsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.paperMedium,
          border: Border(
            top: BorderSide(
              color: AppColors.sketchBorder,
              width: 2,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_rounded, 'Home', 0),
                _buildNavItem(Icons.calendar_today_rounded, 'Calendar', 1),
                _buildNavItem(Icons.checklist_rounded, 'To-Do', 2),
                _buildNavItem(Icons.insights_rounded, 'Insights', 3),
                _buildNavItem(Icons.settings_rounded, 'Settings', 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.watercolorYellow : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: AppColors.sketchBorder,
                  width: 2,
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.inkDark : AppColors.inkLight,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.inkDark : AppColors.inkLight,
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

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
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.getMaxContentWidth(context),
            ),
            child: Column(
              children: [
                _buildHeader(context),
                _buildStats(context),
                Expanded(
                  child: _buildEntriesList(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: ResponsiveHelper.getResponsiveHorizontalPadding(context)
          .copyWith(top: 24, bottom: 24),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handwritten style title
              Text(
                AppConstants.appName,
                style: GoogleFonts.indieFlower(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 36),
                  fontWeight: FontWeight.bold,
                  color: AppColors.inkDark,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppConstants.appTagline,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Consumer<JournalProvider>(
      builder: (context, provider, child) {
        final streak = provider.getCurrentStreak();
        final totalEntries = provider.entryCount;

        return Padding(
          padding: ResponsiveHelper.getResponsiveHorizontalPadding(context),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  '🔥',
                  '$streak Day${streak != 1 ? 's' : ''}',
                  'Current Streak',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  context,
                  '📝',
                  '$totalEntries',
                  'Total Entries',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
      BuildContext context, String emoji, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Sticky note style
        color: AppColors.watercolorYellow,
        borderRadius: BorderRadius.circular(4),
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
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.indieFlower(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.inkDark,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  color: AppColors.inkMedium,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntriesList(BuildContext context) {
    return Consumer<JournalProvider>(
      builder: (context, provider, child) {
        if (provider.entries.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '📖',
                    style: TextStyle(fontSize: 80),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No entries yet',
                    style: GoogleFonts.indieFlower(
                      fontSize:
                          ResponsiveHelper.getResponsiveFontSize(context, 28),
                      fontWeight: FontWeight.bold,
                      color: AppColors.inkDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start your journaling journey!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddEntryScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create First Entry'),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(
                ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 24.0,
                  tablet: 32.0,
                  desktop: 40.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Entries',
                    style: GoogleFonts.indieFlower(
                      fontSize:
                          ResponsiveHelper.getResponsiveFontSize(context, 24),
                      fontWeight: FontWeight.bold,
                      color: AppColors.inkDark,
                    ),
                  ),
                  FloatingActionButton(
                    heroTag: 'add_entry',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddEntryScreen(),
                        ),
                      );
                    },
                    mini: true,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding:
                    ResponsiveHelper.getResponsiveHorizontalPadding(context),
                itemCount: provider.entries.length,
                itemBuilder: (context, index) {
                  final entry = provider.entries[index];
                  return EntryCard(
                    entry: entry,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EntryDetailScreen(entryId: entry.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
