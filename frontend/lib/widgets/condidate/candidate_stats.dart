import 'package:flutter/material.dart';

import 'package:frontend/utils/app_text_styles.dart';
import 'package:frontend/utils/global_params.dart';

class CandidateStats extends StatelessWidget {
  final String rating;
  final String attendance;
  final String distance;

  const CandidateStats({
    super.key,
    required this.rating,
    required this.attendance,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Stat(
          icon: '★',
          value: rating,
        ),
        _Divider(),
        _Stat(
          icon: '▣',
          value: attendance,
        ),
        _Divider(),
        _Stat(
          icon: '⌖',
          value: distance,
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String icon;
  final String value;

  const _Stat({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          icon,
          style: AppTextStyles.label14(
            GlobalParams.slate500,
          ),
        ),
        const SizedBox(width: GlobalParams.spacing4),
        Text(
          value,
          style: AppTextStyles.label14(
            GlobalParams.slate700,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: GlobalParams.spacing8,
      ),
      child: Container(
        width: 1,
        height: 14,
        color: GlobalParams.slate200,
      ),
    );
  }
}