import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/main_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(), // Cubit burada sağlanıyor
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainUI(), // Ana ekran burada başlatılıyor
      ),
    );
  }
}
