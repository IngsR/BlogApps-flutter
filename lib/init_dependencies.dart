import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:blogapps/core/constants/app_constants.dart';
import 'package:blogapps/features/home/data/sources/home_remote_data_source.dart';
import 'package:blogapps/features/home/domain/repositories/home_repository.dart';
import 'package:blogapps/features/home/presentation/bloc/home_bloc.dart';
import 'package:blogapps/features/search/domain/repositories/search_repository.dart';
import 'package:blogapps/features/search/presentation/bloc/search_bloc.dart';
import 'package:blogapps/features/bookmarks/data/models/bookmark_model.dart';
import 'package:blogapps/features/bookmarks/domain/repositories/bookmark_repository.dart';
import 'package:blogapps/features/bookmarks/presentation/bloc/bookmark_bloc.dart';
import 'package:blogapps/features/settings/domain/repositories/settings_repository.dart';
import 'package:blogapps/features/settings/presentation/bloc/settings_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );
  
  serviceLocator.registerLazySingleton(() => Supabase.instance.client);

  await _initHive();
  _initHome();
  _initSearch();
  await _initBookmarks();
  await _initSettings();
}

Future<void> _initHive() async {
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(BookmarkAdapter());
  }
}

void _initHome() {
  // Data Sources
  serviceLocator.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(serviceLocator()),
  );

  // Repositories
  serviceLocator.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(serviceLocator()),
  );

  // Blocs
  serviceLocator.registerFactory(() => HomeBloc(serviceLocator()));
}

void _initSearch() {
  // Repositories
  serviceLocator.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(serviceLocator()),
  );

  // Blocs
  serviceLocator.registerFactory(() => SearchBloc(serviceLocator()));
}

Future<void> _initBookmarks() async {
  final bookmarkBox = await Hive.openBox<Bookmark>('bookmarks');
  serviceLocator.registerLazySingleton(() => bookmarkBox);

  // Repositories
  serviceLocator.registerLazySingleton<BookmarkRepository>(
    () => BookmarkRepositoryImpl(serviceLocator()),
  );

  // Blocs
  serviceLocator.registerFactory(() => BookmarkBloc(serviceLocator()));
}

Future<void> _initSettings() async {
  final settingsBox = await Hive.openBox('settings');
  
  // Repositories
  serviceLocator.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(settingsBox),
  );

  // Blocs
  serviceLocator.registerLazySingleton(() => SettingsBloc(serviceLocator()));
}
