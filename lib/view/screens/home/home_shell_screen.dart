import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/model/providers/database/database_references_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/database_songs_notifier.dart';
import 'package:cancionero_seixo/view/screens/home/home_folders_tab_bar.dart';
import 'package:cancionero_seixo/view/widgets/screens/shell_screen.dart';

class HomeShellScreen extends ConsumerStatefulWidget {
  const HomeShellScreen({super.key});

  @override
  ConsumerState<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends ConsumerState<HomeShellScreen> with ShellScreen {
  @override
  Widget build(BuildContext context) {
    print("HomeShellScreen building...");

    return Scaffold(
      appBar: AppBar(
        leading: leading(context),
        title: const Text("Inicio"),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed('search', extra: false),
            icon: const Icon(Icons.manage_search),
          ),
          IconButton(
            onPressed: () {
              Iterable<Reference>? references = ref.read(DatabaseProviders.references)?.values;

              if (references != null) {
                Reference reference = references.elementAt(Random().nextInt(references.length));

                context.pushNamed('song', extra: reference.id);
              }
            },
            icon: const Icon(Icons.shuffle),
          ),
          PopupMenuButton(
            offset: const Offset(0, 60),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text("Ayuda"),
                onTap: () {},
              ),
              // PopupMenuItem(
              //   child: const Text("Import Data"),
              //   onTap: () async {
              //     FirebaseFirestore firestore = FirebaseFirestore.instance;
              //
              //     List<dynamic> songs = jsonDecode(await rootBundle.loadString('assets/data/songs.json'));
              //     List<dynamic> folders = jsonDecode(await rootBundle.loadString('assets/data/folders.json'));
              //
              //     Map<int, String> folderIds = {};
              //
              //     for (Map<String, dynamic> folder in folders) {
              //       String id = await ref.read(DatabaseProviders.folders.notifier).add(
              //             title: folder['title'],
              //             description: folder['description'],
              //             homepage: folder['main'],
              //           );
              //
              //       folderIds[folder['id']] = id;
              //     }
              //
              //     for (Map<String, dynamic> song in songs) {
              //       String id = await ref.read(DatabaseProviders.songs.notifier).add(
              //             title: song['title'],
              //             lyrics: song['lyrics'],
              //             authors: song['authors'],
              //             order: song['order'],
              //             references: (song['references'] as List<dynamic>?)
              //                 ?.map((reference) => DatabaseReference.fromJson(reference..['folder'] = folderIds[reference['folder']]))
              //                 .toList(),
              //           );
              //     }
              //
              //     print("IMPORT COMPLETED !!!!!!!!!!!");
              //   },
              // ),
            ],
          ),
        ],
      ),
      body: const HomeFoldersTabBar(),
    );
  }
}

class FirestoreImportOption extends ConsumerWidget {
  const FirestoreImportOption({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuItem(
      child: const Text("Import Data"),
      onTap: () async {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        List<dynamic> songs = jsonDecode(await rootBundle.loadString('assets/data/songs.json'));
        List<dynamic> folders = jsonDecode(await rootBundle.loadString('assets/data/folders.json'));

        Map<String, String> folderIds = {};

        for (Map<String, dynamic> folder in folders) {
          String id = await ref.read(DatabaseProviders.folders.notifier).add(
                title: folder['title'],
                description: folder['description'],
                homepage: folder['homepage'],
              );

          folderIds[folder['id']] = id;
        }

        for (Map<String, dynamic> song in songs) {
          String id = await ref.read(DatabaseProviders.songs.notifier).add(
                title: song['title'],
                lyrics: song['lyrics'],
                authors: song['authors'],
                order: song['order'],
                references: song['references']?.map((reference) => DatabaseReference(
                      folder: folderIds[reference['folder']]!,
                      number: reference['number'],
                    )),
              );
        }

        print("IMPORT COMPLETED !!!!!!!!!!!");
      },
    );
  }
}
