import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/models/app_settings.dart';
import 'core/services/settings_controller.dart';
import 'core/services/workspace_controller.dart';
import 'core/theme/noto_theme.dart';
import 'features/home/home_shell.dart';
import 'features/onboarding/onboarding_flow.dart';
import 'widgets/noto_logo.dart';

/// Wires up the two controllers Noto runs on and provides them to the
/// widget tree. Kept separate from [NotoApp] so provider setup and
/// theme/navigation logic aren't tangled together.
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  final SettingsController _settingsController = SettingsController();
  final WorkspaceController _workspaceController = WorkspaceController();
  String? _loadedPath;

  @override
  void initState() {
    super.initState();
    _settingsController.addListener(_syncWorkspaceWithFolder);
    _settingsController.load();
  }

  void _syncWorkspaceWithFolder() {
    final settings = _settingsController.settings;
    if (settings.hasStorageFolder &&
        !_settingsController.folderMissing &&
        settings.storageFolderPath != _loadedPath) {
      _loadedPath = settings.storageFolderPath;
      _workspaceController.loadFrom(settings.storageFolderPath!);
    }
  }

  @override
  void dispose() {
    _settingsController.removeListener(_syncWorkspaceWithFolder);
    _settingsController.dispose();
    _workspaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsController>.value(value: _settingsController),
        ChangeNotifierProvider<WorkspaceController>.value(value: _workspaceController),
      ],
      child: const NotoApp(),
    );
  }
}

class NotoApp extends StatelessWidget {
  const NotoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();
    final AppSettings settings = settingsController.settings;

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final theme = NotoTheme.build(
          mode: settings.themeMode,
          platformBrightness: WidgetsBinding.instance.platformDispatcher.platformBrightness,
          dynamicLight: lightDynamic,
          dynamicDark: darkDynamic,
        );

        return MaterialApp(
          title: 'Noto',
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: _resolveHome(settingsController),
        );
      },
    );
  }

  Widget _resolveHome(SettingsController controller) {
    if (controller.loading) {
      return const _SplashScreen();
    }
    if (!controller.settings.onboardingComplete) {
      return const OnboardingFlow();
    }
    return const HomeShell();
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: NotoLogo(size: 72)),
    );
  }
}
