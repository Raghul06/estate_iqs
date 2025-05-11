
import 'package:get_it/get_it.dart';

/// Service locator instance.
final sl = GetIt.instance;

/// Initialize the dependency injection container.
Future<void> initInjectionContainer() async {
  // Register dependencies for your app.

  // Example (Authentication module):
  // sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());
  // sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));
  // sl.registerLazySingleton(() => LoginUseCase(sl()));

  // For Splash Screen:
  // Currently, no dependency is needed for SplashScreen.

  // Register additional modules as needed.
}
