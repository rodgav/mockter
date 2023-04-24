import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockter/data/mapper/swagger_mapper.dart';
import 'package:mockter/data/request/add_response_request.dart';
import 'package:mockter/data/request/update_environment_request.dart';
import 'package:mockter/domain/model/mockter.dart';

class HiveService {
  final Box<MockTer> _mockTerBox;

  HiveService(this._mockTerBox);

  Future<MockTer?> getMockTer() async {
    final mockTerAdapter = _mockTerBox.get('mockTerAdapter');
    if (mockTerAdapter != null) {
      final host = mockTerAdapter.host;
      final port = mockTerAdapter.port;
      final environments = mockTerAdapter.environments;
      return MockTer(host: host, port: port, environments: environments);
    }
    return null;
  }

  Future<List<Environment>> importEnvironments(String jsonString) async {
    final List<Environment> environments = swaggerMapper(jsonString);
    final mockTer = await getMockTer();
    if (mockTer != null) {
      mockTer.environments.addAll(environments);
      await _mockTerBox.clear();
      await _mockTerBox.put('mockTerAdapter', mockTer);
    } else {
      final newMockTer = MockTer(
          host: mockTer?.host ?? '127.0.0.1',
          port: mockTer?.port ?? 7001,
          environments: environments);
      await _mockTerBox.put('mockTerAdapter', newMockTer);
    }
    await _mockTerBox.flush();
    return environments;
  }

  Future<Environment> addEnvironment(Environment environment) async {
    final mockTer = await getMockTer();
    if (mockTer != null) {
      mockTer.environments.add(environment);
      await _mockTerBox.clear();
      await _mockTerBox.put('mockTerAdapter', mockTer);
    } else {
      final newMockTer = MockTer(
          host: mockTer!.host, port: mockTer.port, environments: [environment]);
      await _mockTerBox.put('mockTerAdapter', newMockTer);
    }
    await _mockTerBox.flush();
    return environment;
  }

  Future<Environment?> updateEnvironment(
      UpdateEnvironmentRequest updateEnvironmentRequest) async {
    final mockTer = await getMockTer();
    if (mockTer != null) {
      final environments = mockTer.environments;
      final indexEnvironment = environments.indexWhere(
          (element) => element.id == updateEnvironmentRequest.environment.id);
      final result =
          await deleteEnvironment(updateEnvironmentRequest.environment.id);
      if (result) {
        mockTer.host = updateEnvironmentRequest.host;
        mockTer.port = updateEnvironmentRequest.port;
        environments.insert(
            indexEnvironment != -1 ? indexEnvironment : environments.length,
            updateEnvironmentRequest.environment);
        await _mockTerBox.clear();
        await _mockTerBox.put('mockTerAdapter', mockTer);
        await _mockTerBox.flush();
        return updateEnvironmentRequest.environment;
      }
    }
    return null;
  }

  Future<bool> deleteEnvironment(String environmentId) async {
    final mockTer = await getMockTer();
    if (mockTer != null) {
      final environments = mockTer.environments;
      final index =
          environments.indexWhere((element) => element.id == environmentId);
      if (index != -1) {
        environments.removeAt(index);
        await _mockTerBox.clear();
        await _mockTerBox.put('mockTerAdapter', mockTer);
        await _mockTerBox.flush();
        return true;
      }
    }
    return false;
  }

  Future<Path> addPath(String environmentId, Path path) async {
    final mockTer = await getMockTer();
    if (mockTer != null) {
      final environments = mockTer.environments;
      final index =
          environments.indexWhere((element) => element.id == environmentId);
      if (index != -1) {
        final environment = environments.elementAt(index);
        environment.paths.add(path);
        await _mockTerBox.clear();
        await _mockTerBox.put('mockTerAdapter', mockTer);
        await _mockTerBox.flush();
      }
    }
    return path;
  }

