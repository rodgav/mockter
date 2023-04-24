import 'package:mockter/domain/model/mockter.dart';

class UpdateEnvironmentRequest {
  final String host;
  final int port;
  final Environment environment;

  UpdateEnvironmentRequest(this.host, this.port, this.environment);
}
