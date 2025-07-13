import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/ui_event.dart';

/// Main controller for managing UI interaction recording.
/// This is a singleton class that handles all recording operations.
class RecorderController extends ChangeNotifier {
  static final RecorderController _instance = RecorderController._internal();

  /// Singleton instance of RecorderController
  static RecorderController get instance => _instance;

  RecorderController._internal();

  /// List of recorded events
  final List<UIEvent> _events = [];

  /// Whether recording is currently active
  bool _isRecording = false;

  /// Current screen/route name
  String _currentScreen = '/';

  /// Configuration for the recorder
  RecorderConfig _config = RecorderConfig();

  /// Get all recorded events
  List<UIEvent> get events => List.unmodifiable(_events);

  /// Check if recording is active
  bool get isRecording => _isRecording;

  /// Get current screen
  String get currentScreen => _currentScreen;

  /// Get recorder configuration
  RecorderConfig get config => _config;

  /// Start recording events
  void start() {
    if (_isRecording) return;

    _isRecording = true;
    _events.clear();
    logEvent(
      UIEvent(
        type: EventTypes.custom,
        screen: _currentScreen,
        value: 'Recording started',
        timestamp: DateTime.now(),
        meta: {'action': 'start_recording'},
      ),
    );
    notifyListeners();
  }

  /// Stop recording events
  void stop() {
    if (!_isRecording) return;

    _isRecording = false;
    logEvent(
      UIEvent(
        type: EventTypes.custom,
        screen: _currentScreen,
        value: 'Recording stopped',
        timestamp: DateTime.now(),
        meta: {'action': 'stop_recording'},
      ),
    );
    notifyListeners();
  }

  /// Log a new event
  void logEvent(UIEvent event) {
    if (!_isRecording) return;

    // Check if this event type is enabled in config
    if (!_config.enabledEventTypes.contains(event.type)) return;

    _events.add(event);
    notifyListeners();

    if (kDebugMode) {
      print('UI Recorder: ${event.type} on ${event.screen}');
    }
  }

  /// Log a tap event
  void logTap(String widgetKey, {Map<String, dynamic>? meta}) {
    logEvent(
      UIEvent(
        type: EventTypes.tap,
        screen: _currentScreen,
        widgetKey: widgetKey,
        timestamp: DateTime.now(),
        meta: meta,
      ),
    );
  }

  /// Log a long press event
  void logLongPress(String widgetKey, {Map<String, dynamic>? meta}) {
    logEvent(
      UIEvent(
        type: EventTypes.longPress,
        screen: _currentScreen,
        widgetKey: widgetKey,
        timestamp: DateTime.now(),
        meta: meta,
      ),
    );
  }

  /// Log a text input event
  void logTextInput(
    String widgetKey,
    String value, {
    Map<String, dynamic>? meta,
  }) {
    logEvent(
      UIEvent(
        type: EventTypes.textInput,
        screen: _currentScreen,
        widgetKey: widgetKey,
        value: value,
        timestamp: DateTime.now(),
        meta: meta,
      ),
    );
  }

  /// Log a scroll event
  void logScroll(
    String widgetKey,
    String direction,
    double distance, {
    Map<String, dynamic>? meta,
  }) {
    logEvent(
      UIEvent(
        type: EventTypes.scroll,
        screen: _currentScreen,
        widgetKey: widgetKey,
        value: direction,
        timestamp: DateTime.now(),
        meta: {'distance': distance, ...?meta},
      ),
    );
  }

  /// Log a navigation event
  void logNavigation(
    String fromScreen,
    String toScreen, {
    Map<String, dynamic>? meta,
  }) {
    logEvent(
      UIEvent(
        type: EventTypes.navigation,
        screen: fromScreen,
        value: toScreen,
        timestamp: DateTime.now(),
        meta: meta,
      ),
    );
    _currentScreen = toScreen;
  }

  /// Log a custom event
  void logCustom(
    String eventName, {
    String? value,
    Map<String, dynamic>? meta,
  }) {
    logEvent(
      UIEvent(
        type: EventTypes.custom,
        screen: _currentScreen,
        widgetKey: eventName,
        value: value,
        timestamp: DateTime.now(),
        meta: meta,
      ),
    );
  }

  /// Update current screen
  void updateCurrentScreen(String screen) {
    _currentScreen = screen;
  }

  /// Clear all recorded events
  void clear() {
    _events.clear();
    notifyListeners();
  }

  /// Get events filtered by type
  List<UIEvent> getEventsByType(String type) {
    return _events.where((event) => event.type == type).toList();
  }

  /// Get events filtered by screen
  List<UIEvent> getEventsByScreen(String screen) {
    return _events.where((event) => event.screen == screen).toList();
  }

  /// Export events to JSON string
  String exportToJson() {
    final eventsJson = _events.map((event) => event.toJson()).toList();
    return jsonEncode(eventsJson);
  }

  /// Export events to JSON file
  Future<String?> exportToFile(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(exportToJson());
      return file.path;
    } catch (e) {
      if (kDebugMode) {
        print('Error exporting to file: $e');
      }
      return null;
    }
  }

  /// Load events from JSON string
  void loadFromJson(String jsonString) {
    try {
      final List<dynamic> eventsList = jsonDecode(jsonString);
      _events.clear();
      _events.addAll(
        eventsList.map(
          (json) => UIEvent.fromJson(json as Map<String, dynamic>),
        ),
      );
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading from JSON: $e');
      }
    }
  }

  /// Update recorder configuration
  void updateConfig(RecorderConfig config) {
    _config = config;
    notifyListeners();
  }

  /// Get statistics about recorded events
  Map<String, int> getEventStatistics() {
    final stats = <String, int>{};
    for (final event in _events) {
      stats[event.type] = (stats[event.type] ?? 0) + 1;
    }
    return stats;
  }
}

/// Configuration class for the recorder
class RecorderConfig {
  /// List of event types that should be recorded
  final Set<String> enabledEventTypes;

  /// Whether to include sensitive data (like passwords)
  final bool includeSensitiveData;

  /// Maximum number of events to keep in memory
  final int maxEvents;

  /// Whether to auto-save events to file
  final bool autoSave;

  /// Auto-save interval in seconds
  final int autoSaveInterval;

  const RecorderConfig({
    this.enabledEventTypes = const {
      EventTypes.tap,
      EventTypes.longPress,
      EventTypes.textInput,
      EventTypes.scroll,
      EventTypes.navigation,
      EventTypes.dialog,
      EventTypes.bottomSheet,
      EventTypes.custom,
    },
    this.includeSensitiveData = false,
    this.maxEvents = 1000,
    this.autoSave = false,
    this.autoSaveInterval = 60,
  });

  /// Create a copy with updated fields
  RecorderConfig copyWith({
    Set<String>? enabledEventTypes,
    bool? includeSensitiveData,
    int? maxEvents,
    bool? autoSave,
    int? autoSaveInterval,
  }) {
    return RecorderConfig(
      enabledEventTypes: enabledEventTypes ?? this.enabledEventTypes,
      includeSensitiveData: includeSensitiveData ?? this.includeSensitiveData,
      maxEvents: maxEvents ?? this.maxEvents,
      autoSave: autoSave ?? this.autoSave,
      autoSaveInterval: autoSaveInterval ?? this.autoSaveInterval,
    );
  }
}
