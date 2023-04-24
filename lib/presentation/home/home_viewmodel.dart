import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:mockter/application/extensions/methods_extension.dart';
import 'package:mockter/data/request/add_path_request.dart';
import 'package:mockter/data/request/add_response_request.dart';
import 'package:mockter/data/request/delete_path_request.dart';
import 'package:mockter/data/request/delete_response_request.dart';
import 'package:mockter/data/request/update_environment_request.dart';
import 'package:mockter/domain/model/mockter.dart';
import 'package:mockter/domain/usecase/add_environment_usecase.dart';
import 'package:mockter/domain/usecase/add_path_usecase.dart';
import 'package:mockter/domain/usecase/add_response_usecase.dart';
import 'package:mockter/domain/usecase/delete_path_usecase.dart';
import 'package:mockter/domain/usecase/delete_response_usecase.dart';
import 'package:mockter/domain/usecase/import_environments_usecase.dart';
import 'package:mockter/domain/usecase/delete_enviroment_usecase.dart';
import 'package:mockter/domain/usecase/get_mockter_usecase.dart';
import 'package:mockter/domain/usecase/update_environment_usecase.dart';
import 'package:mockter/domain/usecase/update_path_usecase.dart';
import 'package:mockter/domain/usecase/update_response_usecase.dart';
import 'package:mockter/presentation/base/base_viewmodel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:uuid/uuid.dart';
import 'package:shelf_router/shelf_router.dart' as sr;
import 'package:shelf/shelf_io.dart' as sio;

