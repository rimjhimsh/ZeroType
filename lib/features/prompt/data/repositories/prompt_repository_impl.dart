import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zero_type/core/constants/app_constants.dart';
import 'package:zero_type/features/prompt/domain/repositories/prompt_repository.dart';

class PromptRepositoryImpl implements PromptRepository {
  PromptRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  @override
  Future<String> getDefaultSpeechPrompt() async {
    final file = File('prompts/SpeechToText.prompt');
    print('[PromptRepo] (CWD: ${Directory.current.path}) Checking for default: ${file.absolute.path}');
    try {
      if (await file.exists()) {
        final content = (await file.readAsString()).trim();
        print('[PromptRepo] SUCCESS: Read from SpeechToText.prompt: ${content.length} chars');
        return content;
      } else {
        print('[PromptRepo] NOT FOUND: SpeechToText.prompt at ${file.absolute.path}');
      }
    } catch (e) {
      print('[PromptRepo] ERROR reading SpeechToText.prompt: $e');
    }
    
    print('[PromptRepo] Using hardcoded fallback.');
    return '請將語音精確轉換成繁體中文，並依語意加上適當的標點符號。';
  }


  @override
  Future<String> getSpeechPrompt() async {
    print('[PromptRepo] Loading current speech prompt...');
    // 1. Try Custom file first
    try {
      final file = File('prompts/SpeechToText_Custom.prompt');
      if (await file.exists()) {
        final content = (await file.readAsString()).trim();
        if (content.isNotEmpty) {
          print('[PromptRepo] Loaded from SpeechToText_Custom.prompt');
          return content;
        }
      }
    } catch (e) {
      print('[PromptRepo] Error reading SpeechToText_Custom.prompt: $e');
    }

    // 2. Fallback to Default file or assets
    return await getDefaultSpeechPrompt();
  }

  @override
  Future<String> saveSpeechPrompt(String prompt) async {
    final cleaned = prompt.trim();
    print('[PromptRepo] Saving speech prompt to SpeechToText_Custom.prompt...');
    try {
      final file = File('prompts/SpeechToText_Custom.prompt');
      await file.writeAsString(cleaned, flush: true);
      print('[PromptRepo] Saved successfully.');
    } catch (e) {
      print('[PromptRepo] Error saving SpeechToText_Custom.prompt: $e');
    }
    await _prefs.setString(AppConstants.speechPromptKey, cleaned);
    return cleaned;
  }


  @override
  Future<String> resetSpeechPrompt() async {
    print('[PromptRepo] Resetting speech prompt (deleting custom file)...');
    try {
      final file = File('prompts/SpeechToText_Custom.prompt');
      if (await file.exists()) {
        await file.delete();
        print('[PromptRepo] Custom file deleted.');
      }
    } catch (e) {
      print('[PromptRepo] Error deleting custom file: $e');
    }
    await _prefs.remove(AppConstants.speechPromptKey);
    return await getDefaultSpeechPrompt();
  }

}
