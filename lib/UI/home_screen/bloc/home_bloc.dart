import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

import '../models/photo.dart';
import '../services/pexel_api_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PexelsApiService apiService;
  List<Photo> _allPhotos = [];
  List<MapEntry<String, List<Photo>>> _sortedGroupPhotos = [];

  HomeBloc(this.apiService) : super(HomeLoadingState()) {
    on<FetchPhotosEvent>(_onFetchPhotos);
    on<ToggleSearchEvent>(_onToggleSearch);
    on<SearchPhotosEvent>(_onSearchPhotos);
    on<ClearSearchEvent>(_onClearSearch);
    on<SearchCancelled>((event, emit) =>
        emit(HomeLoadedState(loadedPhotos: _sortedGroupPhotos)));
  }

  Future<void> _onFetchPhotos(
      FetchPhotosEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    try {
      _allPhotos = await apiService.fetchPhotos();

      if (_allPhotos.isEmpty) {
        // Якщо список порожній, викликаємо стан HomeEmptyState
        emit(HomeEmptyState());
      } else {
        _allPhotos.sort((a, b) => a.photographer.compareTo(b.photographer));

        // Групування за першою літерою імені фотографа
        final groupedPhotos = groupBy(
          _allPhotos,
          (photo) => photo.photographer.isEmpty
              ? '#' // для фотографій без імені
              : photo.photographer[0].toUpperCase(),
        );

        // Сортування груп за ключами (літерами) у спадаючому порядку
        _sortedGroupPhotos = groupedPhotos.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));

        emit(HomeLoadedState(loadedPhotos: _sortedGroupPhotos));
      }
    } catch (e) {
      emit(HomeErrorState(error: e.toString()));
    }
  }

  void _onToggleSearch(ToggleSearchEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoadedState) {
      emit(HomeSearchingState(searchedPhotos: _allPhotos));
    } else if (state is HomeSearchingState) {
      emit(HomeLoadedState(loadedPhotos: _sortedGroupPhotos));
    }
  }

  void _onSearchPhotos(SearchPhotosEvent event, Emitter<HomeState> emit) {
    if (state is HomeSearchingState) {
      final filteredPhotos = _allPhotos
          .where((photo) => photo.photographer
              .toLowerCase()
              .contains(event.query.toLowerCase()))
          .toList();
      emit(HomeSearchingState(searchedPhotos: filteredPhotos));
    }
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<HomeState> emit) {
    if (state is HomeSearchingState) {
      emit(HomeSearchingState(
          searchedPhotos: _allPhotos)); // Повернення до повного списку
    }
  }
}
