import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/blocs/offer/offer_event.dart';
import 'package:frontend/blocs/offer/offer_state.dart';
import 'package:frontend/services/vardigo_service.dart';

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  OfferBloc()
      : super(
          OfferState(
            data: const [],
            requestState: OfferRequestState.Loading,
            errorMessage: '',
            status: 'pending',
            pendingCount: 0,
          ),
        ) {

    on<InitializingOfferEvent>((event, emit) async {
      emit(
        OfferState(
          data: const [],
          requestState: OfferRequestState.Loading,
          errorMessage: '',
          status: 'pending',
          pendingCount: 0,
        ),
      );

      try {
        final offers = await VardigoService.getOffers(
          status: 'pending',
        );

        emit(
          OfferState(
            data: offers,
            requestState: OfferRequestState.Loaded,
            errorMessage: '',
            status: 'pending',
            pendingCount: offers.length,
          ),
        );
      } catch (e) {
        emit(
          OfferState(
            data: const [],
            requestState: OfferRequestState.Error,
            errorMessage: e.toString(),
            status: 'pending',
            pendingCount: 0,
          ),
        );
      }
    });


    on<LoadOffersEvent>((event, emit) async {
      emit(
        OfferState(
          data: state.data,
          requestState: OfferRequestState.Loading,
          errorMessage: '',
          status: event.status,
          pendingCount: state.pendingCount,
        ),
      );

      try {
        final offers = await VardigoService.getOffers(
          status: event.status,
        );

        final pendingCount = event.status == 'pending'
            ? offers.length
            : state.pendingCount;

        emit(
          OfferState(
            data: offers,
            requestState: OfferRequestState.Loaded,
            errorMessage: '',
            status: event.status,
            pendingCount: pendingCount,
          ),
        );
      } catch (e) {
        emit(
          OfferState(
            data: const [],
            requestState: OfferRequestState.Error,
            errorMessage: e.toString(),
            status: event.status,
            pendingCount: state.pendingCount,
          ),
        );
      }
    });


    on<ChangeOfferTabEvent>((event, emit) async {
      emit(
        OfferState(
          data: const [],
          requestState: OfferRequestState.Loading,
          errorMessage: '',
          status: event.status,
          pendingCount: state.pendingCount,
        ),
      );

      try {
        final offers = await VardigoService.getOffers(
          status: event.status,
        );

        final pendingCount = event.status == 'pending'
            ? offers.length
            : state.pendingCount;

        emit(
          OfferState(
            data: offers,
            requestState: OfferRequestState.Loaded,
            errorMessage: '',
            status: event.status,
            pendingCount: pendingCount,
          ),
        );
      } catch (e) {
        emit(
          OfferState(
            data: const [],
            requestState: OfferRequestState.Error,
            errorMessage: e.toString(),
            status: event.status,
            pendingCount: state.pendingCount,
          ),
        );
      }
    });

    on<AcceptOfferEvent>((event, emit) async {
      emit(
        OfferState(
          data: state.data,
          requestState: OfferRequestState.Accepting,
          errorMessage: '',
          status: state.status,
          pendingCount: state.pendingCount,
        ),
      );

      try {
        if (event.offer.id == null) {
          emit(
            OfferState(
              data: state.data,
              requestState: OfferRequestState.Error,
              errorMessage: 'Teklif ID bulunamadı.',
              status: state.status,
              pendingCount: state.pendingCount,
            ),
          );
          return;
        }

        final result = await VardigoService.acceptOffer(
          event.offer.id!,
        );

        if (result) {
          // Reload pending offers after accepting.
          final offers = await VardigoService.getOffers(
            status: state.status,
          );

          final pendingCount = state.status == 'pending'
              ? offers.length
              : state.pendingCount;

          emit(
            OfferState(
              data: offers,
              requestState: OfferRequestState.Accepted,
              errorMessage: '',
              status: state.status,
              pendingCount: pendingCount,
            ),
          );
        } else {
          emit(
            OfferState(
              data: state.data,
              requestState: OfferRequestState.Error,
              errorMessage: 'Görüşme talebi kabul edilemedi.',
              status: state.status,
              pendingCount: state.pendingCount,
            ),
          );
        }
      } catch (e) {
        emit(
          OfferState(
            data: state.data,
            requestState: OfferRequestState.Error,
            errorMessage: e.toString(),
            status: state.status,
            pendingCount: state.pendingCount,
          ),
        );
      }
    });

 
    on<RejectOfferEvent>((event, emit) async {
      emit(
        OfferState(
          data: state.data,
          requestState: OfferRequestState.Rejecting,
          errorMessage: '',
          status: state.status,
          pendingCount: state.pendingCount,
        ),
      );

      try {
        if (event.offer.id == null) {
          emit(
            OfferState(
              data: state.data,
              requestState: OfferRequestState.Error,
              errorMessage: 'Teklif ID bulunamadı.',
              status: state.status,
              pendingCount: state.pendingCount,
            ),
          );
          return;
        }

        final result = await VardigoService.rejectOffer(
          event.offer.id!,
        );

        if (result) {
          // Reload offers after rejecting.
          final offers = await VardigoService.getOffers(
            status: state.status,
          );

          final pendingCount = state.status == 'pending'
              ? offers.length
              : state.pendingCount;

          emit(
            OfferState(
              data: offers,
              requestState: OfferRequestState.Rejected,
              errorMessage: '',
              status: state.status,
              pendingCount: pendingCount,
            ),
          );
        } else {
          emit(
            OfferState(
              data: state.data,
              requestState: OfferRequestState.Error,
              errorMessage: 'Görüşme talebi reddedilemedi.',
              status: state.status,
              pendingCount: state.pendingCount,
            ),
          );
        }
      } catch (e) {
        emit(
          OfferState(
            data: state.data,
            requestState: OfferRequestState.Error,
            errorMessage: e.toString(),
            status: state.status,
            pendingCount: state.pendingCount,
          ),
        );
      }
    });
  }
}

