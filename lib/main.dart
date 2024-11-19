import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tt_9/data/operation.dart';
import 'package:tt_9/onboarding_view/initial_screen.dart';
import 'package:tt_9/services/config_service.dart';
import 'package:tt_9/services/service_locator.dart';
import 'package:tt_9/timer_view/time_provider/time_provider.dart';

void main() async {
  await _init();
  runApp(ChangeNotifierProvider(
    child: const MainApp(),
    create: (context) => TimerProvider(),
  ));
}

Future<void> _init() async {
  final bindings = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: bindings);
  await ServiceLocator.setup();
  addHandler();
  await Hive.initFlutter();
  Hive.registerAdapter(OperationAdapter());

  await Hive.openBox<Operation>('operations');
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'SFProText',
      ),
      title: 'Busy Bookseller Compass',
      debugShowCheckedModeBanner: false,
      home: const InitialScreen(),
    );
  }
}

void addHandler() {
  WidgetsBinding.instance.addObserver(
    AppLifecycleListener(onDetach: GetIt.instance<ConfigService>().closeClient),
  );
}
