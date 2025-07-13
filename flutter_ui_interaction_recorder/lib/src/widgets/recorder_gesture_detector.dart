import 'package:flutter/material.dart';
import '../controllers/recorder_controller.dart';

/// A GestureDetector wrapper that automatically records tap and long press events.
///
/// This widget wraps any child widget and records user interactions with it.
///
/// Example:
/// ```dart
/// RecorderGestureDetector(
///   widgetKey: "login_button",
///   onTap: () => print("Login tapped"),
///   child: ElevatedButton(
///     child: Text("Login"),
///   ),
/// )
/// ```
class RecorderGestureDetector extends StatelessWidget {
  /// The unique identifier for this widget (used in event logging)
  final String widgetKey;

  /// The child widget to wrap
  final Widget child;

  /// Callback when tap occurs
  final VoidCallback? onTap;

  /// Callback when long press occurs
  final VoidCallback? onLongPress;

  /// Callback when double tap occurs
  final VoidCallback? onDoubleTap;

  /// Additional metadata to include with recorded events
  final Map<String, dynamic>? meta;

  /// Whether to record tap events
  final bool recordTap;

  /// Whether to record long press events
  final bool recordLongPress;

  /// Whether to record double tap events
  final bool recordDoubleTap;

  const RecorderGestureDetector({
    super.key,
    required this.widgetKey,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.meta,
    this.recordTap = true,
    this.recordLongPress = true,
    this.recordDoubleTap = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (recordTap) {
          RecorderController.instance.logTap(widgetKey, meta: meta);
        }
        onTap?.call();
      },
      onLongPress: () {
        if (recordLongPress) {
          RecorderController.instance.logLongPress(widgetKey, meta: meta);
        }
        onLongPress?.call();
      },
      onDoubleTap: () {
        if (recordDoubleTap) {
          RecorderController.instance.logCustom(
            'double_tap',
            value: widgetKey,
            meta: meta,
          );
        }
        onDoubleTap?.call();
      },
      child: child,
    );
  }
}

/// A specialized version of RecorderGestureDetector for buttons.
///
/// This widget is specifically designed for button-like widgets and provides
/// better integration with button semantics.
class RecorderButton extends StatelessWidget {
  /// The unique identifier for this button
  final String widgetKey;

  /// The button's onPressed callback
  final VoidCallback? onPressed;

  /// The button's child widget
  final Widget child;

  /// Additional metadata for recorded events
  final Map<String, dynamic>? meta;

  /// The style of the button
  final ButtonStyle? style;

  /// Whether the button is enabled
  final bool enabled;

  const RecorderButton({
    super.key,
    required this.widgetKey,
    required this.onPressed,
    required this.child,
    this.meta,
    this.style,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style,
      onPressed:
          enabled
              ? () {
                RecorderController.instance.logTap(widgetKey, meta: meta);
                onPressed?.call();
              }
              : null,
      child: child,
    );
  }
}

/// A specialized version for IconButton with recording capabilities.
class RecorderIconButton extends StatelessWidget {
  /// The unique identifier for this icon button
  final String widgetKey;

  /// The icon to display
  final Widget icon;

  /// The onPressed callback
  final VoidCallback? onPressed;

  /// Additional metadata for recorded events
  final Map<String, dynamic>? meta;

  /// Tooltip for the button
  final String? tooltip;

  /// Whether the button is enabled
  final bool enabled;

  const RecorderIconButton({
    super.key,
    required this.widgetKey,
    required this.icon,
    required this.onPressed,
    this.meta,
    this.tooltip,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      onPressed:
          enabled
              ? () {
                RecorderController.instance.logTap(widgetKey, meta: meta);
                onPressed?.call();
              }
              : null,
      tooltip: tooltip,
    );
  }
}
