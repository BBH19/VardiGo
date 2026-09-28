
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:frontend/models/offer.dart';
import 'package:frontend/utils/app_text_styles.dart';
import 'package:frontend/utils/global_params.dart';
import 'package:frontend/widgets/common/app_meta_item.dart';

class OfferCard extends StatelessWidget {
  final Offer offer;
  final bool isPending;
  final bool isDetailsOpen;

  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onToggleDetails;

  const OfferCard({
    super.key,
    required this.offer,
    required this.isPending,
    required this.isDetailsOpen,
    required this.onAccept,
    required this.onReject,
    required this.onToggleDetails,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = _remainingTime();

    return Container(
      padding: const EdgeInsets.all(
        GlobalParams.offerCardPadding,
      ),
      decoration: BoxDecoration(
        color: GlobalParams.white,
        borderRadius: BorderRadius.circular(
          GlobalParams.cardRadius,
        ),
        border: Border.all(
          color: GlobalParams.stroke,
        ),
        boxShadow: GlobalParams.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(
            height: GlobalParams.spacing12,
          ),
          _buildActions(),
          _buildDetails(),
          _buildCountdown(remaining),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLogo(),
        const SizedBox(
          width: GlobalParams.spacing12,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      offer.title ?? '',
                      style: AppTextStyles.title18,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/money.svg',
                    width: GlobalParams.sortChipIconSize,
                    height: GlobalParams.sortChipIconSize,
                  ),
                  const SizedBox(
                    width: GlobalParams.spacing4,
                  ),
                  Text(
                    '₺${offer.pay ?? ''}',
                    style: AppTextStyles.price18,
                  ),
                ],
              ),
              const SizedBox(
                height: GlobalParams.spacing8,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    AppMetaItem(
                      icon: SvgPicture.asset(
                        'assets/icons/pin.svg',
                        width: 14,
                        height: 14,
                      ),
                      label: offer.district ?? '',
                    ),
                    Container(
                      width: 1,
                      height: GlobalParams.icon16,
                      margin: const EdgeInsets.symmetric(
                        horizontal: GlobalParams.spacing8,
                      ),
                      color: GlobalParams.slate200,
                    ),
                    AppMetaItem(
                      icon: SvgPicture.asset(
                        'assets/icons/date.svg',
                        width: 14,
                        height: 14,
                      ),
                      label: offer.when ?? '',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    final status = _statusLabel();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isPending && offer.status == 'pending')
          Row(
            children: [
              Expanded(
                child: _offerButton(
                  label: 'İlgilenmiyorum',
                  icon: SvgPicture.asset(
                    'assets/icons/close.svg',
                  ),
                  background: GlobalParams.errorSoft,
                  foreground: GlobalParams.error,
                  onTap: onReject,
                ),
              ),
              const SizedBox(
                width: GlobalParams.spacing12,
              ),
              Expanded(
                child: _offerButton(
                  label: 'İlgileniyorum',
                  icon: SvgPicture.asset(
                    'assets/icons/check.svg',
                    width: GlobalParams.sortChipIconSize,
                    height: GlobalParams.sortChipIconSize,
                    color: GlobalParams.white,
                  ),
                  background: GlobalParams.green,
                  foreground: GlobalParams.white,
                  onTap: onAccept,
                ),
              ),
            ],
          )
        else if (status != null)
          Text(
            status.label,
            style: AppTextStyles.label14(status.color),
          ),
        if (isPending)
          const SizedBox(
            height: GlobalParams.spacing12,
          ),
        _offerButton(
          label: 'Detayları Gör',
          icon: Icon(
            isDetailsOpen
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          iconSize: GlobalParams.icon20,
          background: GlobalParams.white,
          foreground: GlobalParams.sub,
          border: GlobalParams.stroke,
          onTap: onToggleDetails,
        ),
      ],
    );
  }

  Widget _buildDetails() {
    if (!isDetailsOpen) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: GlobalParams.spacing10,
        ),
        Text(
          'Konum: ${offer.district ?? '-'}',
          style: AppTextStyles.caption12Med,
        ),
        const SizedBox(
          height: GlobalParams.spacing2,
        ),
        Text(
          'Ücret: ${offer.pay ?? '-'} · Saat: ${offer.when ?? '-'}',
          style: AppTextStyles.caption12Med,
        ),
      ],
    );
  }

  Widget _buildCountdown(Duration remaining) {
    if (!isPending || offer.status != 'pending') {
      return const SizedBox.shrink();
    }

    final urgencyColor = remaining.inHours < 12
        ? GlobalParams.error
        : GlobalParams.warning;

    return Column(
      children: [
        const SizedBox(
          height: GlobalParams.spacing10,
        ),
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/alarm.svg',
              width: GlobalParams.sortChipIconSize,
              height: GlobalParams.sortChipIconSize,
            ),
            const SizedBox(
              width: GlobalParams.spacing4,
            ),
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: AppTextStyles.caption12.copyWith(
                    color: GlobalParams.strong,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Teklifin sonlanmasına ',
                    ),
                    TextSpan(
                      text:
                          '${remaining.inHours} saat ${remaining.inMinutes % 60} dakika',
                      style: AppTextStyles.caption12.copyWith(
                        fontWeight: FontWeight.w700,
                        color: urgencyColor,
                      ),
                    ),
                    const TextSpan(
                      text: ' kaldı.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogo() {
    if (offer.logo != null && offer.logo!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(
          GlobalParams.cardRadius,
        ),
        child: SvgPicture.asset(
          offer.logo!,
          width: 48,
          height: 48,
          fit: BoxFit.contain,
        ),
      );
    }

    return _buildLogoFallback(
      offer.title ?? '',
    );
  }

  Widget _buildLogoFallback(String name) {
    final letter = name.isNotEmpty
        ? name[0].toUpperCase()
        : '?';

    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: GlobalParams.slate200,
        borderRadius: BorderRadius.circular(
          GlobalParams.cardRadius,
        ),
      ),
      child: Text(
        letter,
        style: AppTextStyles.title18,
      ),
    );
  }

  Duration _remainingTime() {
    final expiresAt = DateTime.tryParse(
      offer.expiresAt ?? '',
    );

    if (expiresAt == null) {
      return Duration.zero;
    }

    final remaining = expiresAt.difference(
      DateTime.now(),
    );

    return remaining.isNegative
        ? Duration.zero
        : remaining;
  }

  _OfferStatus? _statusLabel() {
    if (offer.status == 'accepted') {
      return _OfferStatus(
        label: 'İlgileniyorum dedin',
        color: GlobalParams.green,
      );
    }

    if (offer.status == 'rejected') {
      return _OfferStatus(
        label: 'İlgilenmiyorum dedin',
        color: GlobalParams.error,
      );
    }

    if (offer.status == 'expired') {
      return _OfferStatus(
        label: 'Süresi doldu',
        color: GlobalParams.gray500,
      );
    }

    return null;
  }

  Widget _offerButton({
    required String label,
    required Widget icon,
    required Color background,
    required Color foreground,
    required VoidCallback onTap,
    Color? border,
    double? iconSize,
  }) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(
        GlobalParams.cardRadius,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          GlobalParams.cardRadius,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: GlobalParams.spacing10,
            horizontal: GlobalParams.spacing12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              GlobalParams.cardRadius,
            ),
            border: border != null
                ? Border.all(color: border)
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: iconSize,
                height: iconSize,
                child: icon,
              ),
              const SizedBox(
                width: GlobalParams.spacing4,
              ),
              Flexible(
                child: Text(
                  label,
                  style: AppTextStyles.label14(foreground),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OfferStatus {
  final String label;
  final Color color;

  const _OfferStatus({
    required this.label,
    required this.color,
  });
}
