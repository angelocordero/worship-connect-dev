import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/wc_core/wc_themes_provider.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';

class ThemeSelectionCard extends ConsumerWidget {
  const ThemeSelectionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WCThemeProvider _wcThemeNotifier = ref.watch(wcThemeProvider.notifier);
    final ThemeMode _wcTheme = ref.watch(wcThemeProvider);

    return Center(
      child: SizedBox(
        height: 260,
        width: 250,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme',
                  style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                _lightRadioButton(_wcThemeNotifier, _wcTheme),
                _darkRadioButton(_wcThemeNotifier, _wcTheme),
                _systemDefaultRadioButton(_wcThemeNotifier, _wcTheme),
                _exitButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _systemDefaultRadioButton(WCThemeProvider _wcThemeNotifier, ThemeMode _wcTheme) {
    return Row(
      children: [
        Radio<ThemeMode>(
          value: ThemeMode.system,
          groupValue: _wcTheme,
          onChanged: (value) {
            _wcThemeNotifier.toggleTheme(value!);
          },
        ),
        const Text('System Default'),
      ],
    );
  }

  Row _darkRadioButton(WCThemeProvider _wcThemeNotifier, ThemeMode _wcTheme) {
    return Row(
      children: [
        Radio<ThemeMode>(
          value: ThemeMode.dark,
          groupValue: _wcTheme,
          onChanged: (value) {
            _wcThemeNotifier.toggleTheme(value!);
          },
        ),
        const Text('Dark'),
      ],
    );
  }

  Row _lightRadioButton(WCThemeProvider _wcThemeNotifier, ThemeMode _wcTheme) {
    return Row(
      children: [
        Radio<ThemeMode>(
          value: ThemeMode.light,
          groupValue: _wcTheme,
          onChanged: (value) {
            _wcThemeNotifier.toggleTheme(value!);
          },
        ),
        const Text('Light'),
      ],
    );
  }

  Align _exitButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: const Text('Exit'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
