import 'package:dartz/dartz.dart';
import 'package:fivoza_learning/core/errors/exception.dart';
import 'package:fivoza_learning/core/errors/failures.dart';
import 'package:fivoza_learning/core/utils/typedef.dart';
import 'package:fivoza_learning/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:fivoza_learning/features/onboarding/domain/repositories/onboarding_repo.dart';

class OnBoardingRepoImpl implements OnBoardingRepo {
  final OnBoardingLocalDataSource _localDataSource;

  OnBoardingRepoImpl(this._localDataSource);
  @override
  ResultFuture<void> cacheFirstTimer() async {
    try {
      await _localDataSource.cacheFirstTimer();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<bool> checkIfUserIsFirstTimer() async {
    try {
      final result = await _localDataSource.checkIfUserIsFirstTimer();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
