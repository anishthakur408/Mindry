import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/journal_provider.dart';
import '../services/database_service.dart';
import '../utils/constants.dart';
import '../utils/responsive_helper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                'Settings',
                style: GoogleFonts.indieFlower(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 36),
                  fontWeight: FontWeight.bold,
                  color: AppColors.inkDark,
                ),
              ),
              const SizedBox(height: 32),
              _buildSection(
                context,
                'Data Management',
                [
                  _buildSettingTile(
                    context,
                    Icons.delete_forever_rounded,
                    'Clear All Data',
                    'Delete all journal entries',
                    AppColors.watercolorPink,
                    () => _showClearDataDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                context,
                'About',
                [
                  _buildInfoTile(
                    context,
                    Icons.apps_rounded,
                    'App Name',
                    AppConstants.appName,
                  ),
                  _buildInfoTile(
                    context,
                    Icons.info_outline_rounded,
                    'Version',
                    '1.0.0',
                  ),
                  _buildInfoTile(
                    context,
                    Icons.code_rounded,
                    'Developer',
                    'Plorix Studio',
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  '🧠 ${AppConstants.appTagline}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title,
            style: GoogleFonts.indieFlower(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.bold,
              color: AppColors.inkMedium,
            ),
          ),
        ),
        Container(
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
                blurRadius: 6,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.sketchBorder,
            width: 1.5,
          ),
        ),
        child: Icon(icon, color: AppColors.inkDark),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.watercolorBlue,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.sketchBorder,
            width: 1.5,
          ),
        ),
        child: Icon(icon, color: AppColors.inkDark),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: Text(
        value,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
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
          'Clear All Data',
          style: GoogleFonts.indieFlower(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.inkDark,
          ),
        ),
        content: Text(
          'Are you sure you want to delete all journal entries? This action cannot be undone.',
          style: TextStyle(color: AppColors.inkMedium),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.inkMedium)),
          ),
          ElevatedButton(
            onPressed: () async {
              await DatabaseService.clearAll();
              final provider = context.read<JournalProvider>();
              await provider.loadEntries();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('All data cleared'),
                    backgroundColor: AppColors.watercolorPink,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.watercolorPink,
            ),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }
}
