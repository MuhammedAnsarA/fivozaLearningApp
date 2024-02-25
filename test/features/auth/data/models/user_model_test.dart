import 'dart:convert';

import 'package:fivoza_learning/core/utils/typedef.dart';
import 'package:fivoza_learning/features/auth/data/models/user_model.dart';
import 'package:fivoza_learning/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tLocalUserModel = LocalUserModel.empty();
  test("should be subclass of [LocalUser] entity", () async {
    /// arrange

    /// act

    /// assert
    expect(tLocalUserModel, isA<LocalUser>());
  });

  final tMap = jsonDecode(fixture("user.json")) as DataMap;
  group("fromMap", () {
    test("should return a valid [LocalUserModel] from the map", () async {
      /// arrange

      /// act
      final result = LocalUserModel.fromMap(tMap);

      /// assert
      expect(result, equals(tLocalUserModel));
    });

    test("should throw an [error] when the map is invalid", () async {
      /// arrange
      final map = DataMap.from(tMap)..remove("uid");

      /// act
      const call = LocalUserModel.fromMap;

      /// assert
      expect(() => call(map), throwsA(isA<Error>()));
    });
  });

  group("toMap", () {
    test("should return a valid [DataMap] from the model", () async {
      /// arrange

      /// act
      final result = tLocalUserModel.toMap();

      /// assert
      expect(result, equals(tMap));
    });
  });

  group("copyWith", () {
    test("should return a valid [LocalUserModel] with updated values",
        () async {
      /// arrange

      /// act
      final result = tLocalUserModel.copyWith(uid: "2");

      /// assert
      expect(result.uid, "2");
    });
  });
}
