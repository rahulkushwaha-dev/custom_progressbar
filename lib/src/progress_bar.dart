import 'package:flutter/material.dart';

import 'custom_progress.dart';

/// A customizable circular progress bar.
///
/// Supports both new and deprecated APIs.
/// Use [size], [progress], and [center] for modern usage.
/// ## New API (Recommended)
/// ```dart
/// ProgressBar(
///   size: 50,
///   progress: 0.7,
///   center: Icon(Icons.favorite),
/// )
/// ```
///
/// ## Old API (Deprecated)
/// ```dart
/// ProgressBar(
///   containerHeight: 40,
///   containerWidth: 40,
///   imageFile: 'assets/icon.png',
/// )
/// ```
/// A customizable progress bar widget.
class ProgressBar extends StatefulWidget {
  // New Migration Parameters
  /// This is the height and width of Container / ProgressBar i,e size
  final double? size;

  /// This progress of actual progress from 0 to 1
  /// Current progress value (0.0 to 1.0).
  final double? progress; // this will 0.0 to 1.0
  /// This center is  widget . We can add any widget like Text,Image,Icon etc...
  final Widget? center;

  /// This is the ProgressBarColor of Progress
  final Color? progressColor;

  /// This is the stroke Width of Progress
  final double? progressStrokeWidth;

  ///This is the background color of Progress .
  final Color? progressBackgroundColor;

  /// OLD API (deprecated)
  @Deprecated('Use center instead')
  final BoxFit? boxFit;

  /// OLD API (deprecated)
  @Deprecated('Use size instead')
  final double? containerHeight, containerWidth;
  @Deprecated('Use center instead')

  /// OLD API (deprecated)
  final double? iconHeight, iconWidth;
  @Deprecated('Use center instead')

  /// OLD API (deprecated)
  final String? imageFile;
  @Deprecated('Use size instead')

  /// OLD API (deprecated)
  final double? progressHeight, progressWidth;

  final bool isClockwise;

  /// Creates a [ProgressBar].
  const ProgressBar({
    super.key,
    this.progressColor,
    this.progressBackgroundColor,
    this.progressStrokeWidth,
    this.size,
    this.progress,
    this.center,
   required this.isClockwise,
    @Deprecated('Use size instead') this.containerWidth,
    @Deprecated('Use size instead') this.containerHeight,
    @Deprecated('Use center instead') this.boxFit,
    @Deprecated('Use center instead') this.iconHeight,
    @Deprecated('Use center instead') this.iconWidth,
    @Deprecated('Use center instead') this.imageFile,
    @Deprecated('Use size instead') this.progressHeight,
    @Deprecated('Use size instead. We have replace with ') this.progressWidth,
  });

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;
  double _oldProgress = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    if (widget.progress == null) {
      _controller.repeat();
    } else {
      _animation = Tween<double>(
        begin: 0,
        end: widget.progress!,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));

      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.progress != null) {
      _oldProgress = oldWidget.progress ?? 0;

      _animation = Tween<double>(
        begin: _oldProgress,
        end: widget.progress!,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));

      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isUsingNewApi = widget.size != null || widget.center != null;
    assert(
      widget.size != null || (widget.containerHeight != null && widget.containerWidth != null),
      'Provide size (new API) or both containerHeight & containerWidth (old API)',
    );

    if (isUsingNewApi) {
      return _buildNew(context);
    } else {
      return _buildOld(context);
    }
  }

  Widget _buildNew(BuildContext context) {
    final double effectiveSize = widget.size ?? (widget.containerHeight ?? 40);

    return SizedBox(
      width: effectiveSize,
      height: effectiveSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.center != null) widget.center!,

          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return CustomPaint(
                size: Size(effectiveSize, effectiveSize),
                painter: ProgressPainter(
                  progress: widget.progress == null
                ? _controller.value
                    : _animation.value,
                  color: widget.progressColor ??
                      Theme.of(context).colorScheme.primary,
                  backgroundColor:
                  widget.progressBackgroundColor ?? Colors.grey.shade300,
                  strokeWidth: widget.progressStrokeWidth ?? 4,
                  isClockwise: widget.isClockwise,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  // Widget _buildNew(BuildContext context) {
  Widget _buildOld(BuildContext context) {
    return SizedBox(
      height: widget.containerHeight ?? 40,
      width: widget.containerWidth ?? 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.imageFile != null)
            ClipOval(
              child: Image.asset(
                widget.imageFile!,
                fit: widget.boxFit ?? BoxFit.contain,
                height: widget.iconHeight,
                width: widget.iconWidth,
              ),
            ),
          SizedBox(
            height: widget.progressHeight ?? widget.containerHeight ?? 40,
            width: widget.progressWidth ?? widget.containerWidth ?? 40,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  widget.progressColor ?? Theme.of(context).colorScheme.primary),
              strokeWidth: widget.progressStrokeWidth ?? 4.0,
            ),
          ),
        ],
      ),
    );
  }
}
