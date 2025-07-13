/// Represents a user interaction event recorded by the UI Interaction Recorder.
class UIEvent {
  /// The type of interaction (e.g., 'tap', 'scroll', 'text_input', 'navigation')
  final String type;

  /// The current screen or route name where the event occurred
  final String screen;

  /// Optional widget key identifier
  final String? widgetKey;

  /// Optional value associated with the event (e.g., text input content)
  final String? value;

  /// Timestamp when the event occurred
  final DateTime timestamp;

  /// Additional metadata for the event
  final Map<String, dynamic>? meta;

  /// Creates a new UIEvent instance
  const UIEvent({
    required this.type,
    required this.screen,
    this.widgetKey,
    this.value,
    required this.timestamp,
    this.meta,
  });

  /// Creates a UIEvent from a JSON map
  factory UIEvent.fromJson(Map<String, dynamic> json) {
    return UIEvent(
      type: json['type'] as String,
      screen: json['screen'] as String,
      widgetKey: json['widgetKey'] as String?,
      value: json['value'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      meta:
          json['meta'] != null
              ? Map<String, dynamic>.from(json['meta'] as Map)
              : null,
    );
  }

  /// Converts the UIEvent to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'screen': screen,
      'widgetKey': widgetKey,
      'value': value,
      'timestamp': timestamp.toIso8601String(),
      'meta': meta,
    };
  }

  /// Creates a copy of this UIEvent with updated fields
  UIEvent copyWith({
    String? type,
    String? screen,
    String? widgetKey,
    String? value,
    DateTime? timestamp,
    Map<String, dynamic>? meta,
  }) {
    return UIEvent(
      type: type ?? this.type,
      screen: screen ?? this.screen,
      widgetKey: widgetKey ?? this.widgetKey,
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
      meta: meta ?? this.meta,
    );
  }

  @override
  String toString() {
    return 'UIEvent(type: $type, screen: $screen, widgetKey: $widgetKey, value: $value, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UIEvent &&
        other.type == type &&
        other.screen == screen &&
        other.widgetKey == widgetKey &&
        other.value == value &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        screen.hashCode ^
        widgetKey.hashCode ^
        value.hashCode ^
        timestamp.hashCode;
  }
}

/// Predefined event types for common interactions
class EventTypes {
  static const String tap = 'tap';
  static const String longPress = 'long_press';
  static const String textInput = 'text_input';
  static const String scroll = 'scroll';
  static const String navigation = 'navigation';
  static const String dialog = 'dialog';
  static const String bottomSheet = 'bottom_sheet';
  static const String custom = 'custom';
}
