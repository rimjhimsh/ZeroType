import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

part 'settings_state.freezed.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(false) bool launchAtStartup,
    required HotKey hotkey,
    @Default(false) bool isAccessibilityAuthorized,
    @Default(false) bool isMicrophoneAuthorized,
    @Default(false) bool isRecordingHotkey,
  }) = _SettingsState;
}
