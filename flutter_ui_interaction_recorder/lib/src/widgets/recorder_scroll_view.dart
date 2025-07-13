import 'package:flutter/material.dart';
import '../controllers/recorder_controller.dart';

/// A ScrollView wrapper that automatically records scroll events.
///
/// This widget wraps a ScrollView and records scroll interactions with the specified widget key.
///
/// Example:
/// ```dart
/// RecorderScrollView(
///   widgetKey: "main_list",
///   child: ListView.builder(
///     itemCount: 100,
///     itemBuilder: (context, index) => ListTile(title: Text("Item $index")),
///   ),
/// )
/// ```
class RecorderScrollView extends StatefulWidget {
  /// The unique identifier for this scroll view
  final String widgetKey;

  /// The child scroll view widget
  final Widget child;

  /// Additional metadata for recorded events
  final Map<String, dynamic>? meta;

  /// Whether to record scroll events
  final bool recordScroll;

  /// Minimum scroll distance to trigger recording (in pixels)
  final double minScrollDistance;

  /// Throttle interval for scroll events (in milliseconds)
  final int throttleInterval;

  const RecorderScrollView({
    super.key,
    required this.widgetKey,
    required this.child,
    this.meta,
    this.recordScroll = true,
    this.minScrollDistance = 10.0,
    this.throttleInterval = 100,
  });

  @override
  State<RecorderScrollView> createState() => _RecorderScrollViewState();
}

class _RecorderScrollViewState extends State<RecorderScrollView> {
  ScrollController? _scrollController;
  double _lastScrollPosition = 0.0;
  DateTime? _lastScrollTime;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController!.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_onScroll);
    _scrollController?.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!widget.recordScroll || _scrollController == null) return;

    final currentPosition = _scrollController!.position.pixels;
    final currentTime = DateTime.now();

    // Check if enough time has passed since last scroll event
    if (_lastScrollTime != null) {
      final timeDiff = currentTime.difference(_lastScrollTime!).inMilliseconds;
      if (timeDiff < widget.throttleInterval) return;
    }

    // Check if scroll distance is significant enough
    final scrollDistance = (currentPosition - _lastScrollPosition).abs();
    if (scrollDistance < widget.minScrollDistance) return;

    // Determine scroll direction
    final direction = currentPosition > _lastScrollPosition ? 'down' : 'up';

    // Record the scroll event
    RecorderController.instance.logScroll(
      widget.widgetKey,
      direction,
      scrollDistance,
      meta: {
        'currentPosition': currentPosition,
        'maxScrollExtent': _scrollController!.position.maxScrollExtent,
        'viewportDimension': _scrollController!.position.viewportDimension,
        ...?widget.meta,
      },
    );

    _lastScrollPosition = currentPosition;
    _lastScrollTime = currentTime;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // Additional scroll notification handling if needed
        return false;
      },
      child: widget.child,
    );
  }
}

/// A specialized version for ListView with recording capabilities.
class RecorderListView extends StatelessWidget {
  /// The unique identifier for this list view
  final String widgetKey;

  /// List of widgets to display
  final List<Widget> children;

  /// Whether to add padding around the list
  final bool addAutomaticKeepAlives;

  /// Whether to add repaint boundaries
  final bool addRepaintBoundaries;

  /// Whether to add semantic indexes
  final bool addSemanticIndexes;

  /// Additional metadata for recorded events
  final Map<String, dynamic>? meta;

  /// Whether to record scroll events
  final bool recordScroll;

  const RecorderListView({
    super.key,
    required this.widgetKey,
    required this.children,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.meta,
    this.recordScroll = true,
  });

  @override
  Widget build(BuildContext context) {
    return RecorderScrollView(
      widgetKey: widgetKey,
      recordScroll: recordScroll,
      meta: meta,
      child: ListView(
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        children: children,
      ),
    );
  }
}

/// A specialized version for ListView.builder with recording capabilities.
class RecorderListViewBuilder extends StatelessWidget {
  /// The unique identifier for this list view
  final String widgetKey;

  /// Number of items in the list
  final int itemCount;

  /// Builder function for creating list items
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Whether to add padding around the list
  final bool addAutomaticKeepAlives;

  /// Whether to add repaint boundaries
  final bool addRepaintBoundaries;

  /// Whether to add semantic indexes
  final bool addSemanticIndexes;

  /// Additional metadata for recorded events
  final Map<String, dynamic>? meta;

  /// Whether to record scroll events
  final bool recordScroll;

  const RecorderListViewBuilder({
    super.key,
    required this.widgetKey,
    required this.itemCount,
    required this.itemBuilder,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.meta,
    this.recordScroll = true,
  });

  @override
  Widget build(BuildContext context) {
    return RecorderScrollView(
      widgetKey: widgetKey,
      recordScroll: recordScroll,
      meta: meta,
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
      ),
    );
  }
}

/// A specialized version for SingleChildScrollView with recording capabilities.
class RecorderSingleChildScrollView extends StatelessWidget {
  /// The unique identifier for this scroll view
  final String widgetKey;

  /// The child widget to scroll
  final Widget child;

  /// Scroll physics
  final ScrollPhysics? physics;

  /// Whether to reverse the scroll direction
  final bool reverse;

  /// Additional metadata for recorded events
  final Map<String, dynamic>? meta;

  /// Whether to record scroll events
  final bool recordScroll;

  const RecorderSingleChildScrollView({
    super.key,
    required this.widgetKey,
    required this.child,
    this.physics,
    this.reverse = false,
    this.meta,
    this.recordScroll = true,
  });

  @override
  Widget build(BuildContext context) {
    return RecorderScrollView(
      widgetKey: widgetKey,
      recordScroll: recordScroll,
      meta: meta,
      child: SingleChildScrollView(
        physics: physics,
        reverse: reverse,
        child: child,
      ),
    );
  }
}
