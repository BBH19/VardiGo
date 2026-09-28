// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:frontend/blocs/Candidate/candidate_bloc.dart';
import 'package:frontend/blocs/Candidate/candidate_event.dart';
import 'package:frontend/blocs/Candidate/candidate_state.dart';
import 'package:frontend/models/candidate.dart';
import 'package:frontend/services/vardigo_service.dart';
import 'package:frontend/utils/app_text_styles.dart';
import 'package:frontend/utils/global_params.dart';
import 'package:frontend/views/offers_view.dart';
import 'package:frontend/widgets/common/app_icon_button.dart';
import 'package:frontend/widgets/condidate/candidate_avatar.dart';
import 'package:frontend/widgets/condidate/candidate_sort_chip.dart';
import 'package:frontend/widgets/condidate/candidate_tabs.dart';



enum _Sort {
  recommended,
  nearest,
  rating,
}

/// "Eşleşen Personeller"
class MatchedStaffView extends StatefulWidget {
  const MatchedStaffView({super.key});

  @override
  State<MatchedStaffView> createState() => _MatchedStaffViewState();
}

class _MatchedStaffViewState extends State<MatchedStaffView> {
  static const _sortLabels = [
    'Önerilen',
    'En Yakın',
    'Puan',
  ];

  static const double _listTopGap = 16;

  static const double _stripe = GlobalParams.selectedStripeWidth;

  _Sort _sort = _Sort.recommended;

  late Future<bool> employerLogin;

