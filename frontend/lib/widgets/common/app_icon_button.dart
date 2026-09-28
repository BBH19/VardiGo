import 'package:flutter/material.dart';
import 'package:frontend/utils/global_params.dart';

class AppIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onTap;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(
      GlobalParams.squareButtonRadius,
    );

    return Container(
      width: GlobalParams.squareButtonSize,
      height: GlobalParams.squareButtonSize,
      decoration: BoxDecoration(
        color: GlobalParams.white,
        borderRadius: radius,
        border: Border.all(
          color: GlobalParams.slate200,
        ),
        boxShadow: GlobalParams.buttonShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Center(
            child: icon,
          ),
        ),
      ),
    );
  }
}