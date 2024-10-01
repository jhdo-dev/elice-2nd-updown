import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme_provider.dart';

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return ListTile(
      title: Text(isDarkMode ? 'Dark Mode' : 'Light Mode'),
      subtitle: const Text('Switch between dark and light themes'),
      trailing: Switch(
        onChanged: (bool? value) {
          themeNotifier.toggleTheme();
        },
        value: !isDarkMode,
        thumbIcon:
            WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
          return !isDarkMode
              ? const Icon(Icons.wb_sunny)
              : const Icon(Icons.nightlight_round);
        }),
      ),
    );
  }
}
