import 'package:dartz/dartz.dart';
import 'package:mockter/data/local/failure.dart';
import 'package:mockter/domain/model/mockter.dart';
import 'package:mockter/domain/repository/repository.dart';
import 'package:mockter/domain/usecase/base_usecase.dart';

class GetMockTerUseCase implements BaseUseCase<Object?, MockTer> {
  final Repository _repository;

  GetMockTerUseCase(this._repository);

  @override
  Future<Either<Failure, MockTer>> execute(Object? input) =>
      _repository.getMockTer();
}
