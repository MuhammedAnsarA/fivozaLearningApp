import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:fivoza_learning/core/errors/failures.dart';
import 'package:fivoza_learning/features/onboarding/domain/usecases/cache_first_timer.dart';
import 'package:fivoza_learning/features/onboarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:fivoza_learning/features/onboarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheFirstTimer extends Mock implements CacheFirstTimer {}

class MockCheckIfUserIsFirstTimer extends Mock
    implements CheckIfUserIsFirstTimer {}

void main() {
  late CacheFirstTimer cacheFirstTimer;
  late CheckIfUserIsFirstTimer checkIfUserIsFirstTimer;
  late OnBoardingCubit cubit;

  final tFailure =
      CacheFailure(message: "Insufficient storage permission", statusCode: 404);
  setUp(() {
    cacheFirstTimer = MockCacheFirstTimer();
    checkIfUserIsFirstTimer = MockCheckIfUserIsFirstTimer();
    cubit = OnBoardingCubit(
      cacheFirstTimer: cacheFirstTimer,
      checkIfUserIsFirstTimer: checkIfUserIsFirstTimer,
    );
  });

  test("initial state should be [OnBoardingInitial]", () {
    /// arrange

    /// act

    /// assert
    expect(cubit.state, OnBoardingInitial());
  });

  group("cacheFirstTimer", () {
    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emit [CachingFirstTimer,UserCached] when successfull.',
      build: () {
        when(() => cacheFirstTimer())
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.cacheFirstTimer(),
      expect: () => [
        CachingFirstTimer(),
        UserCached(),
      ],
      verify: (_) {
        verify(() => cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(cacheFirstTimer);
      },
    );

    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emit [CachingFirstTimer,OnBoardingError] when unsuccessfull.',
      build: () {
        when(() => cacheFirstTimer()).thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.cacheFirstTimer(),
      expect: () => [
        CachingFirstTimer(),
        OnBoardingError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(cacheFirstTimer);
      },
    );
  });

  group("checkIfUserIsFirstTimer", () {
    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emit [CheckingIfUserIsFirstTimer,OnBoardingStatus] when successfull.',
      build: () {
        when(() => checkIfUserIsFirstTimer())
            .thenAnswer((_) async => const Right(false));
        return cubit;
      },
      act: (cubit) => cubit.checkIfUserIsFirstTimer(),
      expect: () => [
        CheckingIfUserIsFirstTimer(),
        const OnBoardingStatus(isFirstTimer: false),
      ],
      verify: (_) {
        verify(() => checkIfUserIsFirstTimer()).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );

    blocTest<OnBoardingCubit, OnBoardingState>(
      'should emit [CheckingIfUserIsFirstTimer,OnBoardingStatus(true)] when unsuccessfull.',
      build: () {
        when(() => checkIfUserIsFirstTimer())
            .thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.checkIfUserIsFirstTimer(),
      expect: () => [
        CheckingIfUserIsFirstTimer(),
        const OnBoardingStatus(isFirstTimer: true),
      ],
      verify: (_) {
        verify(() => checkIfUserIsFirstTimer()).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );
  });
}
