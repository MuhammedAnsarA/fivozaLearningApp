import 'package:dartz/dartz.dart';
import 'package:fivoza_learning/features/onboarding/domain/repositories/onboarding_repo.dart';
import 'package:fivoza_learning/features/onboarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo.mock.dart';

void main() {
  late OnBoardingRepo repo;
  late CheckIfUserIsFirstTimer usecase;

  setUp(() {
    repo = MockOnboardingRepo();
    usecase = CheckIfUserIsFirstTimer(repo);
  });

  test("should get a response from the [OnboardingRepo]", () async {
    /// arrange
    when(
      () => repo.checkIfUserIsFirstTimer(),
    ).thenAnswer((invocation) async => const Right(true));

    /// act
    final result = await usecase.call();

    /// assert
    expect(result, equals(const Right<dynamic, bool>(true)));
    verify(
      () => repo.checkIfUserIsFirstTimer(),
    );
    verifyNoMoreInteractions(repo);
  });
}
