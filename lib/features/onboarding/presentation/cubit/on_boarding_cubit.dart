import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fivoza_learning/features/onboarding/domain/usecases/cache_first_timer.dart';
import 'package:fivoza_learning/features/onboarding/domain/usecases/check_if_user_is_first_timer.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  final CacheFirstTimer _cacheFirstTimer;
  final CheckIfUserIsFirstTimer _checkIfUserIsFirstTimer;
  OnBoardingCubit({
    required CacheFirstTimer cacheFirstTimer,
    required CheckIfUserIsFirstTimer checkIfUserIsFirstTimer,
  })  : _cacheFirstTimer = cacheFirstTimer,
        _checkIfUserIsFirstTimer = checkIfUserIsFirstTimer,
        super(OnBoardingInitial());

  Future<void> cacheFirstTimer() async {
    emit(CachingFirstTimer());
    final result = await _cacheFirstTimer();

    result.fold(
      (failure) => emit(OnBoardingError(failure.errorMessage)),
      (_) => emit(UserCached()),
    );
  }

  Future<void> checkIfUserIsFirstTimer() async {
    emit(CheckingIfUserIsFirstTimer());
    final result = await _checkIfUserIsFirstTimer();
    result.fold(
      (failure) => emit(const OnBoardingStatus(isFirstTimer: true)),
      (state) => emit(OnBoardingStatus(isFirstTimer: state)),
    );
  }
}
