import 'package:bmi/core/shared/cache_helper.dart';
import 'package:bmi/features/home/view_model/home_cubit.dart';
import 'package:bmi/features/home/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_observer.dart';
import 'core/utils/strings.dart';
import 'features/auth/view_model/auth_cubit.dart';
import 'features/auth/views/login_view.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  uId = await CacheHelper.getSavedString('uId', '');

  print(uId);
  Widget startWidget = LoginView();

  if (uId == '') {
     startWidget = LoginView();
  } else {
     startWidget = HomeView();
  }

  runApp(MyApp(start: startWidget));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.start});

  final Widget start;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => HomeCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          // scaffoldBackgroundColor: AppUI.whiteColor,
        ),
        home: start,
      ),
    );
  }
}
