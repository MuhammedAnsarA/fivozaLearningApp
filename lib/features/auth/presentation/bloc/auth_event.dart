part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInEvent({
    required this.email,
    required this.password,
  });

  @override
  List<String> get props => [email, password];
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const SignUpEvent({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<String> get props => [email, password, name];
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  const ForgotPasswordEvent(this.email);
  @override
  List<String> get props => [email];
}

class UpdateUserEvent extends AuthEvent {
  final UpdateUserAction action;
  final dynamic userData;

  UpdateUserEvent({
    required this.action,
    required this.userData,
  }) : assert(
          userData is String || userData is File,
          "[userData] must be either a String or a File,but was ${userData.runtimeType}",
        );

  @override
  List<Object?> get props => [action, userData];
}
