part of 'home_bloc.dart';

abstract class HomeEvent {}

class FetchPhotosEvent extends HomeEvent {}

class ToggleSearchEvent extends HomeEvent {}

class SearchPhotosEvent extends HomeEvent {
  final String query;
  SearchPhotosEvent(this.query);
}

class ClearSearchEvent extends HomeEvent {}

class SearchCancelled extends HomeEvent {}
