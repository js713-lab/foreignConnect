// lib/widgets/custom_transform.dart

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class CustomTransform extends StatelessWidget {
  final Widget? child;
  final vector.Matrix4 transform;
  final Offset? origin;
  final AlignmentGeometry? alignment;
  final bool transformHitTests;
  final FilterQuality? filterQuality;

  const CustomTransform({
    super.key,
    required this.transform,
    this.origin,
    this.alignment,
    this.transformHitTests = true,
    this.filterQuality,
    this.child,
  });

  factory CustomTransform.rotate({
    Key? key,
    required double angle,
    Offset? origin,
    AlignmentGeometry alignment = Alignment.center,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
    Widget? child,
  }) {
    return CustomTransform(
      key: key,
      transform: vector.Matrix4.rotationZ(angle),
      alignment: alignment,
      origin: origin,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
      child: child,
    );
  }

  factory CustomTransform.translate({
    Key? key,
    required Offset offset,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
    Widget? child,
  }) {
    return CustomTransform(
      key: key,
      transform: vector.Matrix4.translationValues(offset.dx, offset.dy, 0.0),
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
      child: child,
    );
  }

  factory CustomTransform.scale({
    Key? key,
    double? scale,
    double? scaleX,
    double? scaleY,
    Offset? origin,
    AlignmentGeometry alignment = Alignment.center,
    bool transformHitTests = true,
    FilterQuality? filterQuality,
    Widget? child,
  }) {
    assert(!(scale == null && scaleX == null && scaleY == null),
        "At least one of 'scale', 'scaleX' and 'scaleY' is required to be non-null");
    assert(scale == null || (scaleX == null && scaleY == null),
        "If 'scale' is non-null then 'scaleX' and 'scaleY' must be left null");

    return CustomTransform(
      key: key,
      transform: vector.Matrix4.diagonal3Values(
        scale ?? scaleX ?? 1.0,
        scale ?? scaleY ?? 1.0,
        1.0,
      ),
      origin: origin,
      alignment: alignment,
      transformHitTests: transformHitTests,
      filterQuality: filterQuality,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      // Wrap with Material widget
      child: Container(
        transform: transform,
        transformAlignment: alignment,
        child: child,
      ),
    );
  }
}