class HomeViewModel extends BaseViewModel
    with HomeViewModelInput, HomeViewModelOutput {
  final GetMockTerUseCase _getMockTerUseCase;
  final ImportEnvironmentsUseCase _importEnvironmentsUseCase;
  final AddEnvironmentUseCase _addEnvironmentUseCase;
  final AddPathUseCase _addPathUseCase;
  final AddResponseUseCase _addResponseUseCase;
  final DeleteEnvironmentUseCase _deleteEnvironmentUseCase;
  final DeletePathUseCase _deletePathUseCase;
  final DeleteResponseUseCase _deleteResponseUseCase;
  final UpdateEnvironmentUseCase _updateEnvironmentUseCase;
  final UpdatePathUseCase _updatePathUseCase;
  final UpdateResponseUseCase _updateResponseUseCase;

  HomeViewModel(
      this._getMockTerUseCase,
      this._importEnvironmentsUseCase,
      this._addEnvironmentUseCase,
      this._addPathUseCase,
      this._addResponseUseCase,
      this._deleteEnvironmentUseCase,
      this._deletePathUseCase,
      this._deleteResponseUseCase,
      this._updateEnvironmentUseCase,
      this._updatePathUseCase,
      this._updateResponseUseCase);

  BehaviorSubject<MockTer?> _mockTerStreCtrl =
      BehaviorSubject<MockTer?>.seeded(null);
  BehaviorSubject<MockTerData?> _mockTerDataStreCtrl =
      BehaviorSubject<MockTerData?>.seeded(null);
  BehaviorSubject<Server?> _serverRunningStreCtrl =
      BehaviorSubject<Server?>.seeded(null);
  BehaviorSubject<List<String>> _logsStreCtrl =
      BehaviorSubject<List<String>>.seeded(List<String>.empty(growable: true));

  final uuid = const Uuid();
  HttpServer? _server;

  @override
  start() {
    if (_mockTerStreCtrl.isClosed) {
      _mockTerStreCtrl = BehaviorSubject<MockTer?>();
    }
    if (_mockTerDataStreCtrl.isClosed) {
      _mockTerDataStreCtrl = BehaviorSubject<MockTerData?>();
    }
    if (_serverRunningStreCtrl.isClosed) {
      _serverRunningStreCtrl = BehaviorSubject<Server?>.seeded(null);
    }
    if (_logsStreCtrl.isClosed) {
      _logsStreCtrl = BehaviorSubject<List<String>>.seeded(
          List<String>.empty(growable: true));
    }
    getMockTer(ActionsMockTerData.firstCall);
    super.start();
  }

  @override
  finish() {
    _mockTerStreCtrl.close();
    _mockTerDataStreCtrl.close();
    _server?.close();
    _logsStreCtrl.close();
    super.finish();
  }

  @override
  Sink<MockTer?> get mockTerInput => _mockTerStreCtrl.sink;

  @override
  Sink<MockTerData?> get mockTerDataInput => _mockTerDataStreCtrl.sink;

  @override
  Sink<Server?> get serverRunningInput => _serverRunningStreCtrl.sink;

  @override
  Sink<List<String>> get logsInput => _logsStreCtrl.sink;

  @override
  Stream<MockTer?> get mockTerOutput =>
      _mockTerStreCtrl.stream.map((mockTer) => mockTer);

  @override
  Stream<MockTerData?> get mockTerDataOutput =>
      _mockTerDataStreCtrl.stream.map((mockTerData) => mockTerData);

  @override
  Stream<Server?> get serverRunningOutput =>
      _serverRunningStreCtrl.stream.map((serverRunning) => serverRunning);

  @override
  Stream<List<String>> get logsOutput =>
      _logsStreCtrl.stream.map((logs) => logs);

  Future<void> startServer(Server server) async {
    final router = sr.Router();
    router.all(
        '/<ignored|.*>',
        (shelf.Request request) =>
            _handleRequest(request, server.environmentId));
    _server = await sio.serve(router, server.host, server.port);
    serverRunningInput.add(server);
  }

  Future<void> stopServer() async {
    await _server?.close(force: true);
    serverRunningInput.add(null);
  }

  @override
  getMockTer(ActionsMockTerData actionsMockTerData,
      {Environment? environment, Path? path, Response? response}) async {
    (await _getMockTerUseCase.execute(null))
        .fold((l) => print('l ${l.code} ${l.message}'), (r) {
      mockTerInput.add(r);
      final environments = r.environments;
      final firstEnvironment =
          environments.isNotEmpty ? environments.first : null;
      setMockTerData(actionsMockTerData,
          mockTer: r,
          environment: actionsMockTerData == ActionsMockTerData.firstCall
              ? firstEnvironment
              : environment,
          path: path,
          response: response);
    });
  }

  @override
  selectFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        (await _importEnvironmentsUseCase.execute(jsonString)).fold(
            (l) => print('l ${l.code} ${l.message}'),
            (r) => getMockTer(ActionsMockTerData.firstCall));
      }
    } catch (e) {
      print('Error selecting file: $e');
    }
  }

  @override
  setMockTerData(ActionsMockTerData updateMockTerData,
      {MockTer? mockTer,
      Environment? environment,
      Path? path,
      Response? response}) async {
    MockTerData? mockTerData;
    switch (updateMockTerData) {
      case ActionsMockTerData.firstCall:
        final newPath = _getNewPath(environment?.paths, true);
        final newResponse = _getNewResponse(newPath?.responses, true);
        mockTerData = MockTerData(environment, newPath, newResponse);
        break;
      case ActionsMockTerData.addEnvironment:
        final environments = mockTer?.environments;
        final environment =
            (environments?.isNotEmpty ?? false) ? environments?.last : null;
        final newPath = _getNewPath(environment?.paths, true);
        final newResponse = _getNewResponse(newPath?.responses, true);
        mockTerData = MockTerData(environment, newPath, newResponse);
        break;
      case ActionsMockTerData.addPath:
        final newPath = _getNewPath(environment?.paths, false);
        final newResponse = _getNewResponse(newPath?.responses, true);
        mockTerData = MockTerData(environment, newPath, newResponse);
        break;
      case ActionsMockTerData.addResponse:
        final newResponse = _getNewResponse(path?.responses, false);
        mockTerData = MockTerData(environment, path, newResponse);
        break;
      case ActionsMockTerData.updateEnvironment:
      case ActionsMockTerData.updatePath:
      case ActionsMockTerData.updateResponse:
        mockTerData = MockTerData(environment, path, response);
        break;
      case ActionsMockTerData.deleteEnvironment:
        final environments = mockTer?.environments;
        if (environments != null) {
          final newEnvironment =
              environments.isNotEmpty ? environments.first : null;
          final newPath = _getNewPath(newEnvironment?.paths, false);
          final newResponse = _getNewResponse(newPath?.responses, true);
          mockTerData = MockTerData(newEnvironment, newPath, newResponse);
        } else {
          mockTerData = MockTerData(null, null, null);
        }
        break;
      case ActionsMockTerData.deletePath:
        final paths = environment?.paths;
        if (paths != null) {
          final newPath = paths.isNotEmpty ? paths.first : null;
          final newResponse = _getNewResponse(newPath?.responses, true);
          mockTerData = MockTerData(environment, newPath, newResponse);
        } else {
          mockTerData = MockTerData(environment, null, null);
        }
        break;
      case ActionsMockTerData.deleteResponse:
        final responses = path?.responses;
        if (responses != null) {
          final newResponse = responses.isNotEmpty ? responses.first : null;
          mockTerData = MockTerData(environment, path, newResponse);
        } else {
          mockTerData = MockTerData(environment, null, null);
        }
        break;
      case ActionsMockTerData.selectMockTer:
        mockTerData = MockTerData(environment, path, response);
        break;
    }
    mockTerDataInput.add(mockTerData);
  }

  addEnvironment() async {
    final newEnvironment = _createNewEnvironment();
    final newPath = _createNewPath();
    final newResponse = _createNewResponse();
    newPath.responses.add(newResponse);
    newEnvironment.paths.add(newPath);

    (await _addEnvironmentUseCase.execute(newEnvironment)).fold(
        (l) => print('l ${l.code} ${l.message}'),
        (r) => getMockTer(ActionsMockTerData.addEnvironment, environment: r));
  }

  addPath(Environment environment) async {
    final newPath = _createNewPath();
    final newResponse = _createNewResponse();
    newPath.responses.add(newResponse);
    (await _addPathUseCase.execute(
            AddPathRequest(environmentId: environment.id, path: newPath)))
        .fold(
            (l) => print('l ${l.code} ${l.message}'),
            (r) => getMockTer(ActionsMockTerData.addPath,
                environment: environment, path: r));
  }

  addResponse(Environment environment, Path path) async {
    final newResponse = _createNewResponse();
    (await _addResponseUseCase.execute(AddResponseRequest(
            environmentId: environment.id,
            pathId: path.id,
            response: newResponse)))
        .fold(
            (l) => print('l ${l.code} ${l.message}'),
            (r) => getMockTer(ActionsMockTerData.addResponse,
                environment: environment, path: path, response: r));
  }

  deleteEnvironment(Environment environment) async {
    (await _deleteEnvironmentUseCase.execute(environment.id)).fold(
        (l) => print('l ${l.code} ${l.message}'),
        (r) => getMockTer(ActionsMockTerData.deleteEnvironment,
            environment: environment));
  }

  deletePath(Environment environment, Path path) async {
    (await _deletePathUseCase.execute(
            DeletePathRequest(environmentId: environment.id, pathId: path.id)))
        .fold(
            (l) => print('l ${l.code} ${l.message}'),
            (r) => getMockTer(ActionsMockTerData.deletePath,
                environment: environment, path: path));
  }

  deleteResponse(Environment environment, Path path, Response response) async {
    (await _deleteResponseUseCase.execute(DeleteResponseRequest(
            environmentId: environment.id,
            pathId: path.id,
            responseId: response.id)))
        .fold(
            (l) => print('l ${l.code} ${l.message}'),
            (r) => getMockTer(ActionsMockTerData.deleteResponse,
                environment: environment, path: path, response: response));
  }

  updateEnvironment(String host, int port, Environment environment, Path path,
      Response response) async {
    (await _updateEnvironmentUseCase
            .execute(UpdateEnvironmentRequest(host, port, environment)))
        .fold(
            (l) => print('l ${l.code} ${l.message}'),
            (r) => getMockTer(ActionsMockTerData.updateEnvironment,
                environment: environment, path: path, response: response));
  }

  updatePath(Environment environment, Path path, Response response) async {
    (await _updatePathUseCase
            .execute(AddPathRequest(environmentId: environment.id, path: path)))
        .fold(
            (l) => print('l ${l.code} ${l.message}'),
            (r) => getMockTer(ActionsMockTerData.updatePath,
                environment: environment, path: path, response: response));
  }

  updateResponse(Environment environment, Path path, Response response) async {
    (await _updateResponseUseCase.execute(AddResponseRequest(
            environmentId: environment.id,
            pathId: path.id,
            response: response)))
        .fold(
            (l) => print('l ${l.code} ${l.message}'),
            (r) => getMockTer(ActionsMockTerData.updateResponse,
                environment: environment, path: path, response: response));
  }

  Future<shelf.Response> _handleRequest(
      shelf.Request request, String environmentId) async {
    final List<String> logs = (await logsOutput.isEmpty?List<String>.empty(growable: true):await logsOutput.first);
    final method = request.method;
    final url = request.requestedUri;
    final queryParams = request.url.queryParameters;
    final headers = request.headers;
    final path = request.url.path;

    // Lee el cuerpo de la solicitud si existe
    String body = '';
    if ((request.contentLength ?? 0) > 0) {
      body = await request.readAsString();
    }

    logs.add('--------------------REQUEST--------------------');
    logs.add('Method: $method');
    logs.add('URL: $url');
    logs.add('Query Params: $queryParams');
    logs.add('Headers: $headers');
    logs.add('Body: $body');
    logs.add('path: $path');
    logs.add('--------------------RESPONSE--------------------');
    final environment = await _getEnvironmentForRequest(environmentId);

    if (environment != null) {
      final paths = environment.paths;
      final indexPath = paths.indexWhere((element) =>
          element.method.getName() == method.toUpperCase() &&
          element.path == '/$path');
      if (indexPath != -1) {
        final path = paths.elementAt(indexPath);
        final response = path.responses.firstWhere((element) => element.active);
        logs.add('statusCode: ${response.responseCode}');
        logs.add('response: ${response.response}');
        logsInput.add(logs);
        return shelf.Response(response.responseCode,
            body: response.response,
            headers: {'Content-Type': 'application/json'});
      }
    }
    final responseBody = json.encode({
      'message': 'Not Found',
    });
    logs.add('statusCode: 404');
    logs.add('response: $responseBody');
    logsInput.add(logs);
    return shelf.Response(404,
        body: responseBody, headers: {'Content-Type': 'application/json'});
  }

  Future<Environment?> _getEnvironmentForRequest(String environmentId) async {
    if (!await mockTerOutput.isEmpty) {
      final mockTer = await mockTerOutput.first;
      final environments = mockTer?.environments;
      if (environments != null) {
        final indexEnvironment =
            environments.indexWhere((element) => element.id == environmentId);
        if (indexEnvironment != -1) {
          return environments.elementAt(indexEnvironment);
        }
      }
    }
    return null;
  }

  Environment _createNewEnvironment() {
    return Environment(
        id: uuid.v1(),
        title: 'new environment',
        description: 'new environment',
        basePath: '/v1',
        paths: List<Path>.empty(growable: true));
  }

  Path _createNewPath() {
    return Path(
        id: uuid.v1(),
        path: '/path',
        method: Methods.get,
        summary: 'Summary path',
        responses: List<Response>.empty(growable: true));
  }

  Response _createNewResponse() {
    return Response(
        id: uuid.v1(),
        responseCode: 200,
        responseDetails: 'response Details',
        active: false,
        response: '{"key":"value"}');
  }

  Path? _getNewPath(List<Path>? paths, bool firstPath) {
    if (paths?.isNotEmpty ?? false) {
      return firstPath ? paths?.first : paths?.last;
    } else {
      return null;
    }
  }

  Response? _getNewResponse(List<Response>? responses, bool firstResponse) {
    if (responses?.isNotEmpty ?? false) {
      return firstResponse ? responses?.first : responses?.last;
    } else {
      return null;
    }
  }
}