  Future<Path?> updatePath(String environmentId, Path path) async {
    final mockTer = await getMockTer();
    if (mockTer != null) {
      final environments = mockTer.environments;
      final index =
          environments.indexWhere((element) => element.id == environmentId);
      if (index != -1) {
        final environment = environments.elementAt(index);
        final paths = environment.paths;
        final indexPath = paths.indexWhere((element) => element.id == path.id);
        final result = await deletePath(environmentId, path.id);
        if (result) {
          environment.paths
              .insert(indexPath != -1 ? indexPath : paths.length, path);
          await _mockTerBox.clear();
          await _mockTerBox.put('mockTerAdapter', mockTer);
          await _mockTerBox.flush();
        }
        return path;
      }
    }
    return null;
  }

  Future<bool> deletePath(String environmentId, String pathId) async {
    final mockTer = await getMockTer();
    if (mockTer != null) {
      final environments = mockTer.environments;
      final indexEnvironment =
          environments.indexWhere((element) => element.id == environmentId);
      if (indexEnvironment != -1) {
        final environment = environments.elementAt(indexEnvironment);
        final paths = environment.paths;
        final indexPath = paths.indexWhere((element) => element.id == pathId);
        if (indexPath != -1) {
          paths.removeAt(indexPath);
          await _mockTerBox.clear();
          await _mockTerBox.put('mockTerAdapter', mockTer);
          await _mockTerBox.flush();
          return true;
        }
      }
    }
    return false;
  }

  Future<Response> addResponse(
      String environmentId, String pathId, Response response) async {
    final mockTer = await getMockTer();
    if (mockTer != null) {
      final environments = mockTer.environments;
      final indexEnvironment =
          environments.indexWhere((element) => element.id == environmentId);
      if (indexEnvironment != -1) {
        final environment = environments.elementAt(indexEnvironment);
        final paths = environment.paths;
        final indexPath = paths.indexWhere((element) => element.id == pathId);
        if (indexPath != -1) {
          final path = paths.elementAt(indexPath);
          path.responses.add(response);
          await _mockTerBox.clear();
          await _mockTerBox.put('mockTerAdapter', mockTer);
          await _mockTerBox.flush();
        }
      }
    }
    return response;
  }

  Future<Response?> updateResponse(
      AddResponseRequest addResponseRequest) async {
    final mockTer = await getMockTer();
    final response = addResponseRequest.response;
    if (mockTer != null) {
      final environments = mockTer.environments;
      final indexEnvironment = environments.indexWhere(
          (element) => element.id == addResponseRequest.environmentId);
      if (indexEnvironment != -1) {
        final environment = environments.elementAt(indexEnvironment);
        final paths = environment.paths;
        final indexPath = paths
            .indexWhere((element) => element.id == addResponseRequest.pathId);
        if (indexPath != -1) {
          final path = paths.elementAt(indexPath);
          final responses = path.responses;
          if(response.active){
            for (var element in responses) {
              element.active = false;
              if (element.id == response.id) {
                element.active = true;
              }
            }
          }
          final indexResponse =
              responses.indexWhere((element) => element.id == response.id);
          final result = await deleteResponse(addResponseRequest.environmentId,
              addResponseRequest.pathId, response.id);
          if (result) {
            path.responses.insert(
                indexResponse != -1 ? indexResponse : responses.length,
                response);
            await _mockTerBox.clear();
            await _mockTerBox.put('mockTerAdapter', mockTer);
            await _mockTerBox.flush();
          }
        }
      }
      return response;
    }
    return null;
  }

  Future<bool> deleteResponse(
      String environmentId, String pathId, String responseId) async {
    final mockTer = await getMockTer();
    if (mockTer != null) {
      final environments = mockTer.environments;
      final indexEnvironment =
          environments.indexWhere((element) => element.id == environmentId);
      if (indexEnvironment != -1) {
        final environment = environments.elementAt(indexEnvironment);
        final paths = environment.paths;
        final indexPath = paths.indexWhere((element) => element.id == pathId);
        if (indexPath != -1) {
          final path = paths.elementAt(indexPath);
          final responses = path.responses;
          final indexResponse =
              responses.indexWhere((element) => element.id == responseId);
          if (indexResponse != -1) {
            responses.removeAt(indexResponse);
            await _mockTerBox.clear();
            await _mockTerBox.put('mockTerAdapter', mockTer);
            await _mockTerBox.flush();
          }
          return true;
        }
      }
    }
    return false;
  }
}
