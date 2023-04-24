import 'package:dartz/dartz.dart';
import 'package:mockter/data/local/failure.dart';
import 'package:mockter/data/request/update_environment_request.dart';
import 'package:mockter/domain/model/mockter.dart';
import 'package:mockter/domain/repository/repository.dart';
import 'package:mockter/domain/usecase/base_usecase.dart';

class UpdateEnvironmentUseCase
    implements BaseUseCase<UpdateEnvironmentRequest, Environment?> {
  final Repository _repository;

  UpdateEnvironmentUseCase(this._repository);

  @override
  Future<Either<Failure, Environment?>> execute(
          UpdateEnvironmentRequest input) =>
      _repository.updateEnvironment(input);
}
