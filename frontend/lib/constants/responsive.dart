import 'dart:math';

import 'package:flutter/material.dart';

/// Responsive utility for adaptive sizing across all screen sizes.
///
/// Usage:
/// ```dart
/// final r = Responsive(context);
/// Container(
///   width: r.wp(80),        // 80% of screen width
///   height: r.hp(40),       // 40% of screen height
///   padding: r.padH(24),    // horizontal padding scaled
///   child: Text('Hi', style: TextStyle(fontSize: r.sp(16))),
/// );
/// ```
class Responsive {
  Responsive(BuildContext context)
    : _mq = MediaQuery.of(context),
      _size = MediaQuery.sizeOf(context);

  final MediaQueryData _mq;
  final Size _size;

  // ── Design baseline (iPhone 14 / Pixel 7 – 393 × 852) ──────────
  static const double _baseW = 393;
  static const double _baseH = 852;

  // ── Raw screen info ─────────────────────────────────────────────
  double get width => _size.width;
  double get height => _size.height;
  double get shortSide => min(width, height);
  double get longSide => max(width, height);
  EdgeInsets get padding => _mq.padding; // safe‐area insets
  bool get isSmall => shortSide < 360;
  bool get isLarge => shortSide >= 600; // small tablet
  bool get isTablet => shortSide >= 768;
  bool get isLandscape => width > height;

  // ── Percentage of screen ────────────────────────────────────────
  /// Width percentage (0‑100)
  double wp(double pct) => width * pct / 100;

  /// Height percentage (0‑100)
  double hp(double pct) => height * pct / 100;

  // ── Scaled pixel (relative to design baseline) ──────────────────
  /// Scale factor that averages width + height influence,
  /// then clamps so text/icons never get absurdly large or tiny.
  double get _scale {
    final wScale = width / _baseW;
    final hScale = height / _baseH;
    return ((wScale + hScale) / 2).clamp(0.75, 1.35);
  }

  /// Scaled pixel — use for font sizes, icon sizes, border radii.
  double sp(double px) => px * _scale;

  /// Scaled dimension — use for widths / heights that should adapt
  /// but not stretch infinitely (e.g. avatar size, card height).
  double dp(double px) => px * _scale;

  // ── Convenience EdgeInsets ──────────────────────────────────────
  EdgeInsets padAll(double px) => EdgeInsets.all(sp(px));
  EdgeInsets padH(double px) => EdgeInsets.symmetric(horizontal: sp(px));
  EdgeInsets padV(double px) => EdgeInsets.symmetric(vertical: sp(px));
  EdgeInsets padHV(double h, double v) =>
      EdgeInsets.symmetric(horizontal: sp(h), vertical: sp(v));

  // ── Spacing SizedBox shortcuts ─────────────────────────────────
  SizedBox gap(double px) => SizedBox(height: sp(px));
  SizedBox gapW(double px) => SizedBox(width: sp(px));

  // ── Clamp a value relative to screen ────────────────────────────
  /// Returns [px] scaled, but clamped between [lo] and [hi].
  double clamp(double px, double lo, double hi) => sp(px).clamp(lo, hi);

  // ── Adaptive value picker ──────────────────────────────────────
  /// Pick a value based on screen category.
  T pick<T>({required T small, required T medium, T? large}) {
    if (isTablet && large != null) return large;
    if (isLarge && large != null) return large;
    if (isSmall) return small;
    return medium;
  }
}
