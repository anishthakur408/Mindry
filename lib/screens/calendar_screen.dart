import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/journal_provider.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';
import 'entry_detail_screen.dart';
import 'add_entry_screen.dart';


class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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
        child: Column(
          children: [
            Padding(
              padding: ResponsiveHelper.getResponsivePadding(context),
              child: Text(
                'Calendar',
                style: GoogleFonts.indieFlower(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 36),
                  fontWeight: FontWeight.bold,
                  color: AppColors.inkDark,
                ),
              ),
            ),
            _buildCalendar(),
            const SizedBox(height: 24),
            Expanded(
              child: _buildEntriesForSelectedDay(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Consumer<JournalProvider>(
      builder: (context, provider, child) {
        return Container(
          margin: ResponsiveHelper.getResponsiveHorizontalPadding(context),
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
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppColors.watercolorGreen.withValues(alpha: 0.7),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.sketchBorder,
                  width: 2,
                ),
              ),
              selectedDecoration: BoxDecoration(
                color: AppColors.watercolorPink,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.sketchBorder,
                  width: 2,
                ),
              ),
              markerDecoration: BoxDecoration(
                color: AppColors.watercolorBlue,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: GoogleFonts.indieFlower(
                color: AppColors.inkDark,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: AppColors.inkDark,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: AppColors.inkDark,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: AppColors.inkMedium),
              weekendStyle: TextStyle(color: AppColors.watercolorPink),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final hasEntry = provider.getEntriesByDate(day).isNotEmpty;
                return Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        '${day.day}',
                        style: TextStyle(color: AppColors.inkDark),
                      ),
                      if (hasEntry)
                        Positioned(
                          bottom: 4,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: AppColors.watercolorBlue,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.sketchBorder,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildEntriesForSelectedDay() {
    return Consumer<JournalProvider>(
      builder: (context, provider, child) {
        final selectedDate = _selectedDay ?? DateTime.now();
        final entries = provider.getEntriesByDate(selectedDate);

        if (entries.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'No entries for ${DateFormat('MMM dd').format(selectedDate)}',
                    style: GoogleFonts.indieFlower(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.inkDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
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
                    label: const Text('Add Entry'),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: ResponsiveHelper.getResponsiveHorizontalPadding(context),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EntryDetailScreen(entryId: entry.id),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.watercolorYellow,
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
                child: Row(
                  children: [
                    Text(
                      entry.mood.emoji,
                      style: const TextStyle(fontSize: 36),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.title,
                            style: GoogleFonts.indieFlower(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.inkDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entry.content,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
