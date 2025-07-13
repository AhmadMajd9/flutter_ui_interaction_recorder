# Flutter UI Interaction Recorder

A comprehensive Flutter package for recording and analyzing user interactions within your app. Track taps, text inputs, scrolls, navigation, and custom events with easy export to JSON format.

## 🚀 Key Features

- **📱 Easy Integration**: Simple widgets that wrap existing Flutter widgets
- **🎯 Comprehensive Tracking**: Track all major user interaction types
- **📊 JSON Export**: Export recorded events to JSON format for analysis
- **🔒 Privacy Protection**: Built-in support for sensitive data handling
- **⚡ Real-time Monitoring**: Live overlay for controlling recording
- **⚙️ Flexible Configuration**: Customizable recording options
- **🧭 Navigation Tracking**: Automatic route change detection
- **📜 Scroll Monitoring**: Track scroll events with throttling
- **🎨 Custom Events**: Log custom events with metadata
- **🎨 100% Customizable UI**: Use your own designs while preserving tracking functionality

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_ui_interaction_recorder: ^0.0.1
```

## 🎯 Perfect For

- **UX Research**: Understand how users interact with your app
- **Bug Reporting**: Capture user actions leading to issues
- **Analytics**: Track user behavior patterns
- **Testing**: Generate test scripts from real user interactions
- **Accessibility**: Monitor user interaction patterns for accessibility improvements

## Features

- **Easy Integration**: Simple widgets that wrap existing Flutter widgets
- **Comprehensive Tracking**: Track all major user interaction types
- **JSON Export**: Export recorded events to JSON format
- **Privacy Protection**: Built-in support for sensitive data handling
- **Real-time Monitoring**: Live overlay for controlling recording
- **Flexible Configuration**: Customizable recording options
- **Navigation Tracking**: Automatic route change detection
- **Scroll Monitoring**: Track scroll events with throttling
- **Custom Events**: Log custom events with metadata

## Supported Interaction Types

| Type | Description | Widget |
|------|-------------|---------|
| Tap | Button clicks, widget taps | `RecorderGestureDetector`, `RecorderButton` |
| Long Press | Long press gestures | `RecorderGestureDetector` |
| Text Input | Text field changes | `RecorderTextField`, `RecorderEmailField`, `RecorderPasswordField` |
| Scroll | Scroll events with direction and distance | `RecorderScrollView`, `RecorderListView` |
| Navigation | Route changes | `RecorderNavigatorObserver` |
| Custom | Custom events with metadata | `RecorderController.logCustom()` |

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_ui_interaction_recorder: ^0.0.1
```

## Quick Start

### 1. Initialize the Recorder

```dart
import 'package:flutter_ui_interaction_recorder/flutter_ui_interaction_recorder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        RecorderNavigatorObserver(), // Add navigation tracking
      ],
      home: MyHomePage(),
    );
  }
}
```

### 2. Start Recording

```dart
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    RecorderController.instance.start(); // Start recording
  }
}
```

### 3. Wrap Your Widgets

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        // Track button taps
        RecorderButton(
          widgetKey: "login_button",
          onPressed: () => print("Login tapped"),
          child: Text("Login"),
        ),
        
        // Track text input
        RecorderTextField(
          widgetKey: "email_field",
          controller: emailController,
          decoration: InputDecoration(labelText: "Email"),
        ),
        
        // Track scroll events
        RecorderListView(
          widgetKey: "main_list",
          children: [
            // Your list items
          ],
        ),
      ],
    ),
  );
}
```

### 4. Export Events

```dart
// Export to JSON string
String json = RecorderController.instance.exportToJson();

// Export to file
String? filePath = await RecorderController.instance.exportToFile("events.json");
```

## Widgets

### RecorderGestureDetector

Track tap and long press events on any widget:

```dart
RecorderGestureDetector(
  widgetKey: "my_button",
  onTap: () => print("Tapped!"),
  onLongPress: () => print("Long pressed!"),
  child: Container(
    padding: EdgeInsets.all(16),
    child: Text("Tap me!"),
  ),
)
```

### RecorderTextField

Track text input events:

```dart
RecorderTextField(
  widgetKey: "email_input",
  controller: emailController,
  decoration: InputDecoration(labelText: "Email"),
  isSensitive: false, // Set to true for passwords
)
```

### RecorderPasswordField

Specialized field for passwords with automatic privacy protection:

```dart
RecorderPasswordField(
  widgetKey: "password_input",
  controller: passwordController,
  decoration: InputDecoration(labelText: "Password"),
)
```

### RecorderScrollView

Track scroll events:

```dart
RecorderScrollView(
  widgetKey: "main_scroll",
  child: SingleChildScrollView(
    child: Column(
      children: [
        // Your content
      ],
    ),
  ),
)
```

### RecorderListView

Track scroll events in lists:

```dart
RecorderListView(
  widgetKey: "items_list",
  children: List.generate(
    100,
    (index) => ListTile(title: Text("Item $index")),
  ),
)
```

### RecorderOverlay

Floating control panel for managing recording:

```dart
Scaffold(
  body: YourContent(),
  floatingActionButton: RecorderOverlay(
    position: OverlayPosition.bottomRight,
    showEventCount: true,
    showStatusIndicator: true,
  ),
)
```

## Controller API

### Basic Operations

```dart
// Start recording
RecorderController.instance.start();

