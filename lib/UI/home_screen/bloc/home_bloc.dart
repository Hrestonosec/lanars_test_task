import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/photo.dart';
import '../services/pexel_api_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PexelsApiService apiService;

  HomeBloc(this.apiService) : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        final photos = await apiService.fetchPhotos();
        emit(PhotosLoadedState(photos: photos));
      } catch (e) {
        emit(HomeError(error: e.toString()));
      }
    });
  }
}
