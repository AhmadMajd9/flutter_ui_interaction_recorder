import 'package:flutter/material.dart';
import 'package:flutter_ui_interaction_recorder/flutter_ui_interaction_recorder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI Interaction Recorder Example',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      navigatorObservers: [RecorderNavigatorObserver()],
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Start recording when the app starts
    RecorderController.instance.start();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Interaction Recorder Example'),
        actions: [
          RecorderIconButton(
            widgetKey: 'settings_button',
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                  settings: const RouteSettings(name: '/settings'),
                ),
              );
            },
          ),
        ],
      ),
      body: RecorderSingleChildScrollView(
        widgetKey: 'main_scroll_view',
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Welcome to UI Interaction Recorder',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'This example demonstrates how to use the flutter_ui_interaction_recorder package to track user interactions.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      RecorderButton(
                        widgetKey: 'learn_more_button',
                        onPressed: () {
                          RecorderController.instance.logCustom(
                            'learn_more_clicked',
                            meta: {'source': 'home_page'},
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Learn more functionality coming soon!',
                              ),
                            ),
                          );
                        },
                        child: const Text('Learn More'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Login form section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Login Form',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RecorderEmailField(
                        widgetKey: 'email_field',
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      RecorderPasswordField(
                        widgetKey: 'password_field',
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      RecorderButton(
                        widgetKey: 'login_button',
                        onPressed: () {
                          if (_emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty) {
                            RecorderController.instance.logCustom(
                              'login_attempt',
                              meta: {
                                'email': _emailController.text,
                                'hasPassword':
                                    _passwordController.text.isNotEmpty,
                              },
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Login successful!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill in all fields'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Search section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Search',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RecorderTextField(
                        widgetKey: 'search_field',
                        controller: _searchController,
                        decoration: const InputDecoration(
                          labelText: 'Search...',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                      const SizedBox(height: 16),
                      RecorderButton(
                        widgetKey: 'search_button',
                        onPressed: () {
                          if (_searchController.text.isNotEmpty) {
                            RecorderController.instance.logCustom(
                              'search_performed',
                              value: _searchController.text,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Searching for: ${_searchController.text}',
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Search'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Interactive list section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Interactive List',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: RecorderListView(
                          widgetKey: 'interactive_list',
                          children: List.generate(
                            10,
                            (index) => RecorderGestureDetector(
                              widgetKey: 'list_item_$index',
                              onTap: () {
                                RecorderController.instance.logCustom(
                                  'list_item_tapped',
                                  value: 'Item $index',
                                  meta: {'index': index},
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Tapped item $index')),
                                );
                              },
                              onLongPress: () {
                                RecorderController.instance.logCustom(
                                  'list_item_long_pressed',
                                  value: 'Item $index',
                                  meta: {'index': index},
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Long pressed item $index'),
                                  ),
                                );
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text('${index + 1}'),
                                ),
                                title: Text('Item ${index + 1}'),
                                subtitle: Text(
                                  'This is item number ${index + 1}',
                                ),
                                trailing: RecorderIconButton(
                                  widgetKey: 'item_action_$index',
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () {
                                    RecorderController.instance.logCustom(
                                      'list_item_action',
                                      value: 'Item $index',
                                      meta: {'index': index},
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Action for item $index'),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Actions section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Actions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: RecorderButton(
                              widgetKey: 'export_button',
                              onPressed: () async {
                                final json =
                                    RecorderController.instance.exportToJson();
                                final filePath = await RecorderController
                                    .instance
                                    .exportToFile(
                                      'ui_events_${DateTime.now().millisecondsSinceEpoch}.json',
                                    );
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        filePath != null
                                            ? 'Events exported to: $filePath'
                                            : 'Failed to export events',
                                      ),
                                      backgroundColor:
                                          filePath != null
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: const Text('Export Events'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RecorderButton(
                              widgetKey: 'clear_button',
                              onPressed: () {
                                RecorderController.instance.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Events cleared'),
                                  ),
                                );
                              },
                              child: const Text('Clear Events'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: RecorderButton(
                              widgetKey: 'stop_button',
                              onPressed: () {
                                RecorderController.instance.stop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Recording stopped'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              },
                              child: const Text('Stop Recording'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RecorderButton(
                              widgetKey: 'start_button',
                              onPressed: () {
                                RecorderController.instance.start();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Recording started'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              child: const Text('Start Recording'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Statistics section
              ListenableBuilder(
                listenable: RecorderController.instance,
                builder: (context, child) {
                  final stats =
                      RecorderController.instance.getEventStatistics();
                  final totalEvents = RecorderController.instance.events.length;

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recording Statistics',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('Total Events: $totalEvents'),
                          const SizedBox(height: 8),
                          Text(
                            'Recording Status: ${RecorderController.instance.isRecording ? "Active" : "Inactive"}',
                          ),
                          const SizedBox(height: 8),
                          if (stats.isNotEmpty) ...[
                            const Text('Event Types:'),
                            ...stats.entries.map(
                              (entry) => Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text('${entry.key}: ${entry.value}'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: RecorderOverlay(
        position: OverlayPosition.bottomRight,
        showEventCount: true,
        showStatusIndicator: true,
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: RecorderSingleChildScrollView(
        widgetKey: 'settings_scroll_view',
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recorder Settings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Configuration',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RecorderButton(
                        widgetKey: 'update_config_button',
                        onPressed: () {
                          final newConfig = RecorderConfig(
                            enabledEventTypes: {
                              EventTypes.tap,
                              EventTypes.textInput,
                              EventTypes.scroll,
                              EventTypes.navigation,
                            },
                            includeSensitiveData: false,
                            maxEvents: 500,
                          );
                          RecorderController.instance.updateConfig(newConfig);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Configuration updated'),
                            ),
                          );
                        },
                        child: const Text('Update Configuration'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Navigation Test',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RecorderButton(
                        widgetKey: 'navigate_back_button',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
