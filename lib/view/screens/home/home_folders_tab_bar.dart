import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/model/providers/database/database_folders_notifier.dart';
import 'package:cancionero_seixo/model/providers/database/database_providers.dart';
import 'package:cancionero_seixo/view/screens/song_list/song_list.dart';
import 'package:cancionero_seixo/view/widgets/text/centered_text.dart';

class HomeFoldersTabBar extends ConsumerWidget {
  const HomeFoldersTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Iterable<Folder>? folders =
        ref.watch(DatabaseProviders.folders.select((folders) => folders?.values.where((folder) => folder.inHomePage)));

    if (folders == null) return const CenteredText(text: "Cargando carpetas...");

    return DefaultTabController(
      length: folders.length,
      child: Column(
        children: [
          TabBar(
            tabs: folders
                .map(
                  (e) => Tab(
                    child: Text(
                      e.title,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                )
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              children: folders
                  .map(
                    (book) => SongList(
                      selection: false,
                      folderId: book.id,
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
