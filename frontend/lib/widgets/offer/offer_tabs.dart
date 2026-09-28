
import 'package:flutter/material.dart';

import 'package:frontend/utils/app_text_styles.dart';
import 'package:frontend/utils/global_params.dart';

class OfferTabs extends StatelessWidget {
  final int selectedIndex;
  final List<String> labels;
  final ValueChanged<int> onTabChanged;

  const OfferTabs({
    super.key,
    required this.selectedIndex,
    required this.labels,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        GlobalParams.tabPadding,
      ),
      decoration: BoxDecoration(
        color: GlobalParams.weak50,
        borderRadius: BorderRadius.circular(
          GlobalParams.tabRadius,
        ),
      ),
      child: Row(
        children: [
          for (int i = 0; i < labels.length; i++) ...[
            if (i > 0)
              const SizedBox(
                width: GlobalParams.spacing4,
              ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (selectedIndex == i) return;
                  onTabChanged(i);
                },
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 200,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: GlobalParams.spacing4,
                    vertical: GlobalParams.offerTabVerticalPadding,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selectedIndex == i
                        ? GlobalParams.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      GlobalParams.offerTabRadius,
                    ),
                    boxShadow: selectedIndex == i
                        ? GlobalParams.offerTabActiveShadow
                        : null,
                  ),
                  child: Text(
                    labels[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.tab13(
                      selectedIndex == i
                          ? GlobalParams.strong
                          : GlobalParams.soft,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
