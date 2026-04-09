import 'package:blogapps/features/home/data/models/blog_post_model.dart';
import 'package:blogapps/features/home/data/models/category_model.dart';
import 'package:blogapps/features/home/data/repositories/home_repository_impl.dart';
import 'package:blogapps/features/home/data/sources/home_local_data_source.dart';
import 'package:blogapps/features/home/data/sources/home_remote_data_source.dart';
import 'package:blogapps/features/home/domain/repositories/home_repository.dart';
import 'package:blogapps/features/home/presentation/bloc/home_bloc.dart';
import 'package:blogapps/features/search/data/repositories/search_repository_impl.dart';
import 'package:blogapps/features/search/domain/repositories/search_repository.dart';
import 'package:blogapps/features/search/presentation/bloc/search_bloc.dart';
import 'package:blogapps/features/bookmarks/data/models/bookmark_model.dart';
import 'package:blogapps/features/bookmarks/data/repositories/bookmark_repository_impl.dart';
import 'package:blogapps/features/bookmarks/domain/repositories/bookmark_repository.dart';
import 'package:blogapps/features/bookmarks/presentation/bloc/bookmark_bloc.dart';
import 'package:blogapps/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:blogapps/features/settings/domain/repositories/settings_repository.dart';
import 'package:blogapps/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:blogapps/core/constants/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHive();
  await _initSupabase();
  _initHome();
  _initSearch();
  _initBookmarks();
  _initSettings();
}

Future<void> _initHive() async {
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(BookmarkAdapter());
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(BlogPostModelAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }

  final latestPostsBox = await Hive.openBox<BlogPostModel>('latest_posts_box');
  final featuredPostsBox = await Hive.openBox<BlogPostModel>(
    'featured_posts_box',
  );
  final categoriesBox = await Hive.openBox<CategoryModel>('categories_box');
  final bookmarkBox = await Hive.openBox<Bookmark>('bookmarks_box');
  final settingsBox = await Hive.openBox('settings_box');

  serviceLocator.registerLazySingleton<Box<BlogPostModel>>(
    () => latestPostsBox,
    instanceName: 'latest_posts',
  );
  serviceLocator.registerLazySingleton<Box<BlogPostModel>>(
    () => featuredPostsBox,
    instanceName: 'featured_posts',
  );
  serviceLocator.registerLazySingleton<Box<CategoryModel>>(() => categoriesBox);
  serviceLocator.registerLazySingleton<Box<Bookmark>>(() => bookmarkBox);
  serviceLocator.registerLazySingleton<Box>(
    () => settingsBox,
    instanceName: 'settings',
  );
}

Future<void> _initSupabase() async {
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(() => Supabase.instance.client);
}

void _initHome() {
  serviceLocator.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(
      latestPostsBox: serviceLocator(instanceName: 'latest_posts'),
      featuredPostsBox: serviceLocator(instanceName: 'featured_posts'),
      categoriesBox: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(serviceLocator(), serviceLocator()),
  );

  serviceLocator.registerFactory(() => HomeBloc(serviceLocator()));
}

void _initSearch() {
  serviceLocator.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerFactory(() => SearchBloc(serviceLocator()));
}

void _initBookmarks() {
  serviceLocator.registerLazySingleton<BookmarkRepository>(
    () => BookmarkRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerFactory(() => BookmarkBloc(serviceLocator()));
}

void _initSettings() {
  serviceLocator.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(serviceLocator(instanceName: 'settings')),
  );
  serviceLocator.registerFactory(() => SettingsBloc(serviceLocator()));
}
