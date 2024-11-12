import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/controller/routes/routes.dart';
import 'package:cancionero_seixo/firebase_options.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/model/providers/search/search_providers.dart';
import 'package:cancionero_seixo/model/providers/settings/settings_providers.dart';
import 'package:cancionero_seixo/model/providers/presentation/presentation_providers.dart';
import 'package:cancionero_seixo/view/screens/presentation/cast/cast_screen.dart';

// --- App Start Point ---
void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    _router = Routes.router(context, ref);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(PresentationProviders.cast, (previous, next) => {});
    ref.listen(PresentationProviders.index, (previous, next) => {});
    ref.listen(DatabaseProviders.songs, (previous, next) => {});
    ref.listen(DatabaseProviders.folders, (previous, next) => {});
    ref.listen(SearchProviders.result, (previous, next) => {});
    ref.listen(SearchProviders.metrics, (previous, next) => {});

    ThemeMode themeMode = ref.watch(SettingsProviders.personalization.select((personalization) => personalization.themeMode));

    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      title: 'Cancionero Seixo',
      theme: ThemeData(
        colorSchemeSeed: Colors.blueGrey,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blueGrey,
      ),
      themeMode: themeMode,
    );
  }
}

// --- Cast Screen Start Point ---
@pragma('vm:entry-point')
void presentationMain(List<String> args) {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CastScreen(
      displayId: int.parse(args[0]),
    ),
  ));
}
