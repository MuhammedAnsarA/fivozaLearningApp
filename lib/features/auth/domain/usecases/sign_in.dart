import 'package:equatable/equatable.dart';
import 'package:fivoza_learning/core/usecases/usecases.dart';
import 'package:fivoza_learning/core/utils/typedef.dart';
import 'package:fivoza_learning/features/auth/domain/entities/user.dart';
import 'package:fivoza_learning/features/auth/domain/repositories/auth_repo.dart';

class SignIn extends UsecaseWithParams<LocalUser, SignInParams> {
  final AuthRepo _repo;

  SignIn(this._repo);

  @override
  ResultFuture<LocalUser> call(SignInParams params) =>
      _repo.signIn(email: params.email, password: params.password);
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({
    required this.email,
    required this.password,
  });

  const SignInParams.empty() : this(email: "", password: "");

  @override
  List<String> get props => [email, password];
}
