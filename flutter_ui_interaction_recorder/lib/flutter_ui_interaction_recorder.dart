/// A comprehensive Flutter package for recording and analyzing user interactions within your app.
///
/// This package provides a complete solution for tracking user interactions including:
/// - Tap and long press events
/// - Text input events
/// - Scroll events
/// - Navigation events
/// - Custom events
///
/// ## Features
///
/// - **Easy Integration**: Simple widgets that wrap existing Flutter widgets
/// - **Comprehensive Tracking**: Track all major user interaction types
/// - **JSON Export**: Export recorded events to JSON format
/// - **Privacy Protection**: Built-in support for sensitive data handling
/// - **Real-time Monitoring**: Live overlay for controlling recording
/// - **Flexible Configuration**: Customizable recording options
///
/// ## Quick Start
///
/// ```dart
/// import 'package:flutter_ui_interaction_recorder/flutter_ui_interaction_recorder.dart';
///
/// // Start recording
/// RecorderController.instance.start();
///
/// // Wrap your widgets with recorder widgets
/// RecorderGestureDetector(
///   widgetKey: "login_button",
///   onTap: () => print("Login tapped"),
///   child: ElevatedButton(child: Text("Login")),
/// )
///
/// // Export events
/// final json = RecorderController.instance.exportToJson();
/// ```
///
/// ## Widgets
///
/// - [RecorderGestureDetector]: Track tap and long press events
/// - [RecorderTextField]: Track text input events
/// - [RecorderScrollView]: Track scroll events
/// - [RecorderNavigatorObserver]: Track navigation events
/// - [RecorderOverlay]: Floating control panel
///
/// ## Controller
///
/// - [RecorderController]: Main controller for managing recording
/// - [RecorderConfig]: Configuration options for the recorder
///
/// ## Models
///
/// - [UIEvent]: Represents a recorded user interaction event
/// - [EventTypes]: Predefined event type constants
library flutter_ui_interaction_recorder;

// Export models
export 'src/models/ui_event.dart';

// Export controllers
export 'src/controllers/recorder_controller.dart';

// Export widgets
export 'src/widgets/recorder_gesture_detector.dart';
export 'src/widgets/recorder_text_field.dart';
export 'src/widgets/recorder_scroll_view.dart';
export 'src/widgets/recorder_navigator_observer.dart';
export 'src/widgets/recorder_overlay.dart';
