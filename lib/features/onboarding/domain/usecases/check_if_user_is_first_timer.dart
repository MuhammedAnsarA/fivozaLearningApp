import 'package:fivoza_learning/core/usecases/usecases.dart';
import 'package:fivoza_learning/core/utils/typedef.dart';
import 'package:fivoza_learning/features/onboarding/domain/repositories/onboarding_repo.dart';

class CheckIfUserIsFirstTimer extends UsecaseWithoutParams<bool> {
  final OnBoardingRepo _repo;

  CheckIfUserIsFirstTimer(this._repo);

  @override
  ResultFuture<bool> call() => _repo.checkIfUserIsFirstTimer();
}
