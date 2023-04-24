import 'package:dartz/dartz.dart';
import 'package:mockter/data/local/failure.dart';
import 'package:mockter/domain/model/mockter.dart';
import 'package:mockter/domain/repository/repository.dart';
import 'package:mockter/domain/usecase/base_usecase.dart';

class AddEnvironmentUseCase
    implements BaseUseCase<Environment, Environment> {
  final Repository _repository;

  AddEnvironmentUseCase(this._repository);

  @override
  Future<Either<Failure, Environment>> execute(Environment input) =>
      _repository.addEnvironment(input);
}
