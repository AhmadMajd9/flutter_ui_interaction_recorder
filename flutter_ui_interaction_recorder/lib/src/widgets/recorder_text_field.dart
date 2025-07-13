import 'package:flutter/material.dart';
import '../controllers/recorder_controller.dart';

/// A TextField wrapper that automatically records text input events.
///
/// This widget wraps a TextField and records all text changes with the specified widget key.
///
/// Example:
/// ```dart
/// RecorderTextField(
///   widgetKey: "email_input",
///   controller: emailController,
///   decoration: InputDecoration(labelText: "Email"),
/// )
/// ```
class RecorderTextField extends StatefulWidget {
  /// The unique identifier for this text field
  final String widgetKey;

  /// The text editing controller
  final TextEditingController controller;

  /// Input decoration for the text field
  final InputDecoration? decoration;

  /// Text input type
  final TextInputType? keyboardType;

  /// Whether the text field is enabled
  final bool enabled;

  /// Whether the text field is read-only
  final bool readOnly;

  /// Whether to obscure the text (for passwords)
  final bool obscureText;

  /// Maximum number of lines
  final int? maxLines;

  /// Maximum number of characters
  final int? maxLength;

  /// Additional metadata for recorded events
  final Map<String, dynamic>? meta;

  /// Whether this field contains sensitive data (passwords, etc.)
  final bool isSensitive;

  /// Whether to record text input events
  final bool recordInput;

  /// Whether to record focus events
  final bool recordFocus;

  const RecorderTextField({
    super.key,
    required this.widgetKey,
    required this.controller,
    this.decoration,
    this.keyboardType,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.meta,
    this.isSensitive = false,
    this.recordInput = true,
    this.recordFocus = true,
  });

  @override
  State<RecorderTextField> createState() => _RecorderTextFieldState();
}

class _RecorderTextFieldState extends State<RecorderTextField> {
  String _lastValue = '';

  @override
  void initState() {
    super.initState();
    _lastValue = widget.controller.text;

    // Listen to text changes
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (!widget.recordInput) return;

    final currentValue = widget.controller.text;
    if (currentValue != _lastValue) {
      _lastValue = currentValue;

      // Record the text input event
      final valueToRecord = widget.isSensitive ? '[SENSITIVE]' : currentValue;
      RecorderController.instance.logTextInput(
        widget.widgetKey,
        valueToRecord,
        meta: {
          'length': currentValue.length,
          'isSensitive': widget.isSensitive,
          ...?widget.meta,
        },
      );
    }
  }

  void _onFocusChanged(bool hasFocus) {
    if (!widget.recordFocus) return;

    RecorderController.instance.logCustom(
      hasFocus ? 'text_field_focus' : 'text_field_unfocus',
      value: widget.widgetKey,
      meta: widget.meta,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: _onFocusChanged,
      child: TextField(
        controller: widget.controller,
        decoration: widget.decoration,
        keyboardType: widget.keyboardType,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        obscureText: widget.obscureText,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
      ),
    );
  }
}

/// A specialized version for password fields with enhanced security.
class RecorderPasswordField extends StatelessWidget {
  /// The unique identifier for this password field
  final String widgetKey;

  /// The text editing controller
  final TextEditingController controller;

  /// Input decoration for the text field
  final InputDecoration? decoration;

  /// Whether the text field is enabled
  final bool enabled;

  /// Whether to show the password toggle button
  final bool showToggleButton;

  /// Additional metadata for recorded events
  final Map<String, dynamic>? meta;

  const RecorderPasswordField({
    super.key,
    required this.widgetKey,
    required this.controller,
    this.decoration,
    this.enabled = true,
    this.showToggleButton = true,
    this.meta,
  });

  @override
  Widget build(BuildContext context) {
    return RecorderTextField(
      widgetKey: widgetKey,
      controller: controller,
      decoration:
          decoration ??
          const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
      keyboardType: TextInputType.visiblePassword,
      enabled: enabled,
      obscureText: true,
      isSensitive: true,
      meta: meta,
    );
  }
}

/// A specialized version for email fields.
class RecorderEmailField extends StatelessWidget {
  /// The unique identifier for this email field
  final String widgetKey;

  /// The text editing controller
  final TextEditingController controller;

  /// Input decoration for the text field
  final InputDecoration? decoration;

  /// Whether the text field is enabled
  final bool enabled;

  /// Additional metadata for recorded events
  final Map<String, dynamic>? meta;

  const RecorderEmailField({
    super.key,
    required this.widgetKey,
    required this.controller,
    this.decoration,
    this.enabled = true,
    this.meta,
  });

  @override
  Widget build(BuildContext context) {
    return RecorderTextField(
      widgetKey: widgetKey,
      controller: controller,
      decoration:
          decoration ??
          const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
      keyboardType: TextInputType.emailAddress,
      enabled: enabled,
      meta: meta,
    );
  }
}
