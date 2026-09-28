
import 'package:flutter/material.dart';

import 'package:frontend/utils/app_text_styles.dart';
import 'package:frontend/utils/global_params.dart';

class CandidateTabs extends StatelessWidget {
  final int selectedIndex;
  final List<String> labels;
  final ValueChanged<int> onTabChanged;

  const CandidateTabs({
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
        color: GlobalParams.slate100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          for (int i = 0; i < labels.length; i++)
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
                    horizontal: GlobalParams.spacing8,
                    vertical: GlobalParams.candidateTabVerticalPadding,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selectedIndex == i
                        ? GlobalParams.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: selectedIndex == i
                        ? GlobalParams.candidateTabActiveShadow
                        : null,
                  ),
                  child: Text(
                    labels[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.tab12(
                      selectedIndex == i
                          ? GlobalParams.white
                          : GlobalParams.slate500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
