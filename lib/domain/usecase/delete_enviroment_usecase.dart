import 'package:dartz/dartz.dart';
import 'package:mockter/data/local/failure.dart';
import 'package:mockter/domain/repository/repository.dart';
import 'package:mockter/domain/usecase/base_usecase.dart';

class DeleteEnvironmentUseCase implements BaseUseCase<String, bool> {
  final Repository _repository;

  DeleteEnvironmentUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> execute(String input) =>
      _repository.deleteEnvironment(input);
}
