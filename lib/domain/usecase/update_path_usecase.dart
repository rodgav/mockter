import 'package:dartz/dartz.dart';
import 'package:mockter/data/local/failure.dart';
import 'package:mockter/data/request/add_path_request.dart';
import 'package:mockter/domain/model/mockter.dart';
import 'package:mockter/domain/repository/repository.dart';
import 'package:mockter/domain/usecase/base_usecase.dart';

class UpdatePathUseCase implements BaseUseCase<AddPathRequest, Path?> {
  final Repository _repository;

  UpdatePathUseCase(this._repository);

  @override
  Future<Either<Failure, Path?>> execute(AddPathRequest input) =>
      _repository.updatePath(input.environmentId, input.path);
}
