

import 'package:flutter/material.dart';
import 'package:frontend/utils/global_params.dart';

abstract final class AppTextStyles {
  static TextStyle _style({
    required double size,
    required FontWeight weight,
    required double lineHeight,
    required double letterSpacing,
    required Color color,
  }) {
    return TextStyle(
      fontFamily: GlobalParams.fontFamily,
      fontSize: size,
      fontWeight: weight,
      height: lineHeight / size,
      letterSpacing: letterSpacing,
      color: color,
      leadingDistribution: TextLeadingDistribution.even,
      fontFeatures: const [
        FontFeature.disable('liga'),
        FontFeature.disable('calt'),
      ],
    );
  }

  static TextStyle title18 = _style(
    size: GlobalParams.fontSize18,
    weight: FontWeight.w500,
    lineHeight: GlobalParams.lineHeight24,
    letterSpacing: GlobalParams.tracking18,
    color: GlobalParams.slate700,
  );

  static TextStyle title16Med = _style(
    size: GlobalParams.fontSize16,
    weight: FontWeight.w500,
    lineHeight: GlobalParams.lineHeight24,
    letterSpacing: GlobalParams.tracking16,
    color: GlobalParams.slate700,
  );

  static TextStyle title16Semi = _style(
    size: GlobalParams.fontSize16,
    weight: FontWeight.w600,
    lineHeight: GlobalParams.lineHeight24,
    letterSpacing: GlobalParams.tracking16,
    color: GlobalParams.slate700,
  );

  static TextStyle caption13 = _style(
    size: GlobalParams.fontSize13,
    weight: FontWeight.w400,
    lineHeight: GlobalParams.lineHeight20,
    letterSpacing: GlobalParams.tracking13,
    color: GlobalParams.slate500.withAlpha(
      (GlobalParams.subtitleOpacity * 255).round(),
    ),
  );

  static TextStyle caption12 = _style(
    size: GlobalParams.fontSize12,
    weight: FontWeight.w400,
    lineHeight: GlobalParams.lineHeight16,
    letterSpacing: GlobalParams.tracking12,
    color: GlobalParams.gray500,
  );

  static TextStyle label14(Color color) => _style(
    size: GlobalParams.fontSize14,
    weight: FontWeight.w500,
    lineHeight: GlobalParams.lineHeight20,
    letterSpacing: GlobalParams.tracking14,
    color: color,
  );
    static TextStyle tab12(Color c) => _style(
        size: GlobalParams.fontSize12,
        weight: FontWeight.w500,
        lineHeight: GlobalParams.lineHeight16,
        letterSpacing: GlobalParams.tracking12,
        color: c,
      );
        static TextStyle get caption12Med => _style(
        size:GlobalParams.fontSize12,
        weight:FontWeight.w500,
        lineHeight:GlobalParams.lineHeight16,
        letterSpacing:GlobalParams.tracking12,
        color:GlobalParams.slate700,
      );
      static TextStyle get empty14 => _style(
        size: GlobalParams.fontSize14,
        weight:FontWeight.w400,
        lineHeight: GlobalParams.lineHeight20,
        letterSpacing:GlobalParams.tracking12,
        color:GlobalParams.sub,
      );
        static TextStyle tab13(Color c) => _style(
        size:GlobalParams.fontSize13,
        weight:FontWeight.w500,
         lineHeight:GlobalParams.lineHeight20,
        letterSpacing:GlobalParams.tracking14,
        color: c,
      );
        static TextStyle get title20 => _style(
        size:GlobalParams.fontSize20,
        weight:FontWeight.w600,
        lineHeight: GlobalParams.lineHeight28,
        letterSpacing:GlobalParams.tracking12,
        color:GlobalParams.slate700,
      );
        static TextStyle get price18 => _style(
        size:GlobalParams.fontSize18,
        weight:FontWeight.w600,
        lineHeight:GlobalParams.lineHeight24,
        letterSpacing:GlobalParams.tracking18,
        color:GlobalParams.green,
      );

}