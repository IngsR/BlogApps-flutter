import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SettingsUpdateTheme extends SettingsEvent {
  final ThemeMode themeMode;
  SettingsUpdateTheme(this.themeMode);
  @override
  List<Object?> get props => [themeMode];
}

class SettingsUpdateFontSize extends SettingsEvent {
  final double fontSizeDelta;
  SettingsUpdateFontSize(this.fontSizeDelta);
  @override
  List<Object?> get props => [fontSizeDelta];
}

class SettingsToggleNotifications extends SettingsEvent {
  final bool enabled;
  SettingsToggleNotifications(this.enabled);
  @override
  List<Object?> get props => [enabled];
}

class SettingsLoad extends SettingsEvent {}
