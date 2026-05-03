import 'package:flutter/material.dart';

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
class ProgressBar extends StatelessWidget {
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

  /// Creates a [ProgressBar].
  const ProgressBar({
    super.key,
    this.progressColor,
    this.progressBackgroundColor,
    this.progressStrokeWidth,
    this.size,
    this.progress,
    this.center,
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
  Widget build(BuildContext context) {
    final bool isUsingNewApi = size != null || center != null;
    assert(
      size != null || (containerHeight != null && containerWidth != null),
      'Provide size (new API) or both containerHeight & containerWidth (old API)',
    );

    if (isUsingNewApi) {
      return _buildNew(context);
    } else {
      return _buildOld(context);
    }
  }

  Widget _buildNew(BuildContext context) {
    final double effectiveSize = size ?? (containerHeight ?? 40);

    return SizedBox(
      width: effectiveSize,
      height: effectiveSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (center != null) center!,
          SizedBox(
            width: effectiveSize,
            height: effectiveSize,
            child: CircularProgressIndicator(
              value: progress?.clamp(0.0, 1.0),
              strokeWidth: progressStrokeWidth ?? 4,
              valueColor: AlwaysStoppedAnimation(
                  progressColor ?? Theme.of(context).colorScheme.primary),
              backgroundColor: progressBackgroundColor ?? Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOld(BuildContext context) {
    return SizedBox(
      height: containerHeight ?? 40,
      width: containerWidth ?? 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (imageFile != null)
            ClipOval(
              child: Image.asset(
                imageFile!,
                fit: boxFit ?? BoxFit.contain,
                height: iconHeight,
                width: iconWidth,
              ),
            ),
          SizedBox(
            height: progressHeight ?? containerHeight ?? 40,
            width: progressWidth ?? containerWidth ?? 40,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  progressColor ?? Theme.of(context).colorScheme.primary),
              strokeWidth: progressStrokeWidth ?? 4.0,
            ),
          ),
        ],
      ),
    );
  }
}
