import 'package:dartz/dartz.dart';
import 'package:fivoza_learning/core/enums/update_user.dart';
import 'package:fivoza_learning/features/auth/domain/repositories/auth_repo.dart';
import 'package:fivoza_learning/features/auth/domain/usecases/update_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late UpdateUser usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = UpdateUser(repo);
    registerFallbackValue(UpdateUserAction.email);
  });
  test("should return [UpdateUser] from the [AuthRepo]", () async {
    /// arrange
    when(() => repo.updateUser(
            action: any(named: "action"),
            userData: any<dynamic>(named: "userData")))
        .thenAnswer((_) async => const Right(null));

    /// act
    final result = await usecase.call(const UpdateUserParams(
        action: UpdateUserAction.email, userData: "Test email"));

    /// assert
    expect(result, equals(const Right<dynamic, void>(null)));
    verify(() => repo.updateUser(
          action: UpdateUserAction.email,
          userData: 'Test email',
        )).called(1);
    verifyNoMoreInteractions(repo);
  });
}
