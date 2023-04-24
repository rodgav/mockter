import 'package:dartz/dartz.dart';
import 'package:mockter/data/local/failure.dart';
import 'package:mockter/data/request/delete_response_request.dart';
import 'package:mockter/domain/repository/repository.dart';
import 'package:mockter/domain/usecase/base_usecase.dart';

class DeleteResponseUseCase
    implements BaseUseCase<DeleteResponseRequest, bool> {
  final Repository _repository;

  DeleteResponseUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> execute(DeleteResponseRequest input) =>
      _repository.deleteResponse(
          input.environmentId, input.pathId, input.responseId);
}
