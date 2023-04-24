import 'package:hive_flutter/hive_flutter.dart';

part 'mockter.g.dart';

@HiveType(typeId: 0)
class MockTer {
  @HiveField(0)
  String host;
  @HiveField(1)
  int port;
  @HiveField(2)
  List<Environment> environments;

  MockTer({required this.host, required this.port, required this.environments});
}

@HiveType(typeId: 1)
class Environment {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String description;
  @HiveField(3)
  String basePath;
  @HiveField(4)
  List<Path> paths;

  Environment(
      {required this.id,
      required this.title,
      required this.description,
      required this.basePath,
      required this.paths});
}

@HiveType(typeId: 2)
class Path {
  @HiveField(0)
  String id;
  @HiveField(1)
  String path;
  @HiveField(2)
  Methods? method;
  @HiveField(3)
  String summary;
  @HiveField(4)
  List<Response> responses;

  Path(
      {required this.id,
      required this.path,
      required this.method,
      required this.summary,
      required this.responses});
}

@HiveType(typeId: 3)
enum Methods {
  @HiveField(0)
  get,
  @HiveField(1)
  post,
  @HiveField(2)
  put,
  @HiveField(3)
  patch,
  @HiveField(4)
  delete,
  @HiveField(5)
  head,
  @HiveField(6)
  options
}

@HiveType(typeId: 4)
class Response {
  @HiveField(0)
  String id;
  @HiveField(1)
  int responseCode;
  @HiveField(2)
  String responseDetails;
  @HiveField(3)
  bool active;
  @HiveField(4)
  String? response;

  Response(
      {required this.id,
      required this.responseCode,
      required this.responseDetails,
      this.active = false,
      this.response});
}
