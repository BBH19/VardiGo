import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/blocs/Candidate/candidate_event.dart';
import 'package:frontend/blocs/Candidate/candidate_state.dart';
import 'package:frontend/models/candidate.dart';
import 'package:frontend/services/vardigo_service.dart';

class CandidateBloc extends Bloc<CandidateEvent, CandidateState> {
CandidateBloc()
: super(
CandidateState(
data: const [],
selectedCandidates: const [],
requestState: CandidateRequestState.Loading,
errorMessage: '',
tab: 'perfect',
sort: 'recommended',
totalPerfect: 0,
totalSimilar: 0,
pendingCountLabel: 0,
),
) {
// =========================
// INITIALISATION
// =========================
on<InitializingCandidateEvent>((event, emit) async {
emit(
CandidateState(
data: const [],
selectedCandidates: const [],
requestState: CandidateRequestState.Loading,
errorMessage: '',
tab: 'perfect',
sort: 'recommended',
totalPerfect: state.totalPerfect,
totalSimilar: state.totalSimilar,
pendingCountLabel: state.pendingCountLabel,
),
);


  try {
    final result = await VardigoService.getCandidates(
      tab: 'perfect',
      sort: 'recommended',
    );

    final candidates = result['candidates'] as List<Candidate>;
    final totalPerfect = result['totalPerfect'] as int;
    final totalSimilar = result['totalSimilar'] as int;
    final pendingCountLabel =
        result['pendingCountLabel'] as int? ?? 0;

    emit(
      CandidateState(
        data: candidates,
        selectedCandidates: const [],
        requestState: CandidateRequestState.Loaded,
        errorMessage: '',
        tab: 'perfect',
        sort: 'recommended',
        totalPerfect: totalPerfect,
        totalSimilar: totalSimilar,
        pendingCountLabel: pendingCountLabel,
      ),
    );
  } catch (e) {
    emit(
      CandidateState(
        data: const [],
        selectedCandidates: const [],
        requestState: CandidateRequestState.Error,
        errorMessage: e.toString(),
        tab: 'perfect',
        sort: 'recommended',
        totalPerfect: 0,
        totalSimilar: 0,
        pendingCountLabel: 0,
      ),
    );
  }
});

// =========================
// LOAD CANDIDATES
// =========================
on<LoadCandidatesEvent>((event, emit) async {
  final currentTab = event.tab ?? state.tab;

  emit(
    CandidateState(
      data: const [],
      selectedCandidates: state.selectedCandidates,
      requestState: CandidateRequestState.Loading,
      errorMessage: '',
      tab: currentTab,
      sort: event.sort,
      totalPerfect: state.totalPerfect,
      totalSimilar: state.totalSimilar,
      pendingCountLabel: state.pendingCountLabel,
    ),
  );

  try {
    final result = await VardigoService.getCandidates(
      tab: currentTab,
      sort: event.sort,
    );

    final candidates = result['candidates'] as List<Candidate>;
    final totalPerfect = result['totalPerfect'] as int;
    final totalSimilar = result['totalSimilar'] as int;
    final pendingCountLabel =
        result['pendingCountLabel'] as int? ?? 0;

    emit(
      CandidateState(
        data: candidates,
        selectedCandidates: state.selectedCandidates,
        requestState: CandidateRequestState.Loaded,
        errorMessage: '',
        tab: currentTab,
        sort: event.sort,
        totalPerfect: totalPerfect,
        totalSimilar: totalSimilar,
        pendingCountLabel: pendingCountLabel,
      ),
    );
  } catch (e) {
    emit(
      CandidateState(
        data: const [],
        selectedCandidates: state.selectedCandidates,
        requestState: CandidateRequestState.Error,
        errorMessage: e.toString(),
        tab: currentTab,
        sort: event.sort,
        totalPerfect: state.totalPerfect,
        totalSimilar: state.totalSimilar,
        pendingCountLabel: state.pendingCountLabel,
      ),
    );
  }
});

// =========================
// CHANGE TAB
// =========================
on<ChangeCandidateTabEvent>((event, emit) async {
  final newTab = event.tab ?? 'perfect';

  emit(
    CandidateState(
      data: const [],
      selectedCandidates: state.selectedCandidates,
      requestState: CandidateRequestState.Loading,
      errorMessage: '',
      tab: newTab,
      sort: state.sort,
      totalPerfect: state.totalPerfect,
      totalSimilar: state.totalSimilar,
      pendingCountLabel: state.pendingCountLabel,
    ),
  );

  try {
    final result = await VardigoService.getCandidates(
      tab: newTab,
      sort: state.sort,
    );

    final candidates = result['candidates'] as List<Candidate>;
    final totalPerfect = result['totalPerfect'] as int;
    final totalSimilar = result['totalSimilar'] as int;
    final pendingCountLabel =
        result['pendingCountLabel'] as int? ?? 0;

    emit(
      CandidateState(
        data: candidates,
        selectedCandidates: state.selectedCandidates,
        requestState: CandidateRequestState.Loaded,
        errorMessage: '',
        tab: newTab,
        sort: state.sort,
        totalPerfect: totalPerfect,
        totalSimilar: totalSimilar,
        pendingCountLabel: pendingCountLabel,
      ),
    );
  } catch (e) {
    emit(
      CandidateState(
        data: const [],
        selectedCandidates: state.selectedCandidates,
        requestState: CandidateRequestState.Error,
        errorMessage: e.toString(),
        tab: newTab,
        sort: state.sort,
        totalPerfect: state.totalPerfect,
        totalSimilar: state.totalSimilar,
        pendingCountLabel: state.pendingCountLabel,
      ),
    );
  }
});

// =========================
// CHANGE SORT
// =========================
on<ChangeCandidateSortEvent>((event, emit) async {
  emit(
    CandidateState(
      data: const [],
      selectedCandidates: state.selectedCandidates,
      requestState: CandidateRequestState.Loading,
      errorMessage: '',
      tab: state.tab,
      sort: event.sort,
      totalPerfect: state.totalPerfect,
      totalSimilar: state.totalSimilar,
      pendingCountLabel: state.pendingCountLabel,
    ),
  );

  try {
    final result = await VardigoService.getCandidates(
      tab: state.tab,
      sort: event.sort,
    );

    final candidates = result['candidates'] as List<Candidate>;
    final totalPerfect = result['totalPerfect'] as int;
    final totalSimilar = result['totalSimilar'] as int;
    final pendingCountLabel =
        result['pendingCountLabel'] as int? ?? 0;

    emit(
      CandidateState(
        data: candidates,
        selectedCandidates: state.selectedCandidates,
        requestState: CandidateRequestState.Loaded,
        errorMessage: '',
        tab: state.tab,
        sort: event.sort,
        totalPerfect: totalPerfect,
        totalSimilar: totalSimilar,
        pendingCountLabel: pendingCountLabel,
      ),
    );
  } catch (e) {
    emit(
      CandidateState(
        data: const [],
        selectedCandidates: state.selectedCandidates,
        requestState: CandidateRequestState.Error,
        errorMessage: e.toString(),
        tab: state.tab,
        sort: event.sort,
        totalPerfect: state.totalPerfect,
        totalSimilar: state.totalSimilar,
        pendingCountLabel: state.pendingCountLabel,
      ),
    );
  }
});

// =========================
// SELECT / UNSELECT
// =========================
on<SelectCandidateEvent>((event, emit) {
  final selected =
      List<Candidate>.from(state.selectedCandidates);

  final alreadySelected = selected.any(
    (candidate) => candidate.id == event.candidate.id,
  );

  if (alreadySelected) {
    selected.removeWhere(
      (candidate) => candidate.id == event.candidate.id,
    );
  } else {
    selected.add(event.candidate);
  }

  emit(
    CandidateState(
      data: state.data,
      selectedCandidates: selected,
      requestState: CandidateRequestState.Loaded,
      errorMessage: '',
      tab: state.tab,
      sort: state.sort,
      totalPerfect: state.totalPerfect,
      totalSimilar: state.totalSimilar,
      pendingCountLabel: state.pendingCountLabel,
    ),
  );
});

// =========================
// SEND OFFERS
// =========================
on<SendOffersEvent>((event, emit) async {
  emit(
    CandidateState(
      data: state.data,
      selectedCandidates: state.selectedCandidates,
      requestState: CandidateRequestState.Sending,
      errorMessage: '',
      tab: state.tab,
      sort: state.sort,
      totalPerfect: state.totalPerfect,
      totalSimilar: state.totalSimilar,
      pendingCountLabel: state.pendingCountLabel,
    ),
  );

  try {
    final workerIds = event.selectedCandidates
        .where((candidate) => candidate.id != null)
        .map((candidate) => candidate.id!)
        .toList();

    if (workerIds.isEmpty) {
      emit(
        CandidateState(
          data: state.data,
          selectedCandidates: state.selectedCandidates,
          requestState: CandidateRequestState.Error,
          errorMessage:
              'Lütfen en az bir personel seçin.',
          tab: state.tab,
          sort: state.sort,
          totalPerfect: state.totalPerfect,
          totalSimilar: state.totalSimilar,
          pendingCountLabel: state.pendingCountLabel,
        ),
      );
      return;
    }

    final result = await VardigoService.createOffers(
      workerIds,
    );

    if (result) {
      emit(
        CandidateState(
          data: state.data,
          selectedCandidates: const [],
          requestState: CandidateRequestState.Sent,
          errorMessage: '',
          tab: state.tab,
          sort: state.sort,
          totalPerfect: state.totalPerfect,
          totalSimilar: state.totalSimilar,
          pendingCountLabel: state.pendingCountLabel,
        ),
      );
    } else {
      emit(
        CandidateState(
          data: state.data,
          selectedCandidates: state.selectedCandidates,
          requestState: CandidateRequestState.Error,
          errorMessage:
              'Görüşme talebi gönderilemedi.',
          tab: state.tab,
          sort: state.sort,
          totalPerfect: state.totalPerfect,
          totalSimilar: state.totalSimilar,
          pendingCountLabel: state.pendingCountLabel,
        ),
      );
    }
  } catch (e) {
    emit(
      CandidateState(
        data: state.data,
        selectedCandidates: state.selectedCandidates,
        requestState: CandidateRequestState.Error,
        errorMessage: e.toString(),
        tab: state.tab,
        sort: state.sort,
        totalPerfect: state.totalPerfect,
        totalSimilar: state.totalSimilar,
        pendingCountLabel: state.pendingCountLabel,
      ),
    );
  }
});


}
}
