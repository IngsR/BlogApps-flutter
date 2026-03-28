import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blogapps/init_dependencies.dart';
import 'package:blogapps/core/theme/app_theme.dart';
import 'package:blogapps/features/home/presentation/pages/home_page.dart';
import 'package:blogapps/features/home/presentation/bloc/home_bloc.dart';
import 'package:blogapps/features/home/presentation/bloc/home_event.dart';
import 'package:blogapps/features/search/presentation/bloc/search_bloc.dart';
import 'package:blogapps/features/bookmarks/presentation/bloc/bookmark_bloc.dart';
import 'package:blogapps/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:blogapps/features/settings/presentation/bloc/settings_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<HomeBloc>()..add(HomeFetchData())),
        BlocProvider(create: (_) => serviceLocator<SearchBloc>()),
        BlocProvider(create: (_) => serviceLocator<BookmarkBloc>()..add(LoadBookmarks())),
        BlocProvider(create: (_) => serviceLocator<SettingsBloc>()),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Personal Blog',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(1.0 + state.fontSizeDelta),
                ),
                child: child!,
              );
            },
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
