import 'package:equatable/equatable.dart';
import 'package:fivoza_learning/core/enums/update_user.dart';
import 'package:fivoza_learning/core/usecases/usecases.dart';
import 'package:fivoza_learning/core/utils/typedef.dart';
import 'package:fivoza_learning/features/auth/domain/repositories/auth_repo.dart';

class UpdateUser extends UsecaseWithParams<void, UpdateUserParams> {
  final AuthRepo _repo;

  UpdateUser(this._repo);

  @override
  ResultFuture<void> call(UpdateUserParams params) => _repo.updateUser(
        action: params.action,
        userData: params.userData,
      );
}

class UpdateUserParams extends Equatable {
  final UpdateUserAction action;
  final dynamic userData;

  const UpdateUserParams({
    required this.action,
    required this.userData,
  });

  const UpdateUserParams.empty()
      : this(action: UpdateUserAction.displayName, userData: "");

  @override
  List<dynamic> get props => [action, userData];
}
