import 'package:bloc/bloc.dart';
import '../../../domain/entities/promotion.dart';
import '../../../domain/usecases/get_venue_promotions.dart';
import '../../../domain/usecases/create_promotion.dart';
import 'package:equatable/equatable.dart';

part 'promotion_event.dart';
part 'promotion_state.dart';


class PromotionBloc extends Bloc<PromotionEvent, PromotionState> {
  final GetVenuePromotions getVenuePromotions;
  final CreatePromotion createPromotion;

  PromotionBloc({required this.getVenuePromotions, required this.createPromotion}) : super(PromotionInitial()) {
    
    on<LoadVenuePromotions>((event, emit) async {
      emit(PromotionLoading());
      final result = await getVenuePromotions(event.venueId);
      result.fold(
        (failure) => emit(const PromotionError("Error al cargar promociones")),
        (promotions) => emit(PromotionLoaded(promotions)),
      );
    });

    on<CreatePromotionRequested>((event, emit) async {
      emit(PromotionLoading());

      final result = await createPromotion(CreatePromotionParams(
        venueId: event.venueId, 
        promotion: event.promotion, 
        partnerId: event.partnerId 
      ));

      result.fold(
        (failure) => emit(const PromotionError("No se pudo crear la promoción")),
        (success) {
          emit(PromotionCreatedSuccess());
          add(LoadVenuePromotions(event.venueId)); // Recargar lista
        },
      );
    });
  }
}