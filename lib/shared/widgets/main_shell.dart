import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:zero_type/core/router/app_router.dart';
import 'package:zero_type/shared/widgets/recording_overlay.dart';

@RoutePage()
class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildMain(),
        const RecordingOverlay(),
      ],
    );
  }

  Widget _buildMain() {
    return AutoTabsRouter(
      routes: const [
        ModelConfigRoute(),
        PromptRoute(),
        DictionaryRoute(),
        SettingsRoute(),
        // TestingRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: Column(
            children: [
              // Top Navigation Bar
              Container(
                height: 44, // Narrower navigation bar
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: Theme.of(context).colorScheme.surface,
                child: Center(
                  child: Text(
                    'Zero Type',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1),
              Expanded(
                child: Row(
                  children: [
                    NavigationRail(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      selectedIndex: tabsRouter.activeIndex,
                      onDestinationSelected: tabsRouter.setActiveIndex,
                      labelType: NavigationRailLabelType.all,
                      leading: const SizedBox(height: 16), // Adjust to align with content
                      selectedIconTheme: IconThemeData(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.tune_outlined),
                          selectedIcon: Icon(Icons.tune),
                          label: Text('模型'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.edit_note_outlined),
                          selectedIcon: Icon(Icons.edit_note),
                          label: Text('提示詞'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.book_outlined),
                          selectedIcon: Icon(Icons.book),
                          label: Text('字典檔'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.settings_outlined),
                          selectedIcon: Icon(Icons.settings),
                          label: Text('設定'),
                        ),
                        /*
                        NavigationRailDestination(
                          icon: Icon(Icons.science_outlined),
                          selectedIcon: Icon(Icons.science),
                          label: Text('測試'),
                        ),
                        */
                      ],
                    ),
                    const VerticalDivider(thickness: 1, width: 1),
                    Expanded(child: child),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
