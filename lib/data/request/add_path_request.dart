import 'package:mockter/domain/model/mockter.dart';

class AddPathRequest {
  String environmentId;
  Path path;

  AddPathRequest({required this.environmentId, required this.path});
}
