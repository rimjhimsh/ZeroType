import 'dart:io';

class SoundService {
  /// 錄音開始音效 (macOS Native Dictation Start)
  static Future<void> playStartSound() async {
    await _play('/System/Library/PrivateFrameworks/SpeechObjects.framework/Versions/A/Frameworks/DictationServices.framework/Versions/A/Resources/DefaultRecognitionSound.aiff');
  }

  /// 錄音結束音效 (macOS Native Dictation End - Using Submarine as it's closer to the punchy feedback)
  static Future<void> playStopSound() async {
    await _play('/System/Library/Sounds/Submarine.aiff');
  }

  /// 錄音取消音效
  static Future<void> playCancelSound() async {
    await _play('/System/Library/Sounds/Basso.aiff');
  }

  /// 暫停背景音樂 (Apple Music & Spotify)
  static Future<void> pauseMusic() async {
    if (!Platform.isMacOS) return;
    final script = '''
      tell application "Music"
        if it is running then pause
      end tell
      tell application "Spotify"
        if it is running then pause
      end tell
    ''';
    await Process.run('osascript', ['-e', script]);
  }

  /// 恢復背景音樂 (Apple Music & Spotify)
  static Future<void> resumeMusic() async {
    if (!Platform.isMacOS) return;
    final script = '''
      tell application "Music"
        if it is running then play
      end tell
      tell application "Spotify"
        if it is running then play
      end tell
    ''';
    await Process.run('osascript', ['-e', script]);
  }

  static Future<void> _play(String path) async {
    if (!Platform.isMacOS) return;
    try {
      // 使用 afplay 播放，這是 macOS 內建指令
      await Process.run('afplay', [path]);
    } catch (_) {
      // 忽略音效錯誤
    }
  }
}
