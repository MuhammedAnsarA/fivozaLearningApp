import 'package:dartz/dartz.dart';
import 'package:fivoza_learning/features/auth/domain/repositories/auth_repo.dart';
import 'package:fivoza_learning/features/auth/domain/usecases/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late SignUp usecase;

  const tEmail = "Test email";
  const tFullName = "Test fullName";
  const tPassword = "Test password";

  setUp(() {
    repo = MockAuthRepo();
    usecase = SignUp(repo);
  });
  test("should return [SignUp] from the [AuthRepo]", () async {
    /// arrange
    when(() => repo.signUp(
        email: any(named: "email"),
        fullName: any(named: "fullName"),
        password: any(named: "password"))).thenAnswer(
      (_) async => const Right(null),
    );

    /// act
    final result = await usecase.call(const SignUpParams(
        email: tEmail, password: tPassword, fullName: tFullName));

    /// assert
    expect(result, equals(const Right<dynamic, void>(null)));
    verify(() => repo.signUp(
        email: tEmail, fullName: tFullName, password: tPassword)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
