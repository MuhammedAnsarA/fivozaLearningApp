import 'package:dartz/dartz.dart';
import 'package:fivoza_learning/core/errors/failures.dart';
import 'package:fivoza_learning/features/onboarding/domain/repositories/onboarding_repo.dart';
import 'package:fivoza_learning/features/onboarding/domain/usecases/cache_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo.mock.dart';

void main() {
  late OnBoardingRepo repo;
  late CacheFirstTimer usecase;

  setUp(() {
    repo = MockOnboardingRepo();
    usecase = CacheFirstTimer(repo);
  });

  test(
      "should call the [OnBoardingRepo,cacheFirstTimer] and return the right data",
      () async {
    /// arrange
    when(
      () => repo.cacheFirstTimer(),
    ).thenAnswer(
      (_) async => Left(
        ServerFailure(message: "Unknown Error Occured", statusCode: 500),
      ),
    );

    /// act
    final result = await usecase.call();

    /// assert
    expect(
        result,
        equals(Left<Failure, dynamic>(
            ServerFailure(message: "Unknown Error Occured", statusCode: 500))));
    verify(
      () => repo.cacheFirstTimer(),
    ).called(1);
    verifyNoMoreInteractions(repo);
  });
}
