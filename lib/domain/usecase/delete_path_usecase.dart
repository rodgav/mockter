import 'package:dartz/dartz.dart';
import 'package:mockter/data/local/failure.dart';
import 'package:mockter/data/request/delete_path_request.dart';
import 'package:mockter/domain/repository/repository.dart';
import 'package:mockter/domain/usecase/base_usecase.dart';

class DeletePathUseCase implements BaseUseCase<DeletePathRequest, bool> {
  final Repository _repository;

  DeletePathUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> execute(DeletePathRequest input) =>
      _repository.deletePath(input.environmentId, input.pathId);
}
