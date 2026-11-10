import 'package:flutter/material.dart';

import '../data/project_info.dart';
import '../screens/home_screen.dart';
import 'app_theme.dart';

// The root widget of the app.
// It remembers whether the dark version is switched on.
class LogicGatesApp extends StatefulWidget {
  const LogicGatesApp({super.key});

  @override
  State<LogicGatesApp> createState() => _LogicGatesAppState();
}

class _LogicGatesAppState extends State<LogicGatesApp> {
  // The app starts in the dark version.
  bool isDarkMode = true;

  // Called by the theme button in the app bar.
  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ProjectInfo.appName,
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(isDark: false),
      darkTheme: buildAppTheme(isDark: true),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        isDarkMode: isDarkMode,
        onToggleDarkMode: toggleDarkMode,
      ),
    );
  }
}
