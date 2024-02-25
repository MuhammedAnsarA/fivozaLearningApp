part of 'on_boarding_cubit.dart';

sealed class OnBoardingState extends Equatable {
  const OnBoardingState();

  @override
  List<Object> get props => [];
}

class OnBoardingInitial extends OnBoardingState {}

class CachingFirstTimer extends OnBoardingState {}

class CheckingIfUserIsFirstTimer extends OnBoardingState {}

class UserCached extends OnBoardingState {}

class OnBoardingStatus extends OnBoardingState {
  final bool isFirstTimer;

  const OnBoardingStatus({required this.isFirstTimer});

  @override
  List<bool> get props => [isFirstTimer];
}

class OnBoardingError extends OnBoardingState {
  final String message;

  const OnBoardingError(this.message);

  @override
  List<String> get props => [message];
}
