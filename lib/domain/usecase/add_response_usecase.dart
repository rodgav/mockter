import 'package:dartz/dartz.dart';
import 'package:mockter/data/local/failure.dart';
import 'package:mockter/data/request/add_response_request.dart';
import 'package:mockter/domain/model/mockter.dart';
import 'package:mockter/domain/repository/repository.dart';
import 'package:mockter/domain/usecase/base_usecase.dart';

class AddResponseUseCase implements BaseUseCase<AddResponseRequest, Response> {
  final Repository _repository;

  AddResponseUseCase(this._repository);

  @override
  Future<Either<Failure, Response>> execute(AddResponseRequest input) =>
      _repository.addResponse(
          input.environmentId, input.pathId, input.response);
}
