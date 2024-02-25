part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initOnBoarding();
  await _initAuth();
}

/* ------------------------------ _initAuth ------------------------------ */

Future<void> _initAuth() async {
  sl.registerFactory(() => AuthBloc(
      signIn: sl(), signUp: sl(), forgotPassword: sl(), updateUser: sl()));

  sl.registerLazySingleton(() => SignIn(sl()));

  sl.registerLazySingleton(() => SignUp(sl()));

  sl.registerLazySingleton(() => ForgotPassword(sl()));

  sl.registerLazySingleton(() => UpdateUser(sl()));

  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()));

  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(
        authClient: sl(),
        cloudStoreClient: sl(),
        dbClient: sl(),
      ));

  sl.registerLazySingleton(() => FirebaseAuth.instance);

  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  sl.registerLazySingleton(() => FirebaseStorage.instance);
}

/* --------------------------- _initOnBoarding ----------------------------- */

Future<void> _initOnBoarding() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerFactory(() =>
      OnBoardingCubit(cacheFirstTimer: sl(), checkIfUserIsFirstTimer: sl()));

  sl.registerLazySingleton(() => CacheFirstTimer(sl()));

  sl.registerLazySingleton(() => CheckIfUserIsFirstTimer(sl()));

  sl.registerLazySingleton<OnBoardingRepo>(() => OnBoardingRepoImpl(sl()));

  sl.registerLazySingleton<OnBoardingLocalDataSource>(
      () => OnBoardingLocalDataSourceImpl(sl()));

  sl.registerLazySingleton(() => prefs);
}
