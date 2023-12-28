import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:task_list/blocs/authentication_bloc/authntication_bloc.dart';
import 'package:task_list/blocs/operation_for_task/operation_for_task_bloc.dart';
import 'package:task_list/constants/app_theme.dart';
import 'package:task_list/domain/provider/locale_provider.dart';
import 'package:task_list/l10n/all_locales.dart';

import 'package:task_list/screens/home_screen/home_screen.dart';
import 'package:task_list/screens/login_scren/login_screen.dart';

class MyAppView extends StatefulWidget {
  const MyAppView({super.key});

  @override
  State<MyAppView> createState() => _MyAppViewState();
}

// Роутинг подключаем сразу!
class _MyAppViewState extends State<MyAppView> {
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    return MaterialApp(
        title: 'TaskList',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate, // Add this line
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: localeProvider.locale,
        supportedLocales: AllLocale.all,
        theme: AppTheme.mainTheme,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return BlocProvider(
              create: (context) => OperationForTaskBloc(),
              child: const HomeScreen(),
            );
          } else if (state.status == AuthenticationStatus.unauthenticated) {
            return const LoginScreen();
          } else {
            return const Center(
                // Выносим даже не большие экраны, иначе запаришься искать
                child: Column(
              children: [
                Text('Here must to be экран загрузки'),
                CircularProgressIndicator()
              ],
            ));
          }
        }));
  }
}
