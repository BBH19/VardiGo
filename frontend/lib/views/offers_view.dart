import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/blocs/offer/offer_bloc.dart';
import 'package:frontend/blocs/offer/offer_state.dart';
import 'package:frontend/blocs/offer/offer_event.dart';
import 'package:frontend/models/offer.dart';
import 'package:frontend/services/vardigo_service.dart';
import 'package:frontend/utils/app_text_styles.dart';
import 'package:frontend/utils/global_params.dart';
import 'package:frontend/widgets/common/app_icon_button.dart';
import 'package:frontend/widgets/offer/offer_card.dart';
import 'package:frontend/widgets/offer/offer_sort_chip.dart';
import 'package:frontend/widgets/offer/offer_tabs.dart';


class InterviewRequestsView extends StatefulWidget {
  final int pendingCountLabel;

  const InterviewRequestsView({
    super.key,
    required this.pendingCountLabel,
  });

  @override
  State<InterviewRequestsView> createState() => _InterviewRequestsViewState();
}

class _InterviewRequestsViewState extends State<InterviewRequestsView> {
  late Future<bool> workerLogin;

  @override
  void initState() {
    super.initState();
    workerLogin = VardigoService.login('worker');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: workerLogin,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data != true) {
          return const Scaffold(
            body: Center(child: Text('Worker login failed')),
          );
        }

        return BlocProvider(
          create: (_) => OfferBloc()..add(InitializingOfferEvent()),
          child: _InterviewRequestsContent(
            pendingCountLabel: widget.pendingCountLabel,
          ),
        );
      },
    );
  }
}

class _InterviewRequestsContent extends StatefulWidget {
  final int pendingCountLabel;

  const _InterviewRequestsContent({
    required this.pendingCountLabel,
  });

  @override
  State<_InterviewRequestsContent> createState() =>
      _InterviewRequestsContentState();
}

class _InterviewRequestsContentState extends State<_InterviewRequestsContent> {
  int _tab = 0;
  final Set<String> _detailsOpen = {};

  static const _tabLabels = ['Bekleyen', 'Cevaplanan', 'Süresi Dolan'];
  static const _subtitles = [
    'Görüşme talepleri yanıt bekliyor',
    'Cevaplanan talepler',
    'Süresi dolan talepler',
  ];
  static const _emptyMessages = [
    'Bekleyen talep yok',
    'Kabul veya red ettiğin talepler burada listelenir',
    'Süresi dolan talep yok',
  ];

  String _statusForTab() {
    switch (_tab) {
      case 0:
        return 'pending';
      case 1:
        return 'answered';
      default:
        return 'expired';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OfferBloc, OfferState>(
      listener: (context, state) {
        if (state.requestState == OfferRequestState.Error &&
            state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: GlobalParams.white,
          body: SafeArea(
            child: Column(
              children: [
                _header(),
                Expanded(child: _body(state)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _body(OfferState state) {
    if (state.requestState == OfferRequestState.Loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.requestState == OfferRequestState.Error &&
        state.data.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            state.errorMessage.isEmpty ? 'Talepler yüklenemedi.' : state.errorMessage,
            textAlign: TextAlign.center,
            style: AppTextStyles.empty14,
          ),
        ),
      );
    }

    final items = state.data;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        GlobalParams.pageHorizontalPadding,
        0,
        GlobalParams.pageHorizontalPadding,
        GlobalParams.spacing16,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: GlobalParams.spacing8),
          child: Align(
            alignment: Alignment.centerRight,
            child: const OfferSortChip(),
          ),
        ),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                _emptyMessages[_tab],
                textAlign: TextAlign.center,
                style: AppTextStyles.empty14,
              ),
            ),
          )
        else
          for (final offer in items)
            Padding(
              padding: const EdgeInsets.only(bottom: GlobalParams.spacing12),
              child: _card(offer),
            ),
      ],
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        GlobalParams.pageHorizontalPadding,
        GlobalParams.spacing12,
        GlobalParams.pageHorizontalPadding,
        GlobalParams.spacing8,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               AppIconButton(
              icon: SvgPicture.asset(
                'assets/icons/back.svg',
                width: GlobalParams.sortChipIconSize,
                height: GlobalParams.sortChipIconSize,
              ),
              onTap: () => Navigator.maybePop(context),
            ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Görüşme Talepleri', style: AppTextStyles.title20),
                    Text(
                      _tab == 0
                          ? '${widget.pendingCountLabel} Görüşme talepleri yanıt bekliyor'
                          : _subtitles[_tab],
                      style: AppTextStyles.caption12,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: GlobalParams.squareButtonSize),
            ],
          ),
          const SizedBox(height: GlobalParams.spacing16),
          OfferTabs(
            selectedIndex: _tab,
            labels: _tabLabels,
            onTabChanged: (index) {
              setState(() => _tab = index);

              context.read<OfferBloc>().add(
                ChangeOfferTabEvent(_statusForTab()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _card(Offer offer) {
    final isPending = _tab == 0;
    final isDetailsOpen = _detailsOpen.contains(
      offer.id ?? '',
    );

    return OfferCard(
      offer: offer,
      isPending: isPending,
      isDetailsOpen: isDetailsOpen,
      onAccept: () {
        if (offer.id == null) return;

        context.read<OfferBloc>().add(
          AcceptOfferEvent(offer: offer),
        );
      },
      onReject: () {
        if (offer.id == null) return;

        context.read<OfferBloc>().add(
          RejectOfferEvent(offer: offer),
        );
      },
      onToggleDetails: () {
        final id = offer.id ?? '';

        setState(() {
          if (_detailsOpen.contains(id)) {
            _detailsOpen.remove(id);
          } else {
            _detailsOpen.add(id);
          }
        });
      },
    );
  }

}