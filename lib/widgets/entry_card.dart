import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/journal_entry.dart';
import '../models/mood.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';

class EntryCard extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback onTap;

  const EntryCard({
    super.key,
    required this.entry,
    required this.onTap,
  });

  // Get watercolor background for each mood
  Color _getMoodWatercolorBg() {
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
      default:
        return AppColors.watercolorBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final watercolorBg = _getMoodWatercolorBg();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          bottom: ResponsiveHelper.getResponsiveValue(
            context,
            mobile: 16.0,
            tablet: 20.0,
            desktop: 24.0,
          ),
        ),
        decoration: BoxDecoration(
          // Polaroid-style card
          color: AppColors.polaroidBorder,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: const Offset(3, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Photo" area with watercolor mood background
            Container(
              height: isMobile ? 120 : 150,
              decoration: BoxDecoration(
                color: watercolorBg,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                border: Border.all(
                  color: AppColors.sketchLight,
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  // Subtle texture overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // Mood emoji centered
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.sketchBorder,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        entry.mood.emoji,
                        style: TextStyle(fontSize: isMobile ? 40 : 50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // White polaroid border at bottom
            Container(
              padding: EdgeInsets.all(
                ResponsiveHelper.getResponsiveValue(
                  context,
                  mobile: 16.0,
                  tablet: 20.0,
                  desktop: 24.0,
                ),
              ),
              decoration: BoxDecoration(
                color: AppColors.polaroidBorder,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
                border: Border.all(
                  color: AppColors.sketchLight,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title in handwritten style
                  Text(
                    entry.title,
                    style: GoogleFonts.indieFlower(
                      fontSize: ResponsiveHelper.getResponsiveFontSize(
                        context,
                        20,
                      ),
                      fontWeight: FontWeight.bold,
                      color: AppColors.inkDark,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Date
                  Text(
                    DateFormat('MMM dd, yyyy • hh:mm a')
                        .format(entry.createdAt),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(
                            context,
                            12,
                          ),
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  // Content preview
                  Text(
                    entry.content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          color: AppColors.inkMedium,
                        ),
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
  }
}
