import 'package:flutter/widgets.dart';
import 'package:frontend/utils/app_text_styles.dart';
import 'package:frontend/utils/global_params.dart';

class AppMetaItem extends StatelessWidget {
  final Widget icon;
  final String label;

  const AppMetaItem({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(
          width: GlobalParams.spacing4,
        ),
        Text(
          label,
          style: AppTextStyles.caption12,
        ),
      ],
    );
  }
}