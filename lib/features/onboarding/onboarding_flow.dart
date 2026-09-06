import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/workspace_type.dart';
import '../../core/services/settings_controller.dart';
import '../../core/theme/noto_theme_mode.dart';
import 'screens/appearance_screen.dart';
import 'screens/choose_folder_screen.dart';
import 'screens/local_storage_screen.dart';
import 'screens/ready_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/workspace_type_screen.dart';
import 'widgets/onboarding_scaffold.dart';

/// Orchestrates the six onboarding screens. This isn't a stack of
/// Navigator routes — it's a single flow with its own step counter, so
/// going "back" moves within the flow rather than leaving it.
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _step = 0;
  late WorkspaceType _workspaceType;
  late NotoThemeMode _themeMode;
  bool _initialized = false;

  void _next() => setState(() => _step = (_step + 1).clamp(0, 5));
  void _back() => setState(() => _step = (_step - 1).clamp(0, 5));

  void _selectWorkspace(WorkspaceType type) {
    setState(() => _workspaceType = type);
    context.read<SettingsController>().setWorkspaceType(type);
  }

  void _selectTheme(NotoThemeMode mode) {
    setState(() => _themeMode = mode);
    context.read<SettingsController>().setThemeMode(mode);
  }

  Future<void> _finish() async {
    await context.read<SettingsController>().completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();
    if (!_initialized) {
      _workspaceType = settingsController.settings.workspaceType;
      _themeMode = settingsController.settings.themeMode;
      _initialized = true;
    }

    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _step > 0) _back();
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: KeyedSubtree(
          key: ValueKey(_step),
          child: _screenFor(_step, settingsController),
        ),
      ),
    );
  }

  Widget _screenFor(int step, SettingsController settingsController) {
    switch (step) {
      case 0:
        return WelcomeScreen(onNext: _next);
      case 1:
        return LocalStorageScreen(onNext: _next, onBack: _back);
      case 2:
        return ChooseFolderScreen(onNext: _next, onBack: _back);
      case 3:
        return OnboardingScaffold(
          stepIndex: 3,
          stepCount: 6,
          primaryLabel: 'Continue',
          onPrimary: _next,
          onBack: _back,
          child: WorkspaceTypeScreen(
            selected: _workspaceType,
            onSelect: _selectWorkspace,
          ),
        );
      case 4:
        return OnboardingScaffold(
          stepIndex: 4,
          stepCount: 6,
          primaryLabel: 'Continue',
          onPrimary: _next,
          onBack: _back,
          child: AppearanceScreen(
            selected: _themeMode,
            onSelect: _selectTheme,
          ),
        );
      default:
        return OnboardingScaffold(
          stepIndex: 5,
          stepCount: 6,
          primaryLabel: 'Open Noto',
          onPrimary: _finish,
          onBack: _back,
          child: ReadyScreen(settings: settingsController.settings),
        );
    }
  }
}