  @override
  void initState() {
    super.initState();
    employerLogin = VardigoService.login('employer');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: employerLogin,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.data != true) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text(
                'Connexion employer impossible.',
              ),
            ),
          );
        }

        return BlocConsumer<CandidateBloc, CandidateState>(
          listener: (context, state) {
            if (state.requestState == CandidateRequestState.Sent) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InterviewRequestsView(
                    pendingCountLabel: state.pendingCountLabel,
                  )
                ),
              ).then((_) async {
                await VardigoService.login('employer');
                if (!mounted) return;
                context.read<CandidateBloc>().add(
                      InitializingCandidateEvent(),
                    );
              });
            }

            if (state.requestState == CandidateRequestState.Error &&
                state.errorMessage.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                ),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: GlobalParams.white,
              body: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    _header(state),
                    Expanded(
                      child: _body(state),
                    ),
                    _footer(state),
                  ], 
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _body(CandidateState state) {
    if (state.requestState == CandidateRequestState.Loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.requestState == CandidateRequestState.Error &&
        state.data.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            state.errorMessage.isEmpty
                ? 'Personeller yüklenemedi.'
                : state.errorMessage,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption13,
          ),
        ),
      );
    }

    final items = state.data;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        GlobalParams.pageHorizontalPadding,
        GlobalParams.spacing8,
        GlobalParams.pageHorizontalPadding,
        GlobalParams.spacing16,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${state.selectedCandidates.length} kişi seçildi',
              style: AppTextStyles.title16Semi,
            ),
            CandidateSortChip(
              label: 'Sırala: ${_sortLabels[_sort.index]}',
              onTap: () {
                final nextSort =
                    _Sort.values[(_sort.index + 1) % _Sort.values.length];

                setState(() {
                  _sort = nextSort;
                });

                final sort = switch (nextSort) {
                  _Sort.recommended => 'recommended',
                  _Sort.nearest => 'near',
                  _Sort.rating => 'rating',
                };

                context.read<CandidateBloc>().add(
                  ChangeCandidateSortEvent(sort),
                );
              },
            ),
          ],
        ),

        const SizedBox(
          height: _listTopGap,
        ),

        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                'Personel bulunamadı.',
                style: AppTextStyles.caption13,
              ),
            ),
          ),

        for (int i = 0; i < items.length; i++) ...[
          if (i > 0)
            const SizedBox(
              height: GlobalParams.spacing10,
            ),
          _card(items[i], state),
        ],
      ],
    );
  }

  Widget _header(CandidateState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        GlobalParams.pageHorizontalPadding,
        GlobalParams.spacing16,
        GlobalParams.pageHorizontalPadding,
        GlobalParams.spacing8,
      ),
      child: Column(
        children: [
          Row(
            children: [
              AppIconButton(
              icon: SvgPicture.asset(
                'assets/icons/back.svg',
                width: GlobalParams.sortChipIconSize,
                height: GlobalParams.sortChipIconSize,
              ),
              onTap: () => Navigator.maybePop(context),
            ),

              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${state.totalPerfect} personel bulundu',
                      style: AppTextStyles.caption13,
                    ),
                    Text(
                      'Eşleşen Personeller',
                      style: AppTextStyles.title16Med,
                    ),
                  ],
                ),
              ),

               AppIconButton(
              icon: SvgPicture.asset(
                'assets/icons/help.svg',
                width: GlobalParams.sortChipIconSize,
                height: GlobalParams.sortChipIconSize,
              ),
            ),
            ],
          ),

          const SizedBox(
            height: GlobalParams.spacing20,
          ),

          CandidateTabs(
            selectedIndex: state.tab == 'perfect' ? 0 : 1,
            labels: [
              '%100 Eşleşme (${state.totalPerfect})',
              'Benzer Personeller (${state.totalSimilar})',
            ],
            onTabChanged: (index) {
              final tab = index == 0 ? 'perfect' : 'similar';

              context.read<CandidateBloc>().add(
                ChangeCandidateTabEvent(
                  tab: tab,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _card(
    Candidate candidate,
    CandidateState state,
  ) {
    final selected = state.selectedCandidates.any(
      (item) => item.id == candidate.id,
    );

    final radius = BorderRadius.circular(
      GlobalParams.cardRadius,
    );

    const h = GlobalParams.candidateCardHorizontalPadding;
    const v = GlobalParams.candidateCardVerticalPadding;

    final padding = selected
        ? const EdgeInsets.fromLTRB(
            h + 1 - _stripe,
            v + 1,
            h + 1,
            v + 1,
          )
        : const EdgeInsets.symmetric(
            horizontal: h,
            vertical: v,
          );

    return GestureDetector(
      onTap: () {
        if (candidate.id == null) {
          return;
        }

        context.read<CandidateBloc>().add(
              SelectCandidateEvent(
                candidate: candidate,
              ),
            );
      },

      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 200,
        ),
        decoration: BoxDecoration(
          color: selected
              ? GlobalParams.primary
              : GlobalParams.white,
          borderRadius: radius,
          border: selected
              ? null
              : Border.all(
                  color: GlobalParams.slate200,
                ),
          boxShadow: selected
              ? GlobalParams.cardSelectedShadow
              : GlobalParams.cardShadow,
        ),

        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 200,
          ),
          margin: EdgeInsets.only(
            left: selected ? _stripe : 0,
          ),
          padding: padding,
          decoration: BoxDecoration(
            color: selected
                ? GlobalParams.primaryLighter
                : Colors.transparent,
            borderRadius: radius,
          ),

          child: Column(
            children: [
              Row(
                children: [
                  CandidateAvatar(
                    candidate: candidate,
                  ),

                  const SizedBox(
                    width: GlobalParams.spacing12,
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          candidate.name ?? '',
                          // style: _T.title18,
                          style: AppTextStyles.title18,
                        ),

                        const SizedBox(
                          height: GlobalParams.spacing4,
                        ),

                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                          _stat(
                            Icon(
                              Icons.star,
                              size: GlobalParams.icon16,
                              color: GlobalParams.warning,
                            ),
                          
                            _rating(candidate),
                          ),

                              _divider(),

                              _stat(
                                SvgPicture.asset(
                                'assets/icons/shield.svg',
                              ),
                              
                                _attend(candidate),
                              ),

                              _divider(),

                              _stat(
                                SvgPicture.asset(
                                'assets/icons/pin.svg',
                              ),
                               
                                candidate.km ?? '-',
                                iconSize: 14,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    width: GlobalParams.spacing8,
                  ),

                  _checkbox(selected),
                ],
              ),

              const SizedBox(
                height: GlobalParams.spacing12,
              ),

              _salaryStrip(candidate),
            ],
          ),
        ),
      ),
    );
  }

  String _rating(Candidate candidate) {
    if (candidate.rating == null ||
        candidate.rating!.isEmpty) {
      return '-';
    }

    return candidate.rating!;
  }

  String _attend(Candidate candidate) {
    return candidate.attend ?? '-';
  }

  Map<String, dynamic> _salaryData(
    Candidate candidate,
  ) {
    switch (candidate.id) {
      case 'w_merve':
        return {
          'pay': '25.000',
          'payValue': 25000,
          'payFits': true,
        };

      case 'w_derya':
        return {
          'pay': '25.000',
          'payValue': 25000,
          'payFits': false,
        };

      case 'w_ayse':
        return {
          'pay': '25.000',
          'payValue': 25000,
          'payFits': true,
        };

      case 'w_ferhat':
        return {
          'pay': '25.000',
          'payValue': 25000,
          'payFits': false,
        };

      default:
        return {
          'pay': '25.000',
          'payValue': 25000,
          'payFits': false,
        };
    }
  }

  Widget _salaryStrip(
    Candidate candidate,
  ) {
    final salary = _salaryData(candidate);

    final String pay = salary['pay'];
    final bool payFits = salary['payFits'];

    final color = payFits
        ? GlobalParams.green
        : GlobalParams.kOrange;

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      decoration: BoxDecoration(
      
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/money.svg',
            width: GlobalParams.sortChipIconSize,
            height: GlobalParams.sortChipIconSize,
            color: color,
          ),
         
                    const SizedBox(
            width: GlobalParams.spacing4,
          ),

          Expanded(
            child: Text(
              payFits
                  ? 'Ücret beklentisi uyuşuyor'
                  : 'Ücret beklentisi uyuşmuyor',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.label14(color),
            ),
          ),

          Text(
            '₺$pay / ay',
            style: AppTextStyles.label14(color).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(
    Widget icon,
    
    String label, {
    double iconSize = 16,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
       icon,

        const SizedBox(
          width: GlobalParams.spacing4,
        ),

        Text(
          label,
          style: AppTextStyles.caption12Med,
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: GlobalParams.icon16,
      margin: const EdgeInsets.symmetric(
        horizontal: GlobalParams.spacing8,
      ),
      color: GlobalParams.slate200,
    );
  }

  Widget _checkbox(
    bool checked,
  ) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 150,
      ),
      width: GlobalParams.checkboxSize,
      height: GlobalParams.checkboxSize,
      decoration: BoxDecoration(
        color: checked
            ? GlobalParams.primary
            : GlobalParams.white,
        borderRadius: BorderRadius.circular(
          GlobalParams.checkboxRadius,
        ),
        border: Border.all(
          color: checked
              ? GlobalParams.primary
              : GlobalParams.slate300,
        ),
      ),
      child: checked
          ? SvgPicture.asset(
            'assets/icons/check.svg',
            width: GlobalParams.sortChipIconSize,
            height: GlobalParams.sortChipIconSize,
            color: GlobalParams.white,
            )
          : null,
    );
  }

  Widget _footer(
    CandidateState state,
  ) {
    final enabled =
        state.selectedCandidates.isNotEmpty;

    final sending =
        state.requestState ==
            CandidateRequestState.Sending;

    final radius = BorderRadius.circular(
      GlobalParams.ctaRadius,
    );

    return Container(
      decoration: const BoxDecoration(
        color: GlobalParams.weak,
        border: Border(
          top: BorderSide(
            color: GlobalParams.stroke,
          ),
        ),
      ),

      padding: const EdgeInsets.fromLTRB(
        GlobalParams.pageHorizontalPaddingFooter,
        GlobalParams.spacing20,
        GlobalParams.pageHorizontalPaddingFooter,
        0,
      ),

      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: GlobalParams.spacing8,
          ),
          child: Opacity(
            opacity: enabled
                ? 1
                : GlobalParams.disabledOpacity,

            child: Material(
              color: GlobalParams.primary,
              borderRadius: radius,

              child: InkWell(
                borderRadius: radius,

                onTap: enabled && !sending
                    ? () {
                        context
                            .read<CandidateBloc>()
                            .add(
                              SendOffersEvent(
                                selectedCandidates:
                                    state.selectedCandidates,
                              ),
                            );
                      }
                    : null,

                child: SizedBox(
                  height: GlobalParams.ctaHeight,
                  width: double.infinity,

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [
                      if (sending)
                        const SizedBox(
                          width:
                              GlobalParams.icon20,
                          height:
                              GlobalParams.icon20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color:
                                GlobalParams.white,
                          ),
                        )
                      else
                        // const Icon(
                        //   Icons.send_rounded,
                        //   size:
                        //       GlobalParams.icon20,
                        //   color:
                        //       GlobalParams.white,
                        // ),
                        SvgPicture.asset(
                          'assets/icons/send.svg',
                          width: GlobalParams.sortChipIconSize,
                          height: GlobalParams.sortChipIconSize,
                          color: GlobalParams.white,
                        ),
                      const SizedBox(
                        width:
                            GlobalParams.spacing4,
                      ),

                      Text(
                        sending
                            ? 'Gönderiliyor...'
                            : 'Görüşme Talebi Gönder (${state.selectedCandidates.length})',
                        style: AppTextStyles.label14(
                          GlobalParams.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}