import 'package:fivoza_learning/core/errors/exception.dart';
import 'package:fivoza_learning/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences prefs;
  late OnBoardingLocalDataSource localDataSource;

  setUp(() {
    prefs = MockSharedPreferences();
    localDataSource = OnBoardingLocalDataSourceImpl(prefs);
  });

  group("cacheFirstTimer", () {
    test("should call [SharedPreferences] to cache the data", () async {
      /// arrange
      when(() => prefs.setBool(any(), any())).thenAnswer((_) async => true);

      /// act
      await localDataSource.cacheFirstTimer();

      /// assert
      verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);
      verifyNoMoreInteractions(prefs);
    });

    test(
        "should throw a [CacheException] where there is an error caching the data",
        () async {
      /// arrange
      when(() => prefs.setBool(any(), any())).thenThrow(Exception());

      /// act
      final methodCall = localDataSource.cacheFirstTimer;

      /// assert
      expect(methodCall, throwsA(isA<CacheException>()));
      verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);
      verifyNoMoreInteractions(prefs);
    });
  });

/* ---------------------------------- checkIfUserIsFirstTimer -------------------------------- */

  group("checkIfUserIsFirstTimer", () {
    test(
        "should call [SharedPreferences] to check if user first timer and return the"
        " right response from storage data when exists", () async {
      /// arrange
      when(() => prefs.getBool(any())).thenReturn(false);

      /// act
      final result = await localDataSource.checkIfUserIsFirstTimer();

      /// assert
      expect(result, false);
      verify(() => prefs.getBool(kFirstTimerKey)).called(1);
      verifyNoMoreInteractions(prefs);
    });

    test("should return true if there is no data in storage", () async {
      /// arrange
      when(() => prefs.getBool(any())).thenReturn(null);

      /// act
      final result = await localDataSource.checkIfUserIsFirstTimer();

      /// assert
      expect(result, true);
      verify(() => prefs.getBool(kFirstTimerKey)).called(1);
      verifyNoMoreInteractions(prefs);
    });

    test(
        "should throw a [CacheException] where there is an error retriving the data",
        () async {
      /// arrange
      when(() => prefs.getBool(any())).thenThrow(Exception());

      /// act
      final call = localDataSource.checkIfUserIsFirstTimer;

      /// assert
      expect(call, throwsA(isA<CacheException>()));
      verify(() => prefs.getBool(kFirstTimerKey)).called(1);
      verifyNoMoreInteractions(prefs);
    });
  });
}
