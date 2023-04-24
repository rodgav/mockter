import 'package:dartz/dartz.dart';
import 'package:mockter/data/local/failure.dart';
import 'package:mockter/data/request/add_response_request.dart';
import 'package:mockter/data/request/update_environment_request.dart';
import 'package:mockter/domain/model/mockter.dart';

abstract class Repository {
  Future<Either<Failure, MockTer>> getMockTer();

  Future<Either<Failure, List<Environment>>> importEnvironments(
      String jsonString);

  Future<Either<Failure, Environment>> addEnvironment(Environment environment);

  Future<Either<Failure, Environment?>> updateEnvironment(
      UpdateEnvironmentRequest updateEnvironmentRequest);

  Future<Either<Failure, bool>> deleteEnvironment(String environmentId);

  Future<Either<Failure, Path>> addPath(String environmentId, Path path);

  Future<Either<Failure, Path?>> updatePath(String environmentId, Path path);

  Future<Either<Failure, bool>> deletePath(String environmentId, String pathId);

  Future<Either<Failure, Response>> addResponse(
      String environmentId, String pathId, Response response);

  Future<Either<Failure, Response?>> updateResponse(AddResponseRequest addResponseRequest);

  Future<Either<Failure, bool>> deleteResponse(
      String environmentId, String pathId, String responseId);
}
