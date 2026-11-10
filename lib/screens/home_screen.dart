import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../data/project_info.dart';
import '../models/block_category.dart';
import '../widgets/app_logo.dart';
import 'block_list_tab.dart';
import 'project_info_tab.dart';

// The only screen of the app. It has six tabs:
//   Home         - project details
//   Gates        - the seven logic gates
//   Using NAND   - gates built from NAND gates only
//   Using NOR    - gates built from NOR gates only
//   Adders       - half adder and full adder
//   Subtractors  - half subtractor and full subtractor
class HomeScreen extends StatelessWidget {
  // Whether the dark version is on, and what the theme button does.
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: palette.appBar,
          title: Row(
            children: [
              const AppLogo(size: 34),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  ProjectInfo.appName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: palette.headingText,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            // The dark mode switch: a moon in the light version,
            // a sun in the dark version.
            IconButton(
              key: const Key('theme-toggle'),
              tooltip: isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
              onPressed: onToggleDarkMode,
              icon: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: palette.primaryDark,
              ),
            ),
            const SizedBox(width: 4),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            labelColor: palette.primaryDark,
            unselectedLabelColor: palette.mutedText,
            indicatorColor: palette.primary,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700),
            tabs: [
              const Tab(text: 'Home'),
              Tab(text: BlockCategory.gates.label),
              Tab(text: BlockCategory.nandCircuits.label),
              Tab(text: BlockCategory.norCircuits.label),
              Tab(text: BlockCategory.adders.label),
              Tab(text: BlockCategory.subtractors.label),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ProjectInfoTab(),
            BlockListTab(category: BlockCategory.gates),
            BlockListTab(category: BlockCategory.nandCircuits),
            BlockListTab(category: BlockCategory.norCircuits),
            BlockListTab(category: BlockCategory.adders),
            BlockListTab(category: BlockCategory.subtractors),
          ],
        ),
      ),
    );
  }
}
