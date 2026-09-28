// ignore_for_file: constant_identifier_names

import 'package:frontend/models/candidate.dart';

enum CandidateRequestState {
  Loaded,
  Loading,
  Selecting,
  Sending,
  Sent,
  Error,
  None,
}

class CandidateState {
  List<Candidate> data;
  List<Candidate> selectedCandidates;

  CandidateRequestState requestState;
  String errorMessage;
  String tab;
  String sort;

  // Counts from backend
  int totalPerfect;
  int totalSimilar;
  int pendingCountLabel;

  CandidateState({
    required this.data,
    required this.selectedCandidates,
    required this.requestState,
    required this.errorMessage,
    this.tab = 'perfect',
    this.sort = 'recommended',
    this.totalPerfect = 0,
    this.totalSimilar = 0,
    this.pendingCountLabel = 0,
  });

  List<Object> get props => [
        data,
        selectedCandidates,
        requestState,
        errorMessage,
        tab,
        sort,
        totalPerfect,
        totalSimilar,
        pendingCountLabel,
      ];

  bool get isLoadingState {
    return requestState == CandidateRequestState.Loading ||
        requestState == CandidateRequestState.Sending ||
        requestState == CandidateRequestState.Selecting;
  }
}