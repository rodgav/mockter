import 'package:mockter/data/request/add_response_request.dart';
import 'package:mockter/data/request/update_environment_request.dart';
import 'package:mockter/data/services/hive_service.dart';
import 'package:mockter/domain/model/mockter.dart';

abstract class LocalDataSource {
  Future<MockTer?> getMockTer();

  Future<List<Environment>> importEnvironments(String jsonString);

  Future<Environment> addEnvironment(Environment environment);

  Future<Environment?> updateEnvironment(
      UpdateEnvironmentRequest updateEnvironmentRequest);

  Future<bool> deleteEnvironment(String environmentId);

  Future<Path> addPath(String environmentId, Path path);

  Future<Path?> updatePath(String environmentId, Path path);

  Future<bool> deletePath(String environmentId, String pathId);

  Future<Response> addResponse(
      String environmentId, String pathId, Response response);

  Future<Response?> updateResponse(
      AddResponseRequest addResponseRequest);

  Future<bool> deleteResponse(
      String environmentId, String pathId, String responseId);
}

class LocalDataSourceImpl implements LocalDataSource {
  final HiveService _hiveService;

  LocalDataSourceImpl(this._hiveService);

  @override
  Future<MockTer?> getMockTer() => _hiveService.getMockTer();

  @override
  Future<List<Environment>> importEnvironments(String jsonString) =>
      _hiveService.importEnvironments(jsonString);

  @override
  Future<Environment> addEnvironment(Environment environment) =>
      _hiveService.addEnvironment(environment);

  @override
  Future<Environment?> updateEnvironment(
          UpdateEnvironmentRequest updateEnvironmentRequest) =>
      _hiveService.updateEnvironment(updateEnvironmentRequest);

  @override
  Future<bool> deleteEnvironment(String environmentId) =>
      _hiveService.deleteEnvironment(environmentId);

  @override
  Future<Path> addPath(String environmentId, Path path) =>
      _hiveService.addPath(environmentId, path);

  @override
  Future<Path?> updatePath(String environmentId, Path path) =>
      _hiveService.updatePath(environmentId, path);

  @override
  Future<bool> deletePath(String environmentId, String pathId) =>
      _hiveService.deletePath(environmentId, pathId);

  @override
  Future<Response> addResponse(
          String environmentId, String pathId, Response response) =>
      _hiveService.addResponse(environmentId, pathId, response);

  @override
  Future<Response?> updateResponse(
      AddResponseRequest addResponseRequest) =>
      _hiveService.updateResponse(addResponseRequest);

  @override
  Future<bool> deleteResponse(
          String environmentId, String pathId, String responseId) =>
      _hiveService.deleteResponse(environmentId, pathId, responseId);
}