abstract class HomeViewModelInput {
  Sink<MockTer?> get mockTerInput;

  Sink<MockTerData?> get mockTerDataInput;

  Sink<Server?> get serverRunningInput;

  Sink<List<String>> get logsInput;

  getMockTer(ActionsMockTerData actionsMockTerData);

  selectFile();

  setMockTerData(ActionsMockTerData updateMockTerData,
      {Environment? environment, Path? path, Response? response});
}

abstract class HomeViewModelOutput {
  Stream<MockTer?> get mockTerOutput;

  Stream<MockTerData?> get mockTerDataOutput;

  Stream<Server?> get serverRunningOutput;

  Stream<List<String>> get logsOutput;
}

class MockTerData {
  final Environment? environment;
  final Path? path;
  final Response? response;

  MockTerData(this.environment, this.path, this.response);
}

class Server {
  final String environmentName;
  final String environmentId;
  final String host;
  final int port;

  Server(
      {required this.environmentName,
      required this.environmentId,
      required this.host,
      required this.port});
}

enum ActionsMockTerData {
  firstCall,
  addEnvironment,
  addPath,
  addResponse,
  updateEnvironment,
  updatePath,
  updateResponse,
  deleteEnvironment,
  deletePath,
  deleteResponse,
  selectMockTer
}
