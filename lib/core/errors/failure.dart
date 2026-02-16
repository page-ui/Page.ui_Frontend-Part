class Failure {
  final String message;

  Failure({required this.message});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message});

  factory ServerFailure.fromServer(int? statusCode) {
    if (statusCode == 401) {
      return ServerFailure(
        message: "Unauthorized access. Please check your credentials.",
      );
    }
    return ServerFailure(message: "there was an error please try again later");
  }
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message});
  factory NetworkFailure.error() {
    return NetworkFailure(
      message: "No internet connection. Please connect to a network.",
    );
  }
}
