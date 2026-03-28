import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

abstract class SettingsRepository {
  Future<void> setThemeMode(ThemeMode themeMode);
  ThemeMode getThemeMode();
  
  Future<void> setFontSizeDelta(double delta);
  double getFontSizeDelta();
  
  Future<void> setNotificationsEnabled(bool enabled);
  bool isNotificationsEnabled();
}

class SettingsRepositoryImpl implements SettingsRepository {
  final Box _box;
  static const _themeKey = 'theme_mode';
  static const _fontSizeKey = 'font_size_delta';
  static const _notifKey = 'notifications_enabled';

  SettingsRepositoryImpl(this._box);

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _box.put(_themeKey, themeMode.index);
  }

  @override
  ThemeMode getThemeMode() {
    final index = _box.get(_themeKey, defaultValue: ThemeMode.system.index);
    return ThemeMode.values[index];
  }

  @override
  Future<void> setFontSizeDelta(double delta) async {
    await _box.put(_fontSizeKey, delta);
  }

  @override
  double getFontSizeDelta() {
    return _box.get(_fontSizeKey, defaultValue: 0.0);
  }

  @override
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _box.put(_notifKey, enabled);
  }

  @override
  bool isNotificationsEnabled() {
    return _box.get(_notifKey, defaultValue: true);
  }
}
