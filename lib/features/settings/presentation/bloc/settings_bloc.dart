import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blogapps/features/settings/domain/repositories/settings_repository.dart';
import 'package:blogapps/features/settings/presentation/bloc/settings_event.dart';
import 'package:blogapps/features/settings/presentation/bloc/settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _repository;

  SettingsBloc(this._repository) : super(const SettingsState()) {
    on<SettingsLoad>(_onLoad);
    on<SettingsUpdateTheme>(_onUpdateTheme);
    on<SettingsUpdateFontSize>(_onUpdateFontSize);
    on<SettingsToggleNotifications>(_onToggleNotifications);
    
    add(SettingsLoad());
  }

  void _onLoad(SettingsLoad event, Emitter<SettingsState> emit) {
    emit(state.copyWith(
      themeMode: _repository.getThemeMode(),
      fontSizeDelta: _repository.getFontSizeDelta(),
      isNotificationsEnabled: _repository.isNotificationsEnabled(),
    ));
  }

  Future<void> _onUpdateTheme(SettingsUpdateTheme event, Emitter<SettingsState> emit) async {
    await _repository.setThemeMode(event.themeMode);
    emit(state.copyWith(themeMode: event.themeMode));
  }

  Future<void> _onUpdateFontSize(SettingsUpdateFontSize event, Emitter<SettingsState> emit) async {
    await _repository.setFontSizeDelta(event.fontSizeDelta);
    emit(state.copyWith(fontSizeDelta: event.fontSizeDelta));
  }

  Future<void> _onToggleNotifications(SettingsToggleNotifications event, Emitter<SettingsState> emit) async {
    await _repository.setNotificationsEnabled(event.enabled);
    emit(state.copyWith(isNotificationsEnabled: event.enabled));
  }
}