// Stop recording
RecorderController.instance.stop();

// Clear all events
RecorderController.instance.clear();

// Check if recording
bool isRecording = RecorderController.instance.isRecording;

// Get all events
List<UIEvent> events = RecorderController.instance.events;
```

### Logging Events

```dart
// Log tap event
RecorderController.instance.logTap("button_key");

// Log text input
RecorderController.instance.logTextInput("field_key", "user input");

// Log scroll event
RecorderController.instance.logScroll("list_key", "down", 100.0);

// Log navigation
RecorderController.instance.logNavigation("/home", "/settings");

// Log custom event
RecorderController.instance.logCustom(
  "custom_action",
  value: "some value",
  meta: {"key": "value"},
);
```

### Export and Import

```dart
// Export to JSON string
String json = RecorderController.instance.exportToJson();

// Export to file
String? filePath = await RecorderController.instance.exportToFile("events.json");

// Load from JSON
RecorderController.instance.loadFromJson(jsonString);
```

### Configuration

```dart
// Update configuration
final config = RecorderConfig(
  enabledEventTypes: {
    EventTypes.tap,
    EventTypes.textInput,
    EventTypes.scroll,
  },
  includeSensitiveData: false,
  maxEvents: 1000,
  autoSave: true,
  autoSaveInterval: 60,
);

RecorderController.instance.updateConfig(config);
```

## Event Data Structure

Each recorded event has the following structure:

```json
{
  "type": "tap",
  "screen": "/home",
  "widgetKey": "login_button",
  "value": null,
  "timestamp": "2025-01-13T10:30:00.000Z",
  "meta": {
    "additional": "data"
  }
}
```

## Privacy and Security

The package includes built-in privacy protection:

- **Sensitive Data Handling**: Password fields are automatically masked
- **Configurable Recording**: Choose which event types to record
- **Data Export Control**: Export only when needed
- **Memory Management**: Configurable event limits

## Example App

Check out the `example/` directory for a complete demonstration of all features.

To run the example:

```bash
cd example
flutter pub get
flutter run
```

## Configuration Options

### RecorderConfig

```dart
RecorderConfig(
  // Event types to record
  enabledEventTypes: {
    EventTypes.tap,
    EventTypes.longPress,
    EventTypes.textInput,
    EventTypes.scroll,
    EventTypes.navigation,
    EventTypes.dialog,
    EventTypes.bottomSheet,
    EventTypes.custom,
  },
  
  // Privacy settings
  includeSensitiveData: false,
  
  // Performance settings
  maxEvents: 1000,
  
  // Auto-save settings
  autoSave: false,
  autoSaveInterval: 60,
)
```

## Advanced Usage

### Custom Event Tracking

```dart
// Track business events
RecorderController.instance.logCustom(
  "purchase_completed",
  value: "product_id_123",
  meta: {
    "amount": 99.99,
    "currency": "USD",
    "payment_method": "credit_card",
  },
);

// Track errors
RecorderController.instance.logCustom(
  "api_error",
  value: "network_timeout",
  meta: {
    "endpoint": "/api/users",
    "status_code": 408,
  },
);
```

### Event Filtering

```dart
// Get events by type
List<UIEvent> tapEvents = RecorderController.instance.getEventsByType(EventTypes.tap);

// Get events by screen
List<UIEvent> homeEvents = RecorderController.instance.getEventsByScreen("/home");

// Get statistics
Map<String, int> stats = RecorderController.instance.getEventStatistics();
```

### Real-time Monitoring

```dart
ListenableBuilder(
  listenable: RecorderController.instance,
  builder: (context, child) {
    final events = RecorderController.instance.events;
    final isRecording = RecorderController.instance.isRecording;
    
    return Column(
      children: [
        Text("Events: ${events.length}"),
        Text("Recording: ${isRecording ? 'Active' : 'Inactive'}"),
      ],
    );
  },
)
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter any issues or have questions, please open an issue on GitHub.
