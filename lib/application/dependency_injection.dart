import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockter/data/data_source/local_datasource.dart';
import 'package:mockter/data/local/hive_factory.dart';
import 'package:mockter/data/repository/repository_impl.dart';
import 'package:mockter/data/services/hive_service.dart';
import 'package:mockter/domain/model/mockter.dart';
import 'package:mockter/domain/repository/repository.dart';
import 'package:mockter/domain/usecase/add_environment_usecase.dart';
import 'package:mockter/domain/usecase/add_path_usecase.dart';
import 'package:mockter/domain/usecase/add_response_usecase.dart';
import 'package:mockter/domain/usecase/delete_path_usecase.dart';
import 'package:mockter/domain/usecase/delete_response_usecase.dart';
import 'package:mockter/domain/usecase/import_environments_usecase.dart';
import 'package:mockter/domain/usecase/delete_enviroment_usecase.dart';
import 'package:mockter/domain/usecase/get_mockter_usecase.dart';
import 'package:mockter/domain/usecase/update_environment_usecase.dart';
import 'package:mockter/domain/usecase/update_path_usecase.dart';
import 'package:mockter/domain/usecase/update_response_usecase.dart';
import 'package:mockter/presentation/home/home_viewmodel.dart';

final getIt = GetIt.instance;

Future<void> initModule() async {
  await HiveFactory().initHive();
  Hive.registerAdapter(MockTerAdapter());
  Hive.registerAdapter(EnvironmentAdapter());
  Hive.registerAdapter(PathAdapter());
  Hive.registerAdapter(MethodsAdapter());
  Hive.registerAdapter(ResponseAdapter());

  final mockTerBox = await Hive.openBox<MockTer>('mockTerBox');

  //getIt.registerLazySingleton<Box<MockTer>>(() => mockTerBox);
  getIt.registerLazySingleton<HiveService>(() => HiveService(mockTerBox));
  getIt.registerLazySingleton<LocalDataSource>(
      () => LocalDataSourceImpl(getIt<HiveService>()));
  getIt.registerLazySingleton<Repository>(
      () => RepositoryImpl(getIt<LocalDataSource>()));
  getIt.registerLazySingleton<GetMockTerUseCase>(
      () => GetMockTerUseCase(getIt<Repository>()));
  getIt.registerLazySingleton(
      () => ImportEnvironmentsUseCase(getIt<Repository>()));

  getIt.registerLazySingleton<AddEnvironmentUseCase>(
      () => AddEnvironmentUseCase(getIt<Repository>()));
  getIt.registerLazySingleton<AddPathUseCase>(
      () => AddPathUseCase(getIt<Repository>()));
  getIt.registerLazySingleton<AddResponseUseCase>(
      () => AddResponseUseCase(getIt<Repository>()));

  getIt.registerLazySingleton<DeleteEnvironmentUseCase>(
      () => DeleteEnvironmentUseCase(getIt<Repository>()));
  getIt.registerLazySingleton<DeletePathUseCase>(
      () => DeletePathUseCase(getIt<Repository>()));
  getIt.registerLazySingleton<DeleteResponseUseCase>(
      () => DeleteResponseUseCase(getIt<Repository>()));

  getIt.registerLazySingleton<UpdateEnvironmentUseCase>(
      () => UpdateEnvironmentUseCase(getIt<Repository>()));
  getIt.registerLazySingleton<UpdatePathUseCase>(
      () => UpdatePathUseCase(getIt<Repository>()));
  getIt.registerLazySingleton<UpdateResponseUseCase>(
      () => UpdateResponseUseCase(getIt<Repository>()));

  getIt.registerLazySingleton<HomeViewModel>(() => HomeViewModel(
      getIt<GetMockTerUseCase>(),
      getIt<ImportEnvironmentsUseCase>(),
      getIt<AddEnvironmentUseCase>(),
      getIt<AddPathUseCase>(),
      getIt<AddResponseUseCase>(),
      getIt<DeleteEnvironmentUseCase>(),
      getIt<DeletePathUseCase>(),
      getIt<DeleteResponseUseCase>(),
      getIt<UpdateEnvironmentUseCase>(),
      getIt<UpdatePathUseCase>(),
      getIt<UpdateResponseUseCase>()));
}
