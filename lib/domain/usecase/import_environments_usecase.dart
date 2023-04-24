import 'package:dartz/dartz.dart';
import 'package:mockter/data/local/failure.dart';
import 'package:mockter/domain/model/mockter.dart';
import 'package:mockter/domain/repository/repository.dart';
import 'package:mockter/domain/usecase/base_usecase.dart';

class ImportEnvironmentsUseCase
    implements BaseUseCase<String, List<Environment>> {
  final Repository _repository;

  ImportEnvironmentsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Environment>>> execute(String input) =>
      _repository.importEnvironments(input);
}
