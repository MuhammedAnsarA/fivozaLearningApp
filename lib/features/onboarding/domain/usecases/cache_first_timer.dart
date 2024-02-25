import 'package:fivoza_learning/core/usecases/usecases.dart';
import 'package:fivoza_learning/core/utils/typedef.dart';
import 'package:fivoza_learning/features/onboarding/domain/repositories/onboarding_repo.dart';

class CacheFirstTimer extends UsecaseWithoutParams<void> {
  final OnBoardingRepo _repo;

  CacheFirstTimer(this._repo);

  @override
  ResultFuture<void> call() async => _repo.cacheFirstTimer();
}
