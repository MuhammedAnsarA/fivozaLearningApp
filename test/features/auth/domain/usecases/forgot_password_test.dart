import 'package:dartz/dartz.dart';
import 'package:fivoza_learning/features/auth/domain/repositories/auth_repo.dart';
import 'package:fivoza_learning/features/auth/domain/usecases/forgot_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late ForgotPassword usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = ForgotPassword(repo);
  });
  const tEmail = "Test email";

  test("should call the [AuthRepo.forgotPassword]", () async {
    /// arrange
    when(() => repo.forgotPassword(any()))
        .thenAnswer((_) async => const Right(null));

    /// act
    final result = await usecase.call(tEmail);

    /// assert
    expect(result, equals(const Right<dynamic, void>(null)));
    verify(() => repo.forgotPassword(tEmail)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
