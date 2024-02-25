import 'package:dartz/dartz.dart';
import 'package:fivoza_learning/core/enums/update_user.dart';
import 'package:fivoza_learning/core/errors/exception.dart';
import 'package:fivoza_learning/core/errors/failures.dart';
import 'package:fivoza_learning/core/utils/typedef.dart';
import 'package:fivoza_learning/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fivoza_learning/features/auth/domain/entities/user.dart';
import 'package:fivoza_learning/features/auth/domain/repositories/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepoImpl(this._remoteDataSource);
  @override
  ResultFuture<void> forgotPassword(String email) async {
    try {
      await _remoteDataSource.forgotPassword(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<LocalUser> signIn(
      {required String email, required String password}) async {
    try {
      final result =
          await _remoteDataSource.signIn(email: email, password: password);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> signUp(
      {required String email,
      required String fullName,
      required String password}) async {
    try {
      await _remoteDataSource.signUp(
          email: email, fullName: fullName, password: password);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> updateUser(
      {required UpdateUserAction action, required dynamic userData}) async {
    try {
      await _remoteDataSource.updateUser(action: action, userData: userData);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
