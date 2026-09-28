
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:frontend/models/candidate.dart';
import 'package:frontend/utils/app_text_styles.dart';
import 'package:frontend/utils/global_params.dart';

class CandidateAvatar extends StatelessWidget {
  final Candidate candidate;

  const CandidateAvatar({
    super.key,
    required this.candidate,
  });

  @override
  Widget build(BuildContext context) {
    const size = GlobalParams.avatarSize;

    final name = candidate.name ?? '?';
    final photo = candidate.photo;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipOval(
            child: photo != null && photo.isNotEmpty
                ? Image.asset(
                    photo,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return _fallback(name);
                    },
                  )
                : _fallback(name),
          ),
          if (candidate.online == true)
            Positioned(
              right: -5,
              bottom: -5,
              child: SvgPicture.asset(
                'assets/icons/online.svg',
                width: GlobalParams.onlineBadgeSize,
                height: GlobalParams.onlineBadgeSize,
              ),
            ),
        ],
      ),
    );
  }

  Widget _fallback(String name) {
    return Container(
      width: GlobalParams.avatarSize,
      height: GlobalParams.avatarSize,
      alignment: Alignment.center,
      color: GlobalParams.primaryLight,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: AppTextStyles.title18.copyWith(
          color: GlobalParams.primary,
        ),
      ),
    );
  }
}