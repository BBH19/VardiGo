
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:frontend/utils/app_text_styles.dart';
import 'package:frontend/utils/global_params.dart';

class OfferSortChip extends StatelessWidget {
  final VoidCallback? onTap;

  const OfferSortChip({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(
      GlobalParams.sortChipRadius,
    );

    return Container(
      height: GlobalParams.sortChipHeight,
      decoration: BoxDecoration(
        color: GlobalParams.white,
        borderRadius: radius,
        border: Border.all(
          color: GlobalParams.slate200,
        ),
        boxShadow: GlobalParams.sortShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: GlobalParams.spacing10,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/icons/sort.svg',
                  width: GlobalParams.sortChipIconSize,
                  height: GlobalParams.sortChipIconSize,
                  colorFilter: ColorFilter.mode(
                    GlobalParams.primary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(
                  width: GlobalParams.spacing2,
                ),
                Text(
                  'Sırala: Önerilen',
                  style: AppTextStyles.label14(
                    GlobalParams.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
