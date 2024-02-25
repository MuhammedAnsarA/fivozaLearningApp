import 'package:equatable/equatable.dart';
import 'package:fivoza_learning/core/errors/exception.dart';

abstract class Failure extends Equatable {
  final String message;
  final dynamic statusCode;

  String get errorMessage =>
      "$statusCode${statusCode is String ? "" : " Error"}: $message";

  Failure({
    required this.message,
    required this.statusCode,
  }) : assert(statusCode is String || statusCode is int,
            "StatusCode cannot be a ${statusCode.runtimeType}");
  @override
  List<Object?> get props => [message, statusCode];
}

class CacheFailure extends Failure {
  CacheFailure({
    required super.message,
    required super.statusCode,
  });
}

class ServerFailure extends Failure {
  ServerFailure({
    required super.message,
    required super.statusCode,
  });

  ServerFailure.fromException(ServerException exception)
      : this(message: exception.message, statusCode: exception.statusCode);
}
