// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fivoza_learning/core/enums/update_user.dart';
import 'package:fivoza_learning/features/auth/domain/entities/user.dart';
import 'package:fivoza_learning/features/auth/domain/usecases/forgot_password.dart';
import 'package:fivoza_learning/features/auth/domain/usecases/sign_in.dart';
import 'package:fivoza_learning/features/auth/domain/usecases/sign_up.dart';
import 'package:fivoza_learning/features/auth/domain/usecases/update_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn _signIn;
  final SignUp _signUp;
  final ForgotPassword _forgotPassword;
  final UpdateUser _updateUser;
  AuthBloc({
    required SignIn signIn,
    required SignUp signUp,
    required ForgotPassword forgotPassword,
    required UpdateUser updateUser,
  })  : _signIn = signIn,
        _signUp = signUp,
        _forgotPassword = forgotPassword,
        _updateUser = updateUser,
        super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(AuthLoading());
    });

    on<SignInEvent>(_signInHandler);
    on<SignUpEvent>(_signUpHandler);
    on<ForgotPasswordEvent>(_forgotPasswordHandler);
    on<UpdateUserEvent>(_updateUserHandler);
  }

  Future<void> _signInHandler(
      SignInEvent event, Emitter<AuthState> emit) async {
    final result = await _signIn(
        SignInParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (user) => emit(SignedIn(user)),
    );
  }

  Future<void> _signUpHandler(
      SignUpEvent event, Emitter<AuthState> emit) async {
    final result = await _signUp.call(SignUpParams(
      email: event.email,
      password: event.password,
      fullName: event.name,
    ));

    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(const SignedUp()),
    );
  }

  Future<void> _forgotPasswordHandler(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    final result = await _forgotPassword.call(event.email);

    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(const ForgotPasswordSent()),
    );
  }

  Future<void> _updateUserHandler(
      UpdateUserEvent event, Emitter<AuthState> emit) async {
    final result = await _updateUser
        .call(UpdateUserParams(action: event.action, userData: event.userData));

    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(const UserUpdated()),
    );
  }
}
