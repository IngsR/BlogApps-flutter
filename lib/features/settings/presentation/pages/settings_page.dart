import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:blogapps/core/theme/app_effects.dart';
import 'package:blogapps/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:blogapps/features/settings/presentation/bloc/settings_event.dart';
import 'package:blogapps/features/settings/presentation/bloc/settings_state.dart';
import 'package:blogapps/features/settings/presentation/widgets/theme_selection_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const GradientText(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          _SectionTitle(title: 'Personalization').animate().fadeIn(delay: 200.ms),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return GlassCard(
                padding: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ThemeSelectionCard(
                      mode: ThemeMode.light,
                      icon: Icons.light_mode_rounded,
                      label: 'Light',
                      isSelected: state.themeMode == ThemeMode.light,
                      onTap: () => context.read<SettingsBloc>().add(SettingsUpdateTheme(ThemeMode.light)),
                    ),
                    ThemeSelectionCard(
                      mode: ThemeMode.dark,
                      icon: Icons.dark_mode_rounded,
                      label: 'Dark',
                      isSelected: state.themeMode == ThemeMode.dark,
                      onTap: () => context.read<SettingsBloc>().add(SettingsUpdateTheme(ThemeMode.dark)),
                    ),
                    ThemeSelectionCard(
                      mode: ThemeMode.system,
                      icon: Icons.settings_brightness_rounded,
                      label: 'System',
                      isSelected: state.themeMode == ThemeMode.system,
                      onTap: () => context.read<SettingsBloc>().add(SettingsUpdateTheme(ThemeMode.system)),
                    ),
                  ],
                ),
              );
            },
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
          const SizedBox(height: 24),
          
          _SectionTitle(title: 'Accessibility'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.format_size_rounded),
                      const SizedBox(width: 16),
                      const Text('Text Scale', style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      BlocBuilder<SettingsBloc, SettingsState>(
                        builder: (context, state) {
                          return Text('${((1.0 + state.fontSizeDelta) * 100).toInt()}%');
                        },
                      ),
                    ],
                  ),
                  BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                      return Slider(
                        value: state.fontSizeDelta,
                        min: -0.2,
                        max: 0.5,
                        onChanged: (value) {
                          context.read<SettingsBloc>().add(SettingsUpdateFontSize(value));
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          _SectionTitle(title: 'About the Author'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=admin'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Admin Blog',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Software Engineer & Content Creator. Sharing my thoughts on technology and lifestyle.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SocialIcon(icon: Icons.language_rounded, onTap: () {}),
                      _SocialIcon(icon: Icons.code_rounded, onTap: () {}),
                      _SocialIcon(icon: Icons.mail_rounded, onTap: () {}),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          _SectionTitle(title: 'App Info'),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('Version'),
            trailing: const Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Made with ♥ using Flutter',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SocialIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Theme.of(context).colorScheme.primary),
    );
  }
}
