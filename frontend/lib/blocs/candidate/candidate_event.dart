import 'package:frontend/models/candidate.dart';

abstract class CandidateEvent {
  const CandidateEvent();

  List<Object> get props => [];
}

class LoadCandidatesEvent extends CandidateEvent {
  String? tab;
  String sort;

  LoadCandidatesEvent({
    this.tab,
    this.sort = 'recommended',
  });

  @override
  List<Object> get props => [
        tab ?? '',
        sort,
      ];
}

class ChangeCandidateTabEvent extends CandidateEvent {
  String? tab;

  ChangeCandidateTabEvent({
    this.tab,
  });

  @override
  List<Object> get props => [
        tab ?? '',
      ];
}

class ChangeCandidateSortEvent extends CandidateEvent {
  String sort;

  ChangeCandidateSortEvent(this.sort);

  @override
  List<Object> get props => [
        sort,
      ];
}

class SelectCandidateEvent extends CandidateEvent {
  Candidate candidate;

  SelectCandidateEvent({
    required this.candidate,
  });

  @override
  List<Object> get props => [
        candidate,
      ];
}

class SendOffersEvent extends CandidateEvent {
  List<Candidate> selectedCandidates;

  SendOffersEvent({
    required this.selectedCandidates,
  });

  @override
  List<Object> get props => [
        selectedCandidates,
      ];
}

class InitializingCandidateEvent extends CandidateEvent {}