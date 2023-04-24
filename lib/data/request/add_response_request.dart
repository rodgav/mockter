import 'package:mockter/domain/model/mockter.dart';

class AddResponseRequest {
  final String environmentId;
  final String pathId;
  final Response response;

  AddResponseRequest(
      {required this.environmentId,
      required this.pathId,
      required this.response});
}
