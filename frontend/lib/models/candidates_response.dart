import 'candidate.dart';

class CandidatesResponse {
  final List<Candidate> candidates;
  final int totalPerfect;
  final int totalSimilar;

  CandidatesResponse({
    required this.candidates,
    required this.totalPerfect,
    required this.totalSimilar,
  });
}