import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeState {
  bool isMoviesSelected;
  HomeState({this.isMoviesSelected = true});

  HomeState copyWith() {
    return HomeState(isMoviesSelected: !isMoviesSelected);
  }
}

class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel() : super(HomeState());

  void toggleMoviesSelection() {
    state = HomeState(isMoviesSelected: !state.isMoviesSelected);
  }
}
