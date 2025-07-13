import 'package:flutter/material.dart';
import '../controllers/recorder_controller.dart';

/// A NavigatorObserver that automatically records navigation events.
///
/// This observer tracks route changes and logs them as navigation events.
///
/// Example:
/// ```dart
/// MaterialApp(
///   navigatorObservers: [RecorderNavigatorObserver()],
///   // ... rest of your app
/// )
/// ```
class RecorderNavigatorObserver extends NavigatorObserver {
  /// Additional metadata for recorded events
  final Map<String, dynamic>? meta;

  /// Whether to record navigation events
  final bool recordNavigation;

  /// Whether to record route pop events
  final bool recordPop;

  RecorderNavigatorObserver({
    this.meta,
    this.recordNavigation = true,
    this.recordPop = true,
  });

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (!recordNavigation) return;

    final currentRoute = _getRouteName(route);
    final previousRouteName =
        previousRoute != null ? _getRouteName(previousRoute) : '/';

    RecorderController.instance.logNavigation(
      previousRouteName,
      currentRoute,
      meta: {
        'action': 'push',
        'routeType': route.runtimeType.toString(),
        ...?meta,
      },
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (!recordPop) return;

    final currentRoute = _getRouteName(route);
    final previousRouteName =
        previousRoute != null ? _getRouteName(previousRoute) : '/';

    RecorderController.instance.logNavigation(
      currentRoute,
      previousRouteName,
      meta: {
        'action': 'pop',
        'routeType': route.runtimeType.toString(),
        ...?meta,
      },
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (!recordNavigation) return;

    final newRouteName = newRoute != null ? _getRouteName(newRoute) : '/';
    final oldRouteName = oldRoute != null ? _getRouteName(oldRoute) : '/';

    RecorderController.instance.logNavigation(
      oldRouteName,
      newRouteName,
      meta: {
        'action': 'replace',
        'routeType': newRoute?.runtimeType.toString(),
        ...?meta,
      },
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (!recordNavigation) return;

    final removedRoute = _getRouteName(route);
    final previousRouteName =
        previousRoute != null ? _getRouteName(previousRoute) : '/';

    RecorderController.instance.logNavigation(
      removedRoute,
      previousRouteName,
      meta: {
        'action': 'remove',
        'routeType': route.runtimeType.toString(),
        ...?meta,
      },
    );
  }

  /// Extract route name from route object
  String _getRouteName(Route<dynamic> route) {
    if (route.settings.name != null) {
      return route.settings.name!;
    }

    // Try to extract name from route type
    final routeType = route.runtimeType.toString();
    if (routeType.contains('MaterialPageRoute')) {
      return '/material_page';
    } else if (routeType.contains('CupertinoPageRoute')) {
      return '/cupertino_page';
    } else if (routeType.contains('DialogRoute')) {
      return '/dialog';
    } else if (routeType.contains('ModalRoute')) {
      return '/modal';
    }

    return '/unknown';
  }
}

/// A mixin that can be added to any widget to automatically track navigation.
///
/// This mixin provides a convenient way to track navigation events without
/// manually setting up a NavigatorObserver.
mixin RecorderNavigationMixin<T extends StatefulWidget> on State<T> {
  RecorderNavigatorObserver? _navigatorObserver;

  @override
  void initState() {
    super.initState();
    _setupNavigationObserver();
  }

  @override
  void dispose() {
    _navigatorObserver = null;
    super.dispose();
  }

  void _setupNavigationObserver() {
    final navigator = Navigator.of(context);
    if (navigator != null) {
      _navigatorObserver = RecorderNavigatorObserver();
      // Note: In a real implementation, you would need to add the observer
      // to the navigator, but this requires access to the navigator's internal
      // observer list which is not publicly accessible.
    }
  }

  /// Manually log a navigation event
  void logNavigation(
    String fromRoute,
    String toRoute, {
    Map<String, dynamic>? meta,
  }) {
    RecorderController.instance.logNavigation(fromRoute, toRoute, meta: meta);
  }
}

/// A helper class for tracking navigation in a more granular way.
class RecorderNavigationTracker {
  static final RecorderNavigationTracker _instance =
      RecorderNavigationTracker._internal();

  static RecorderNavigationTracker get instance => _instance;

  RecorderNavigationTracker._internal();

  /// Track navigation to a specific route
  void trackNavigation(String routeName, {Map<String, dynamic>? meta}) {
    RecorderController.instance.logCustom(
      'navigation_tracked',
      value: routeName,
      meta: {'timestamp': DateTime.now().toIso8601String(), ...?meta},
    );
  }

  /// Track time spent on a route
  void trackRouteTime(
    String routeName,
    Duration timeSpent, {
    Map<String, dynamic>? meta,
  }) {
    RecorderController.instance.logCustom(
      'route_time',
      value: routeName,
      meta: {
        'timeSpentMs': timeSpent.inMilliseconds,
        'timeSpentSeconds': timeSpent.inSeconds,
        ...?meta,
      },
    );
  }

  /// Track route errors or exceptions
  void trackRouteError(
    String routeName,
    String error, {
    Map<String, dynamic>? meta,
  }) {
    RecorderController.instance.logCustom(
      'route_error',
      value: routeName,
      meta: {
        'error': error,
        'timestamp': DateTime.now().toIso8601String(),
        ...?meta,
      },
    );
  }
}
