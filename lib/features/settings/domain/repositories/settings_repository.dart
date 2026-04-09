import 'package:flutter/material.dart';

abstract class SettingsRepository {
  Future<void> setThemeMode(ThemeMode themeMode);
  ThemeMode getThemeMode();

  Future<void> setFontSizeDelta(double delta);
  double getFontSizeDelta();

  Future<void> setNotificationsEnabled(bool enabled);
  bool isNotificationsEnabled();
}
