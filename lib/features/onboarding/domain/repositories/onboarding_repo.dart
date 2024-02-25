import 'package:fivoza_learning/core/utils/typedef.dart';

abstract class OnBoardingRepo {
  ResultFuture<void> cacheFirstTimer();

  ResultFuture<bool> checkIfUserIsFirstTimer();
}
