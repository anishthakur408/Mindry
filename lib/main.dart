import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/journal_entry.dart';
import 'models/mood.dart';
import 'models/todo.dart';
import 'providers/journal_provider.dart';
import 'providers/todo_provider.dart';
import 'services/database_service.dart';
import 'services/todo_database_service.dart';
import 'services/preferences_service.dart';
import 'screens/splash_screen.dart';
import 'utils/theme.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(JournalEntryAdapter());
  Hive.registerAdapter(MoodAdapter());

  // Initialize database and preferences
  await DatabaseService.init();
  await TodoDatabaseService.init();
  await PreferencesService.init();

  // Track last opened date
  await PreferencesService.setLastOpenedDate(DateTime.now());

  runApp(const MindFlowApp());
}

class MindFlowApp extends StatelessWidget {
  const MindFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JournalProvider()..loadEntries()),
        ChangeNotifierProvider(create: (_) => TodoProvider()..loadTodos()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
