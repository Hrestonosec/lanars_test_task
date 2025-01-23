part of 'home_bloc.dart';

abstract class HomeState {
  List<Photo> get photos => [];
  List<MapEntry<String, List<Photo>>> get groupPhotos => [];
}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<MapEntry<String, List<Photo>>> loadedPhotos;
  HomeLoadedState({required this.loadedPhotos});

  @override
  List<MapEntry<String, List<Photo>>> get groupPhotos => loadedPhotos;
}

class HomeSearchingState extends HomeState {
  final List<Photo> searchedPhotos;
  HomeSearchingState({required this.searchedPhotos});

  @override
  List<Photo> get photos => searchedPhotos;
}

class HomeErrorState extends HomeState {
  final String error;

  HomeErrorState({required this.error});
}

class HomeEmptyState extends HomeState {}
