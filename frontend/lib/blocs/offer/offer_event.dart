import 'package:frontend/models/offer.dart';

abstract class OfferEvent {
  const OfferEvent();

  List<Object> get props => [];
}

class LoadOffersEvent extends OfferEvent {
  String status;

  LoadOffersEvent({
    this.status = 'pending',
  });

  @override
  List<Object> get props => [status];
}

class ChangeOfferTabEvent extends OfferEvent {
  String status;

  ChangeOfferTabEvent(this.status);

  @override
  List<Object> get props => [status];
}

class AcceptOfferEvent extends OfferEvent {
  Offer offer;

  AcceptOfferEvent({
    required this.offer,
  });

  @override
  List<Object> get props => [offer];
}

class RejectOfferEvent extends OfferEvent {
  Offer offer;

  RejectOfferEvent({
    required this.offer,
  });

  @override
  List<Object> get props => [offer];
}

class InitializingOfferEvent extends OfferEvent {}