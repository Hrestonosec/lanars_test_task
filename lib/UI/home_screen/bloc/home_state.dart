part of 'home_bloc.dart';

abstract class HomeState {}

class HomeLoading extends HomeState {}

class PhotosLoadedState extends HomeState {
  final List<Photo> photos;
  PhotosLoadedState({required this.photos});
}

class HomeError extends HomeState {
  final String error;

  HomeError({required this.error});
}
