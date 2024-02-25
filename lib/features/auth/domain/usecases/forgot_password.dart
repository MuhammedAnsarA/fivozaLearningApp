import 'package:fivoza_learning/core/usecases/usecases.dart';
import 'package:fivoza_learning/core/utils/typedef.dart';
import 'package:fivoza_learning/features/auth/domain/repositories/auth_repo.dart';

class ForgotPassword extends UsecaseWithParams<void, String> {
  final AuthRepo _repo;

  ForgotPassword(this._repo);
  @override
  ResultFuture<void> call(String params) => _repo.forgotPassword(params);
}
