import 'package:dartz/dartz.dart';
import 'package:mockter/data/local/failure.dart';

abstract class BaseUseCase<In, Out> {
  Future<Either<Failure, Out>> execute(In input);
}
