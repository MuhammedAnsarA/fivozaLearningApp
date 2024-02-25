import 'package:dartz/dartz.dart';
import 'package:fivoza_learning/features/auth/domain/entities/user.dart';
import 'package:fivoza_learning/features/auth/domain/repositories/auth_repo.dart';
import 'package:fivoza_learning/features/auth/domain/usecases/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late SignIn usecase;

  const tEmail = "Test email";
  const tPassword = "Test password";

  const tUser = LocalUser.empty();

  setUp(() {
    repo = MockAuthRepo();
    usecase = SignIn(repo);
  });

  test("should return [LocalUser] from the [AuthRepo]", () async {
    /// arrange
    when(() => repo.signIn(
            email: any(named: "email"), password: any(named: "password")))
        .thenAnswer((_) async => const Right(tUser));

    /// act
    final result = await usecase
        .call(const SignInParams(email: tEmail, password: tPassword));

    /// assert
    expect(result, equals(const Right<dynamic, LocalUser>(tUser)));
    verify(() => repo.signIn(email: tEmail, password: tPassword)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
