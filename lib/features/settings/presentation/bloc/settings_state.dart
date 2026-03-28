import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final double fontSizeDelta;
  final bool isNotificationsEnabled;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.fontSizeDelta = 0.0,
    this.isNotificationsEnabled = true,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    double? fontSizeDelta,
    bool? isNotificationsEnabled,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      fontSizeDelta: fontSizeDelta ?? this.fontSizeDelta,
      isNotificationsEnabled: isNotificationsEnabled ?? this.isNotificationsEnabled,
    );
  }

  @override
  List<Object?> get props => [themeMode, fontSizeDelta, isNotificationsEnabled];
}
