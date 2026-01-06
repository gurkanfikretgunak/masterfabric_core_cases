part of 'home_cubit.dart';

/// Home screen state
class HomeState extends Equatable {
  final int counter;
  final bool isLoading;

  const HomeState({this.counter = 0, this.isLoading = true});

  HomeState copyWith({int? counter, bool? isLoading}) {
    return HomeState(
      counter: counter ?? this.counter,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [counter, isLoading];
}
