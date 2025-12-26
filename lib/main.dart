import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'core/localization/locale_cubit.dart';
import 'package:flinder_app/l10n/app_localizations.dart';
import 'l10n/l10n.dart';
import '/app.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flinder_app/core/router/app_router.dart';

// DI
import 'package:flinder_app/core/di/injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // 'di.sl' veya sadece 'sl' hangisi tanımlıysa onu kullan. 
        // Eğer ikisi de hata verirse 'getIt' yazmayı dene.
        BlocProvider(create: (context) => di.getIt<AuthCubit>()), 
        BlocProvider(create: (context) => di.getIt<LocaleCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            title: 'Flinder Stock App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: AppRouter.router,
            
            locale: locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            // Burada küçük harf 'l10n.all' deniyoruz:
            supportedLocales: l10n.all, 
          );
        },
      ),
    );
  }
}
