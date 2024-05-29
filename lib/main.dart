import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:konsul/features/auth/bloc/auth_cubit.dart';
import 'package:konsul/features/auth/bloc/auth_state.dart';
import 'package:konsul/features/dosen/bloc/add_promise_cubit.dart';
import 'package:konsul/features/dosen/bloc/avail_cubit.dart';
import 'package:konsul/features/dosen/bloc/mydosen_cubit.dart';
import 'package:konsul/features/profile/bloc/profile_cubit.dart';
import 'package:konsul/firebase_options.dart';
import 'package:konsul/services/app_router.dart';
import 'package:konsul/widgets/loading_progress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  // WidgetsBinding widgetsBinding =
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi HydratedStorage
  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  HydratedBloc.storage = storage;
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Mengatur preferensi orientasi layar
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Menjalankan aplikasi
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthCubit _authCubit = AuthCubit();
  late final _router = AppRouter(_authCubit).router;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => _authCubit),
          BlocProvider<ProfileCubit>(create: (context) => ProfileCubit()),
          BlocProvider<MydosenCubit>(create: (context) => MydosenCubit()),
          BlocProvider<AddPromiseCubit>(create: (context) => AddPromiseCubit()),
          BlocProvider<AvailCubit>(create: (context) => AvailCubit()),
        ],
        child: BlocListener<AuthCubit, AuthState>(
          listenWhen: (previousState, state) {
            return (previousState.status == AuthStatus.initial ||
                    previousState.status == AuthStatus.loading) &&
                (state.status != AuthStatus.initial &&
                    state.status != AuthStatus.loading);
          },
          listener: (BuildContext context, AuthState state) {
            FlutterNativeSplash.remove();
          },
          child: buildMaterialApp(_router),
        ));
  }

  Widget buildMaterialApp(GoRouter router) {
    return MaterialApp.router(
      title: 'Konsul Dosen',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (previous, current) {
            return previous.status != current.status;
          },
          builder: (BuildContext context, AuthState state) {
            FlutterNativeSplash.remove();
            if (state.status == AuthStatus.initial ||
                state.status == AuthStatus.loading) {
              return const Scaffold(
                body: LoadingProgress(),
              );
            }
            // else if (state.status == AuthStatus.failure ||
            //     state.status == AuthStatus.reloading) {
            //   return LoginErrorScreen(
            //       DioExceptions.fromDioError(state.error!, context).toString());
            // }
            // dioClient.init();
            return ResponsiveBreakpoints.builder(
              child: child!,
              breakpoints: [
                const Breakpoint(start: 0, end: 450, name: MOBILE),
                const Breakpoint(start: 451, end: 800, name: TABLET),
                const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              ],
            );
          },
        );
      },
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0FAEAE),
          primary: const Color(0xFF0FAEAE),
          secondary: const Color(0xFFF1BC19),
          onSecondary: const Color.fromARGB(255, 33, 33, 33),
          onSurfaceVariant: Colors.grey,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color.fromARGB(255, 57, 81, 98),
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.white,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(surfaceTintColor: Colors.white),
        useMaterial3: true,
        cardTheme: const CardTheme(
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
      ),
    );
  }
}
