import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/data/song_edit_data.dart';
import 'package:cancionero_seixo/model/providers/database/database_folders_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/database_references_notifier.dart';
import 'package:cancionero_seixo/view/screens/administration/administration_screen.dart';
import 'package:cancionero_seixo/view/screens/administration/editors/editors_screen.dart';
import 'package:cancionero_seixo/view/screens/administration/history/history_screen.dart';
import 'package:cancionero_seixo/view/screens/authentication/authentication_email_login.dart';
import 'package:cancionero_seixo/view/screens/authentication/authentication_email_register.dart';
import 'package:cancionero_seixo/view/screens/authentication/authentication_profile.dart';
import 'package:cancionero_seixo/view/screens/authentication/authentication_reset_password.dart';
import 'package:cancionero_seixo/view/screens/authentication/authentication_reset_password_new.dart';
import 'package:cancionero_seixo/view/screens/authentication/authentication_screen.dart';
import 'package:cancionero_seixo/view/screens/folder/edit/folder_edit_screen.dart';
import 'package:cancionero_seixo/view/screens/folder/folder_shell_screen.dart';
import 'package:cancionero_seixo/view/screens/search/filter/filter_screen.dart';
import 'package:cancionero_seixo/view/screens/search/search_screen.dart';
import 'package:cancionero_seixo/view/screens/drawer/app_drawer.dart';
import 'package:cancionero_seixo/view/screens/presentation/display_selector/display_selector_screen.dart';
import 'package:cancionero_seixo/view/screens/selection/song_selection_screen.dart';
import 'package:cancionero_seixo/view/screens/home/home_shell_screen.dart';
import 'package:cancionero_seixo/view/screens/presentation/presentation_shell_screen.dart';
import 'package:cancionero_seixo/view/screens/settings/info_settings_screen.dart';
import 'package:cancionero_seixo/view/screens/settings/personalization_settings_screen.dart';
import 'package:cancionero_seixo/view/screens/settings/presentation_settings_screen.dart';
import 'package:cancionero_seixo/view/screens/song/add_to/add_to_screen.dart';
import 'package:cancionero_seixo/view/screens/song/chords/cropper.dart';
import 'package:cancionero_seixo/view/screens/song/chords/photo.dart';
import 'package:cancionero_seixo/view/screens/song/edit/song_edit_screen.dart';
import 'package:cancionero_seixo/view/screens/song/music/music_player_widget.dart';
import 'package:cancionero_seixo/view/screens/song/song_screen.dart';
import 'package:cancionero_seixo/view/screens/settings/settings_shell_screen.dart';

class Routes {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

  static AppDrawer? drawer;

  static GoRouter router(BuildContext context, WidgetRef ref) {
    return GoRouter(initialLocation: '/', navigatorKey: _rootNavigatorKey, routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) {
          drawer = AppDrawer(shell: shell);
          return Scaffold(
            drawer: drawer,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: shell,
                ),
                const MusicPlayerWidget()
              ],
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/', name: 'home', builder: (context, state) => const HomeShellScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/presentation', builder: (context, state) => const PresentationShellScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/administration', builder: (context, state) => const AdministrationScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) => const SettingsShellScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: '/book',
                  name: 'book',
                  builder: (context, state) => FolderShellScreen(
                        folderId: state.extra as String,
                      ))
            ],
          ),
          //StatefulShellBranch(routes: [GoRoute(path: '/window', builder: (context, state) => WindowShellScreen(context))]),
          // ...(books.map((book) => StatefulShellBranch(routes: [
          //       GoRoute(
          //           path: "/book/${book.id}",
          //           builder: (context, state) => BookShellScreen(
          //                 bookId: book.id,
          //               ))
          //     ])))
        ],
      ),

      // SETTINGS
      GoRoute(
          path: "/settings/personalization",
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => const NoTransitionPage(child: PersonalizationSettingsScreen())),
      GoRoute(
          path: "/settings/presentation",
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => const NoTransitionPage(child: PresentationSettingsScreen())),
      GoRoute(
          path: "/settings/info",
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => const NoTransitionPage(child: InfoSettingsScreen())),

      GoRoute(
          path: "/song",
          name: "song",
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => MaterialPage(child: SongScreen(referenceId: state.extra as String))),
      GoRoute(
          path: "/song/chord_photo",
          name: "chord_photo",
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => const MaterialPage(child: DocumentCapture())),
      GoRoute(
          path: "/song/chord_crop",
          name: "chord_crop",
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => MaterialPage(child: CropImageScreen(image: state.extra as File))),
      GoRoute(
          path: "/cast_settings",
          name: "cast_settings",
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => const MaterialPage(child: DisplaySelectorScreen())),
      GoRoute(
          path: "/windows",
          name: "windows",
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => const MaterialPage(child: DisplaySelectorScreen())),
      GoRoute(
          path: "/editor",
          name: "editor",
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => MaterialPage(child: SongEditScreen(data: state.extra as SongEditData?))),
      GoRoute(
          path: "/filter",
          name: "filter",
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => const MaterialPage(child: SearchFilterScreen())),
      GoRoute(
          path: "/folder_editor",
          name: "folder_editor",
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => MaterialPage(child: FolderEditScreen(folder: state.extra as Folder?))),
      GoRoute(
          path: "/search",
          name: "search",
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => MaterialPage(child: SearchScreen(presentation: state.extra as bool? ?? false))),
      GoRoute(
        path: "/search/selection",
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: SongSelectionScreen(presentation: state.extra as bool?),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Definir la animación de transición vertical
            const begin = Offset(0.0, 1.0); // Comienza desde abajo
            const end = Offset.zero; // Termina en su posición
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
          path: "/history",
          name: "history",
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => const MaterialPage(child: HistoryScreen())),
      GoRoute(
          path: "/editors",
          name: "editors",
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => const MaterialPage(child: EditorsScreen())),
      GoRoute(
          path: "/add_to",
          name: "add_to",
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => MaterialPage(child: AddSongToScreen(reference: state.extra as Reference))),
      GoRoute(
          path: "/authentication",
          name: "authentication",
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => const MaterialPage(child: AuthenticationScreen())),
      GoRoute(
          path: "/authentication/email",
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => const NoTransitionPage(child: AuthenticationEmailLogin())),
      GoRoute(
          path: "/authentication/reset",
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => const NoTransitionPage(child: AuthenticationPasswordReset())),
      GoRoute(
          path: "/authentication/reset/new",
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => NoTransitionPage(child: AuthenticationPasswordResetNew(email: state.extra as String))),
      GoRoute(
          path: "/authentication/profile",
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => const NoTransitionPage(child: AuthenticationProfile())),
      GoRoute(
          path: "/authentication/email/register",
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => NoTransitionPage(child: AuthenticationEmailRegister())),
    ]);
  }
}
