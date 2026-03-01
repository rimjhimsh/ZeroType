import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:record/record.dart';
import 'package:zero_type/core/di/injection.dart';
import 'package:zero_type/core/services/hotkey_service.dart';
import 'settings_state.dart';

part 'settings_controller.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  Timer? _refreshTimer;

  @override
  Future<SettingsState> build() async {
    print('[SettingsController] Building state...');
    
    // Auto refresh permissions every 2 seconds when settings page is open
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 2), (_) => _refreshPermissions());
    ref.onDispose(() => _refreshTimer?.cancel());

    try {
      print('[SettingsController] Checking if launch at startup is enabled...');
      bool isLaunchEnabled = false;
      try {
        isLaunchEnabled = await launchAtStartup.isEnabled().timeout(
          const Duration(seconds: 2),
        );
      } on MissingPluginException {
        print('[SettingsController] launch_at_startup plugin not implemented or missing.');
      } catch (e) {
        print('[SettingsController] Error checking launchAtStartup: $e');
      }
      
      print('[SettingsController] Fetching current hotkey...');
      final hotkey = getIt<HotkeyService>().currentHotkey;
      
      print('[SettingsController] Fetching permissions...');
      final isAccessibilityAuthorized = await _checkAccessibility();
      final isMicrophoneAuthorized = await AudioRecorder().hasPermission();

      print('[SettingsController] Build complete.');
      return SettingsState(
        launchAtStartup: isLaunchEnabled,
        hotkey: hotkey,
        isAccessibilityAuthorized: isAccessibilityAuthorized,
        isMicrophoneAuthorized: isMicrophoneAuthorized,
      );
    } catch (e, st) {
      print('[SettingsController] Error building settings state: $e\n$st');
      rethrow;
    }
  }

  Future<void> toggleLaunchAtStartup(bool value) async {
    print('[SettingsController] Toggling launchAtStartup to $value...');
    try {
      if (value) {
        await LaunchAtStartup.instance.enable();
      } else {
        await LaunchAtStartup.instance.disable();
      }
    } on MissingPluginException {
      print('[SettingsController] toggleLaunchAtStartup failed: plugin missing.');
    } catch (e) {
      print('[SettingsController] toggleLaunchAtStartup error: $e');
    }
    ref.invalidateSelf();
  }

  void startRecordingHotkey() {
    print('[SettingsController] Starting hotkey recording...');
    final currentState = state.value;
    if (currentState == null) return;
    
    // Disable global hotkey to avoid interference
    getIt<HotkeyService>().pause();
    
    state = AsyncData(currentState.copyWith(isRecordingHotkey: true));
  }

  void stopRecordingHotkey() {
    print('[SettingsController] Stopping hotkey recording...');
    final currentState = state.value;
    if (currentState == null) return;
    
    // Re-enable global hotkey
    getIt<HotkeyService>().resume();
    
    state = AsyncData(currentState.copyWith(isRecordingHotkey: false));
  }

  Future<void> saveHotkey(List<PhysicalKeyboardKey> keys) async {
    print('[SettingsController] Saving hotkey with keys: $keys');
    
    final List<HotKeyModifier> modifiers = [];
    PhysicalKeyboardKey? mainKey;

    for (final key in keys) {
      if (key == PhysicalKeyboardKey.metaLeft || key == PhysicalKeyboardKey.metaRight) {
        if (!modifiers.contains(HotKeyModifier.meta)) modifiers.add(HotKeyModifier.meta);
      } else if (key == PhysicalKeyboardKey.controlLeft || key == PhysicalKeyboardKey.controlRight) {
        if (!modifiers.contains(HotKeyModifier.control)) modifiers.add(HotKeyModifier.control);
      } else if (key == PhysicalKeyboardKey.altLeft || key == PhysicalKeyboardKey.altRight) {
        if (!modifiers.contains(HotKeyModifier.alt)) modifiers.add(HotKeyModifier.alt);
      } else if (key == PhysicalKeyboardKey.shiftLeft || key == PhysicalKeyboardKey.shiftRight) {
        if (!modifiers.contains(HotKeyModifier.shift)) modifiers.add(HotKeyModifier.shift);
      } else {
        // Take the last non-modifier key as the main key
        mainKey = key;
      }
    }

    if (mainKey == null) {
      print('[SettingsController] No main key selected, ignoring save.');
      stopRecordingHotkey();
      return;
    }

    final newHotKey = HotKey(
      key: mainKey,
      modifiers: modifiers,
      scope: HotKeyScope.system,
    );

    await getIt<HotkeyService>().updateHotkey(newHotKey);
    
    // Stop recording and trigger refresh
    final currentState = state.value;
    if (currentState != null) {
      state = AsyncData(currentState.copyWith(
        isRecordingHotkey: false,
        hotkey: newHotKey,
      ));
    }
    
    // Resume local hotkey (already handled in stopRecordingHotkey but stay safe)
    getIt<HotkeyService>().resume();
  }

  Future<void> _refreshPermissions() async {
    final currentState = state.value;
    if (currentState == null) return;

    final isAccessibility = await _checkAccessibility();
    final isMicrophone = await AudioRecorder().hasPermission();

    if (isAccessibility != currentState.isAccessibilityAuthorized ||
        isMicrophone != currentState.isMicrophoneAuthorized) {
      state = AsyncData(currentState.copyWith(
        isAccessibilityAuthorized: isAccessibility,
        isMicrophoneAuthorized: isMicrophone,
      ));
    }
  }

  Future<bool> _checkAccessibility() async {
    // Windows doesn't require Accessibility permission for SendInput
    if (Platform.isWindows) return true;
    const channel = MethodChannel('com.zerotype.app/permission');
    try {
      return await channel.invokeMethod<bool>('checkAccessibility') ?? false;
    } catch (e) {
      print('[SettingsController] checkAccessibility error: $e');
      return false;
    }
  }
}
