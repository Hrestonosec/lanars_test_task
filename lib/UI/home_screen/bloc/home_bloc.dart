import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

import '../models/photo.dart';
import '../services/pexel_api_service.dart';

part 'home_event.dart';
part 'home_state.dart';

// HomeBloc class responsible for handling the logic related to photo fetching and search
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PexelsApiService apiService; // API service for fetching photos
  List<Photo> _allPhotos = []; // List to store all fetched photos
  List<MapEntry<String, List<Photo>>> _sortedGroupPhotos =
      []; // Sorted list of photos grouped by photographer

  HomeBloc(this.apiService) : super(HomeLoadingState()) {
    on<FetchPhotosEvent>(_onFetchPhotos);
    on<ToggleSearchEvent>(_onToggleSearch);
    on<SearchPhotosEvent>(_onSearchPhotos);
    on<ClearSearchEvent>(_onClearSearch);
    on<SearchCancelled>((event, emit) =>
        emit(HomeLoadedState(loadedPhotos: _sortedGroupPhotos)));
  }

  // Handler for FetchPhotosEvent - fetches photos and updates state
  Future<void> _onFetchPhotos(
      FetchPhotosEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState()); // Show loading state while fetching data
    try {
      _allPhotos = await apiService.fetchPhotos(); // Fetch photos from API

      if (_allPhotos.isEmpty) {
        emit(HomeEmptyState()); // Emit empty state if no photos are returned
      } else {
        _allPhotos.sort((a, b) => a.photographer
            .compareTo(b.photographer)); // Sort photos by photographer

        // Group photos by the first letter of the photographer's name
        final groupedPhotos = groupBy(
          _allPhotos,
          (photo) => photo.photographer.isEmpty
              ? '#' // For photos without a name
              : photo.photographer[0].toUpperCase(),
        );

        // Sort grouped photos by the photographer's initial
        _sortedGroupPhotos = groupedPhotos.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));

        emit(HomeLoadedState(
            loadedPhotos:
                _sortedGroupPhotos)); // Emit loaded state with grouped photos
      }
    } catch (e) {
      emit(HomeErrorState(
          error: e.toString())); // Emit error state in case of failure
    }
  }

  // Handler for ToggleSearchEvent - toggles between search and loaded states
  void _onToggleSearch(ToggleSearchEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoadedState) {
      emit(HomeSearchingState(
          searchedPhotos: _allPhotos)); // Show search state with all photos
    } else if (state is HomeSearchingState) {
      emit(HomeLoadedState(
          loadedPhotos:
              _sortedGroupPhotos)); // Show loaded photos when toggled back from search
    }
  }

  // Handler for SearchPhotosEvent - filters photos based on the search query
  void _onSearchPhotos(SearchPhotosEvent event, Emitter<HomeState> emit) {
    if (state is HomeSearchingState) {
      final filteredPhotos = _allPhotos
          .where((photo) => photo.photographer.toLowerCase().contains(event
              .query
              .toLowerCase())) // Filter photos by photographer's name
          .toList();
      emit(HomeSearchingState(
          searchedPhotos:
              filteredPhotos)); // Emit the search state with filtered photos
    }
  }

  // Handler for ClearSearchEvent - clears the search and displays all photos
  void _onClearSearch(ClearSearchEvent event, Emitter<HomeState> emit) {
    if (state is HomeSearchingState) {
      emit(HomeSearchingState(
          searchedPhotos: _allPhotos)); // Emit the search state with all photos
    }
  }
}
