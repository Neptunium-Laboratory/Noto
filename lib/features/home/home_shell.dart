import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/settings_controller.dart';
import '../settings/settings_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/folders_screen.dart';
import 'screens/inbox_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/search_screen.dart';
import 'screens/today_screen.dart';

/// The main workspace, shown once onboarding is complete.
///
/// Five destinations live in the bottom navigation bar (per Material 3
/// guidance on keeping a nav bar to a handful of top-level places).
/// Favorites and Settings — both still first-class parts of the
/// information architecture — are one tap away from every tab via the
/// app bar, rather than crowding the bar itself.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _titles = ['Home', 'Today', 'Projects', 'Folders'];

  static const _tabs = [
    InboxScreen(),
    TodayScreen(),
    ProjectsScreen(),
    FoldersScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Folders can go missing while the app is backgrounded (moved,
    // unmounted removable storage, revoked permission). Recheck on
    // return to the main workspace rather than only at cold start.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsController>().recheckFolder();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Search',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.star_border_rounded),
            tooltip: 'Favorites',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const FavoritesScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (settingsController.folderMissing) const _FolderMissingBanner(),
          Expanded(child: IndexedStack(index: _index, children: _tabs)),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.today_outlined), selectedIcon: Icon(Icons.today_rounded), label: 'Today'),
          NavigationDestination(icon: Icon(Icons.dashboard_customize_outlined), selectedIcon: Icon(Icons.dashboard_customize_rounded), label: 'Projects'),
          NavigationDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder_rounded), label: 'Folders'),
        ],
      ),
    );
  }
}

class _FolderMissingBanner extends StatelessWidget {
  const _FolderMissingBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.errorContainer,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: theme.colorScheme.onErrorContainer, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Your notes folder can't be found. Tap to choose a new one.",
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onErrorContainer),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onErrorContainer),
            ],
          ),
        ),
      ),
    );
  }
}
