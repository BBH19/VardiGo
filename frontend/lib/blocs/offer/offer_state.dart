
// ignore_for_file: constant_identifier_names

import 'package:frontend/models/offer.dart';

enum OfferRequestState {
  Loaded,
  Loading,
  Accepting,
  Accepted,
  Rejecting,
  Rejected,
  Error,
  None,
}

class OfferState {
  List<Offer> data = [];
  OfferRequestState requestState;
  String errorMessage;
  String status;

  int pendingCount;

  OfferState({
    required this.data,
    required this.requestState,
    required this.errorMessage,
    this.status = 'pending',
    this.pendingCount = 0,
  });

  List<Object> get props => [
        data,
        requestState,
        errorMessage,
        status,
        pendingCount,
      ];

  bool get isLoadingState {
    return requestState == OfferRequestState.Loading ||
        requestState == OfferRequestState.Accepting ||
        requestState == OfferRequestState.Rejecting;
  }
}

