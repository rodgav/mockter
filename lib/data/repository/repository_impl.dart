import 'package:dartz/dartz.dart';
import 'package:mockter/data/data_source/local_datasource.dart';
import 'package:mockter/data/local/failure.dart';
import 'package:mockter/data/request/add_response_request.dart';
import 'package:mockter/data/request/update_environment_request.dart';
import 'package:mockter/domain/model/mockter.dart';
import 'package:mockter/domain/repository/repository.dart';

class RepositoryImpl implements Repository {
  final LocalDataSource _localDataSource;

  RepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, MockTer>> getMockTer() async {
    try {
      final mocker = await _localDataSource.getMockTer();
      if (mocker != null) {
        return Right(mocker);
      }
      return Left(Failure(0, 'MockTer is empty'));
    } catch (e) {
      return Left(Failure(0, 'MockTer error $e'));
    }
  }

  @override
  Future<Either<Failure, List<Environment>>> importEnvironments(
      String jsonString) async {
    try {
      final newEnvironments =
          await _localDataSource.importEnvironments(jsonString);
      return Right(newEnvironments);
    } catch (e) {
      return Left(Failure(0, 'MockTer error $e'));
    }
  }

  @override
  Future<Either<Failure, Environment>> addEnvironment(
      Environment environment) async {
    try {
      final newEnvironment = await _localDataSource.addEnvironment(environment);
      return Right(newEnvironment);
    } catch (e) {
      return Left(Failure(0, 'MockTer error $e'));
    }
  }

  @override
  Future<Either<Failure, Environment?>> updateEnvironment(
      UpdateEnvironmentRequest updateEnvironmentRequest) async {
    try {
      final newEnvironment =
          await _localDataSource.updateEnvironment(updateEnvironmentRequest);
      return Right(newEnvironment);
    } catch (e) {
      return Left(Failure(0, 'MockTer error $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteEnvironment(String environmentId) async {
    try {
      final newEnvironmentId =
          await _localDataSource.deleteEnvironment(environmentId);
      if (newEnvironmentId) {
        return Right(newEnvironmentId);
      }
      return Left(Failure(0, 'MockTer not delete'));
    } catch (e) {
      return Left(Failure(0, 'MockTer error $e'));
    }
  }

  @override
  Future<Either<Failure, Path>> addPath(String environmentId, Path path) async {
    try {
      final newPath = await _localDataSource.addPath(environmentId, path);
      return Right(newPath);
    } catch (e) {
      return Left(Failure(0, 'MockTer error $e'));
    }
  }

  @override
  Future<Either<Failure, Path?>> updatePath(
      String environmentId, Path path) async {
    try {
      final newPath = await _localDataSource.updatePath(environmentId, path);
      return Right(newPath);
    } catch (e) {
      return Left(Failure(0, 'MockTer error $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> deletePath(
      String environmentId, String pathId) async {
    try {
      final newPathId =
          await _localDataSource.deletePath(environmentId, pathId);
      if (newPathId) {
        return Right(newPathId);
      }
      return Left(Failure(0, 'MockTer not delete'));
    } catch (e) {
      return Left(Failure(0, 'MockTer error $e'));
    }
  }

  @override
  Future<Either<Failure, Response>> addResponse(
      String environmentId, String pathId, Response response) async {
    try {
      final newResponse =
          await _localDataSource.addResponse(environmentId, pathId, response);
      return Right(newResponse);
    } catch (e) {
      return Left(Failure(0, 'MockTer error $e'));
    }
  }

  @override
  Future<Either<Failure, Response?>> updateResponse(AddResponseRequest addResponseRequest) async {
    try {
      final newResponse = await _localDataSource.updateResponse(addResponseRequest);
      return Right(newResponse);
    } catch (e) {
      return Left(Failure(0, 'MockTer error $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteResponse(
      String environmentId, String pathId, String responseId) async {
    try {
      final newResponseId = await _localDataSource.deleteResponse(
          environmentId, pathId, responseId);
      if (newResponseId) {
        return Right(newResponseId);
      }
      return Left(Failure(0, 'MockTer not delete'));
    } catch (e) {
      return Left(Failure(0, 'MockTer error $e'));
    }
  }
}
