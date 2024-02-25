import 'package:equatable/equatable.dart';
import 'package:fivoza_learning/core/usecases/usecases.dart';
import 'package:fivoza_learning/core/utils/typedef.dart';
import 'package:fivoza_learning/features/auth/domain/repositories/auth_repo.dart';

class SignUp extends UsecaseWithParams<void, SignUpParams> {
  final AuthRepo _repo;

  SignUp(this._repo);

  @override
  ResultFuture<void> call(SignUpParams params) => _repo.signUp(
        email: params.email,
        fullName: params.fullName,
        password: params.password,
      );
}

class SignUpParams extends Equatable {
  final String email;
  final String password;
  final String fullName;

  const SignUpParams({
    required this.email,
    required this.password,
    required this.fullName,
  });

  const SignUpParams.empty() : this(email: "", fullName: "", password: "");

  @override
  List<String> get props => [email, password, fullName];
}
