import 'package:flutter/material.dart';
import '../controllers/recorder_controller.dart';

/// A floating overlay widget that provides controls for the UI Interaction Recorder.
///
/// This widget displays a floating button that allows users to start/stop recording
/// and view recorded events in real-time.
///
/// Example:
/// ```dart
/// RecorderOverlay(
///   position: OverlayPosition.topRight,
///   showEventCount: true,
/// )
/// ```
class RecorderOverlay extends StatefulWidget {
  /// Position of the overlay on the screen
  final OverlayPosition position;

  /// Whether to show the event count badge
  final bool showEventCount;

  /// Whether to show the recording status indicator
  final bool showStatusIndicator;

  /// Size of the floating button
  final double buttonSize;

  /// Color of the recording button when active
  final Color? recordingColor;

  /// Color of the recording button when inactive
  final Color? inactiveColor;

  /// Whether to show a tooltip
  final bool showTooltip;

  /// Custom icon for the recording button
  final IconData? customIcon;

  const RecorderOverlay({
    super.key,
    this.position = OverlayPosition.topRight,
    this.showEventCount = true,
    this.showStatusIndicator = true,
    this.buttonSize = 56.0,
    this.recordingColor,
    this.inactiveColor,
    this.showTooltip = true,
    this.customIcon,
  });

  @override
  State<RecorderOverlay> createState() => _RecorderOverlayState();
}

class _RecorderOverlayState extends State<RecorderOverlay> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: RecorderController.instance,
      builder: (context, child) {
        return Positioned(
          top: _getTopPosition(),
          left: _getLeftPosition(),
          right: _getRightPosition(),
          bottom: _getBottomPosition(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: _getCrossAxisAlignment(),
            children: [
              if (_isExpanded) _buildExpandedContent(),
              _buildMainButton(),
            ],
          ),
        );
      },
    );
  }

  double? _getTopPosition() {
    switch (widget.position) {
      case OverlayPosition.topLeft:
      case OverlayPosition.topRight:
        return 100.0;
      case OverlayPosition.bottomLeft:
      case OverlayPosition.bottomRight:
        return null;
    }
  }

  double? _getLeftPosition() {
    switch (widget.position) {
      case OverlayPosition.topLeft:
      case OverlayPosition.bottomLeft:
        return 16.0;
      case OverlayPosition.topRight:
      case OverlayPosition.bottomRight:
        return null;
    }
  }

  double? _getRightPosition() {
    switch (widget.position) {
      case OverlayPosition.topRight:
      case OverlayPosition.bottomRight:
        return 16.0;
      case OverlayPosition.topLeft:
      case OverlayPosition.bottomLeft:
        return null;
    }
  }

  double? _getBottomPosition() {
    switch (widget.position) {
      case OverlayPosition.topLeft:
      case OverlayPosition.topRight:
        return null;
      case OverlayPosition.bottomLeft:
      case OverlayPosition.bottomRight:
        return 100.0;
    }
  }

  CrossAxisAlignment _getCrossAxisAlignment() {
    switch (widget.position) {
      case OverlayPosition.topLeft:
      case OverlayPosition.bottomLeft:
        return CrossAxisAlignment.start;
      case OverlayPosition.topRight:
      case OverlayPosition.bottomRight:
        return CrossAxisAlignment.end;
    }
  }

  Widget _buildMainButton() {
    final isRecording = RecorderController.instance.isRecording;
    final eventCount = RecorderController.instance.events.length;

    return Container(
      width: widget.buttonSize,
      height: widget.buttonSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isRecording
                ? (widget.recordingColor ?? Colors.red)
                : (widget.inactiveColor ?? Colors.blue),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.buttonSize / 2),
          onTap: _toggleRecording,
          onLongPress: _toggleExpanded,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                widget.customIcon ??
                    (isRecording ? Icons.stop : Icons.fiber_manual_record),
                color: Colors.white,
                size: widget.buttonSize * 0.4,
              ),
              if (widget.showEventCount && eventCount > 0)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      eventCount.toString(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              if (widget.showStatusIndicator && isRecording)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: _getCrossAxisAlignment(),
        children: [
          _buildActionButton(
            icon: Icons.play_arrow,
            label: 'Start',
            onTap: () => RecorderController.instance.start(),
            enabled: !RecorderController.instance.isRecording,
          ),
          const SizedBox(height: 4),
          _buildActionButton(
            icon: Icons.stop,
            label: 'Stop',
            onTap: () => RecorderController.instance.stop(),
            enabled: RecorderController.instance.isRecording,
          ),
          const SizedBox(height: 4),
          _buildActionButton(
            icon: Icons.clear,
            label: 'Clear',
            onTap: () => RecorderController.instance.clear(),
            enabled: RecorderController.instance.events.isNotEmpty,
          ),
          const SizedBox(height: 4),
          _buildActionButton(
            icon: Icons.download,
            label: 'Export',
            onTap: _exportEvents,
            enabled: RecorderController.instance.events.isNotEmpty,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: enabled ? Colors.black87 : Colors.grey),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: enabled ? Colors.black87 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleRecording() {
    if (RecorderController.instance.isRecording) {
      RecorderController.instance.stop();
    } else {
      RecorderController.instance.start();
    }
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _exportEvents() async {
    final fileName = 'ui_events_${DateTime.now().millisecondsSinceEpoch}.json';
    final filePath = await RecorderController.instance.exportToFile(fileName);

    if (filePath != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Events exported to: $filePath'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to export events'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Available positions for the overlay
enum OverlayPosition { topLeft, topRight, bottomLeft, bottomRight }
