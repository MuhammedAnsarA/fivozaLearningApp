import 'package:dartz/dartz.dart';
import 'package:fivoza_learning/core/errors/exception.dart';
import 'package:fivoza_learning/core/errors/failures.dart';
import 'package:fivoza_learning/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:fivoza_learning/features/onboarding/data/repositories/onboarding_repo_impl.dart';
import 'package:fivoza_learning/features/onboarding/domain/repositories/onboarding_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingLocalDataSrc extends Mock
    implements OnBoardingLocalDataSource {}

void main() {
  late OnBoardingLocalDataSource localDataSource;
  late OnBoardingRepoImpl repoImpl;

  setUp(() {
    localDataSource = MockOnBoardingLocalDataSrc();
    repoImpl = OnBoardingRepoImpl(localDataSource);
  });

  test("should be a subclass of [OnboardingRepo]", () {
    expect(repoImpl, isA<OnBoardingRepo>());
  });
  group("cacheFirsttimer", () {
    test(
        "should complete successfully when call to local source is successfull",
        () async {
      /// arrange
      when(
        () => localDataSource.cacheFirstTimer(),
      ).thenAnswer((_) async => Future.value());

      /// act
      final result = await repoImpl.cacheFirstTimer();

      /// assert
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => localDataSource.cacheFirstTimer(),
      );
      verifyNoMoreInteractions(localDataSource);
    });

    test(
        "should return [CacheFailure] when call to local source is unsuccessfull",
        () async {
      /// arrange
      when(() => localDataSource.cacheFirstTimer()).thenThrow(
        const CacheException(message: "Insufficiant Storage"),
      );

      /// act
      final result = await repoImpl.cacheFirstTimer();

      /// assert
      expect(
        result,
        Left<CacheFailure, dynamic>(
          CacheFailure(message: "Insufficiant Storage", statusCode: 500),
        ),
      );
      verify(
        () => localDataSource.cacheFirstTimer(),
      );
      verifyNoMoreInteractions(localDataSource);
    });
  });

/* ---------------------------------- checkIfUserIsFirstTimer -------------------------------- */

  group("checkIfUserIsFirstTimer", () {
    test("should return true when user is first timer", () async {
      /// arrange
      when(
        () => localDataSource.checkIfUserIsFirstTimer(),
      ).thenAnswer((_) async => Future.value(true));

      /// act
      final result = await repoImpl.checkIfUserIsFirstTimer();

      /// assert
      expect(result, equals(const Right<dynamic, bool>(true)));
      verify(() => localDataSource.checkIfUserIsFirstTimer()).called(1);
      verifyNoMoreInteractions(localDataSource);
    });
    test("should return false when user is not first timer", () async {
      /// arrange
      when(
        () => localDataSource.checkIfUserIsFirstTimer(),
      ).thenAnswer((_) async => Future.value(false));

      /// act
      final result = await repoImpl.checkIfUserIsFirstTimer();

      /// assert
      expect(result, equals(const Right<dynamic, bool>(false)));
      verify(() => localDataSource.checkIfUserIsFirstTimer()).called(1);
      verifyNoMoreInteractions(localDataSource);
    });

    test(
        "should return [CacheFailure] when call to local source is unsuccessfull",
        () async {
      /// arrange
      when(() => localDataSource.checkIfUserIsFirstTimer()).thenThrow(
        const CacheException(
            message: "Insufficiant Permissions", statusCode: 403),
      );

      /// act
      final result = await repoImpl.checkIfUserIsFirstTimer();

      /// assert
      expect(
        result,
        Left<CacheFailure, dynamic>(
          CacheFailure(message: "Insufficiant Permissions", statusCode: 403),
        ),
      );
      verify(() => localDataSource.checkIfUserIsFirstTimer()).called(1);
      verifyNoMoreInteractions(localDataSource);
    });
  });
}
