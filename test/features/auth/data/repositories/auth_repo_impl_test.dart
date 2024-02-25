import 'package:dartz/dartz.dart';
import 'package:fivoza_learning/core/enums/update_user.dart';
import 'package:fivoza_learning/core/errors/exception.dart';
import 'package:fivoza_learning/core/errors/failures.dart';
import 'package:fivoza_learning/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fivoza_learning/features/auth/data/models/user_model.dart';
import 'package:fivoza_learning/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:fivoza_learning/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRemoteDataSource remoteDataSource;
  late AuthRepoImpl repoImpl;

  const tPassword = 'Test password';
  const tFullName = 'Test full name';
  const tEmail = 'Test email';
  const tUpdateAction = UpdateUserAction.password;
  const tUserData = 'New password';

  const tUser = LocalUserModel.empty();

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repoImpl = AuthRepoImpl(remoteDataSource);
    registerFallbackValue(UpdateUserAction.password);
  });

  /* ------------------------------ forgotPassword ----------------------------- */

  group("forgotPassword", () {
    test(
        "should call the [RemoteDataSource.forgotPassword]and complete"
        "successfullly when the call to the remote data source is successfull",
        () async {
      /// arrange
      when(() => remoteDataSource.forgotPassword(any()))
          .thenAnswer((_) async => const Right(null));

      /// act
      final result = await repoImpl.forgotPassword(tEmail);

      /// assert
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => remoteDataSource.forgotPassword(tEmail)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
      'should return [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(() => remoteDataSource.forgotPassword(any())).thenThrow(
          const ServerException(
            message: 'User does not exist',
            statusCode: '404',
          ),
        );

        final result = await repoImpl.forgotPassword(tEmail);

        expect(
          result,
          equals(
            Left<dynamic, void>(
              ServerFailure(
                message: 'User does not exist',
                statusCode: '404',
              ),
            ),
          ),
        );

        verify(() => remoteDataSource.forgotPassword(tEmail)).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  /* ------------------------------ signIn ----------------------------- */

  group("signIn", () {
    test(
        "should call the [RemoteDataSource.signIn]and complete"
        "successfullly when the call to the remote data source is successfull",
        () async {
      /// arrange
      when(() => remoteDataSource.signIn(
          email: any(named: "email"),
          password: any(named: "password"))).thenAnswer((_) async => tUser);

      /// act
      final result = await repoImpl.signIn(email: tEmail, password: tPassword);

      /// assert
      expect(result, equals(const Right<dynamic, LocalUser>(tUser)));
      verify(() => remoteDataSource.signIn(email: tEmail, password: tPassword))
          .called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        "should call the [ServerFailure] when the call to the remote"
        "source is unsuccessfull", () async {
      /// arrange
      when(() => remoteDataSource.signIn(
              email: any(named: "email"), password: any(named: "password")))
          .thenThrow(const ServerException(
              message: "User does not exist", statusCode: "404"));

      /// act
      final result = await repoImpl.signIn(email: tEmail, password: tPassword);

      /// assert
      expect(
          result,
          equals(Left<dynamic, void>(ServerFailure(
            message: "User does not exist",
            statusCode: "404",
          ))));
      verify(() => remoteDataSource.signIn(email: tEmail, password: tPassword))
          .called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  /* ------------------------------ signUp ----------------------------- */

  group("signUp", () {
    test(
        "should call the [RemoteDataSource.signUp]and complete"
        "successfullly when the call to the remote data source is successfull",
        () async {
      /// arrange
      when(() => remoteDataSource.signUp(
              email: any(named: "email"),
              password: any(named: "password"),
              fullName: any(named: "fullName")))
          .thenAnswer((_) async => Future.value());

      /// act
      final result = await repoImpl.signUp(
          email: tEmail, password: tPassword, fullName: tFullName);

      /// assert
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => remoteDataSource.signUp(
          email: tEmail, password: tPassword, fullName: tFullName)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        "should call the [ServerFailure] when the call to the remote"
        "source is unsuccessfull", () async {
      /// arrange
      when(() => remoteDataSource.signUp(
              email: any(named: "email"),
              password: any(named: "password"),
              fullName: any(named: "fullName")))
          .thenThrow(const ServerException(
              message: "User does not exist", statusCode: "404"));

      /// act
      final result = await repoImpl.signUp(
          email: tEmail, password: tPassword, fullName: tFullName);

      /// assert
      expect(
          result,
          equals(Left<dynamic, void>(ServerFailure(
            message: "User does not exist",
            statusCode: "404",
          ))));
      verify(() => remoteDataSource.signUp(
          email: tEmail, password: tPassword, fullName: tFullName)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  /* ------------------------------ updateUser ----------------------------- */

  group("updateUser", () {
    test(
        "should call the [RemoteDataSource.updateUser]and complete"
        "successfullly when the call to the remote data source is successfull",
        () async {
      /// arrange
      when(() => remoteDataSource.updateUser(
              action: any(named: "action"),
              userData: any<dynamic>(named: "userData")))
          .thenAnswer((_) async => const Right(null));

      /// act
      final result =
          await repoImpl.updateUser(action: tUpdateAction, userData: tUserData);

      /// assert
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => remoteDataSource.updateUser(
          action: tUpdateAction, userData: tUserData)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        "should call the [ServerFailure] when the call to the remote"
        "source is unsuccessfull", () async {
      /// arrange
      when(() => remoteDataSource.updateUser(
              action: any(named: "action"), userData: any(named: "userData")))
          .thenThrow(const ServerException(
              message: "User does not exist", statusCode: "404"));

      /// act
      final result =
          await repoImpl.updateUser(action: tUpdateAction, userData: tUserData);

      /// assert
      expect(
          result,
          equals(Left<dynamic, void>(ServerFailure(
            message: "User does not exist",
            statusCode: "404",
          ))));
      verify(() => remoteDataSource.updateUser(
          action: tUpdateAction, userData: tUserData)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
