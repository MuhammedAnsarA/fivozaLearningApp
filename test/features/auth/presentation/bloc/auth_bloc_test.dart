import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:fivoza_learning/core/errors/failures.dart';
import 'package:fivoza_learning/features/auth/data/models/user_model.dart';
import 'package:fivoza_learning/features/auth/domain/usecases/forgot_password.dart';
import 'package:fivoza_learning/features/auth/domain/usecases/sign_in.dart';
import 'package:fivoza_learning/features/auth/domain/usecases/sign_up.dart';
import 'package:fivoza_learning/features/auth/domain/usecases/update_user.dart';
import 'package:fivoza_learning/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignIn extends Mock implements SignIn {}

class MockSignUp extends Mock implements SignUp {}

class MockForgotPassword extends Mock implements ForgotPassword {}

class MockUpdateUser extends Mock implements UpdateUser {}

void main() {
  late SignIn signIn;
  late SignUp signUp;
  late ForgotPassword forgotPassword;
  late UpdateUser updateUser;
  late AuthBloc authBloc;

  const tSignUpParams = SignUpParams.empty();
  const tUpdateUserParams = UpdateUserParams.empty();
  const tSignInParams = SignInParams.empty();

  setUp(() {
    signIn = MockSignIn();
    signUp = MockSignUp();
    forgotPassword = MockForgotPassword();
    updateUser = MockUpdateUser();
    authBloc = AuthBloc(
      signIn: signIn,
      signUp: signUp,
      forgotPassword: forgotPassword,
      updateUser: updateUser,
    );
  });

  setUpAll(() {
    registerFallbackValue(tUpdateUserParams);
    registerFallbackValue(tSignUpParams);
    registerFallbackValue(tSignInParams);
  });

  tearDown(() => authBloc.close());

  final tServerFailure = ServerFailure(
      message: "user-not-found",
      statusCode:
          "There is no user record corresponding to this identifier the user may have been deleted");

  test("initialState should be [AuthInitial]", () async {
    /// arrange

    /// act

    /// assert
    expect(authBloc.state, AuthInitial());
  });

/* ------------------------------------- SignInEvent ---------------------------------------- */

  group("SignInEvent", () {
    const tUser = LocalUserModel.empty();
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading,SignedIn] when [SignInEvent] is added',
      build: () {
        when(() => signIn(any())).thenAnswer((_) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(SignInEvent(
          email: tSignInParams.email, password: tSignInParams.password)),
      expect: () => [AuthLoading(), const SignedIn(tUser)],
      verify: (_) {
        verify(() => signIn(SignInParams(
            email: tSignInParams.email,
            password: tSignInParams.password))).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading,AuthError] when signIn fails',
      build: () {
        when(() => signIn(any())).thenAnswer((_) async => Left(tServerFailure));

        return authBloc;
      },
      act: (bloc) => bloc.add(SignInEvent(
          email: tSignInParams.email, password: tSignInParams.password)),
      expect: () => [AuthLoading(), AuthError(tServerFailure.errorMessage)],
      verify: (_) {
        verify(() => signIn(SignInParams(
            email: tSignInParams.email,
            password: tSignInParams.password))).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );
  });

  /* ------------------------------------- SignUpEvent ---------------------------------------- */

  group("SignUpEvent", () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading,SignedUp] when [SignUpEvent] is added',
      build: () {
        when(() => signUp(any())).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpEvent(
          email: tSignUpParams.email,
          password: tSignUpParams.password,
          name: tSignUpParams.fullName)),
      expect: () => [AuthLoading(), const SignedUp()],
      verify: (_) {
        verify(() => signUp(SignUpParams(
            email: tSignUpParams.email,
            password: tSignUpParams.password,
            fullName: tSignUpParams.fullName))).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading,AuthError] when signUp fails',
      build: () {
        when(() => signUp(any())).thenAnswer((_) async => Left(tServerFailure));

        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpEvent(
          email: tSignUpParams.email,
          password: tSignUpParams.password,
          name: tSignUpParams.fullName)),
      expect: () => [AuthLoading(), AuthError(tServerFailure.errorMessage)],
      verify: (_) {
        verify(() => signUp(SignUpParams(
            email: tSignUpParams.email,
            password: tSignUpParams.password,
            fullName: tSignUpParams.fullName))).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );
  });

  /* ------------------------------------- ForgotPasswordEvent ---------------------------------------- */

  group("ForgotPasswordEvent", () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading,ForgotPasswordSent] when [ForgotPasswordEvent] is added',
      build: () {
        when(() => forgotPassword(any()))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(const ForgotPasswordEvent("email")),
      expect: () => [AuthLoading(), const ForgotPasswordSent()],
      verify: (_) {
        verify(() => forgotPassword('email')).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading,AuthError] when signUp fails',
      build: () {
        when(() => forgotPassword(any()))
            .thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(const ForgotPasswordEvent("email")),
      expect: () => [AuthLoading(), AuthError(tServerFailure.errorMessage)],
      verify: (_) {
        verify(() => forgotPassword('email')).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );
  });

  /* ------------------------------------- UpdateUserEvent ---------------------------------------- */

  group("UpdateUserEvent", () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading,UserUpdated] when [UpdateUserEvent] is added',
      build: () {
        when(() => updateUser(any()))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(UpdateUserEvent(
          action: tUpdateUserParams.action,
          userData: tUpdateUserParams.userData)),
      expect: () => [AuthLoading(), const UserUpdated()],
      verify: (_) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading,AuthError] when signUp fails',
      build: () {
        when(() => updateUser(any()))
            .thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(UpdateUserEvent(
          action: tUpdateUserParams.action,
          userData: tUpdateUserParams.userData)),
      expect: () => [AuthLoading(), AuthError(tServerFailure.errorMessage)],
      verify: (_) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );
  });
}
