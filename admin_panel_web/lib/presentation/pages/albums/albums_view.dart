// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_web/presentation/global_widgets/default_firebase_image_provider.dart';
import 'package:admin_panel_web/presentation/global_widgets/default_table.dart';
import 'package:admin_panel_web/presentation/pages/albums/gallery_album_images_view.dart';
import 'package:admin_panel_web/presentation/pages/albums/new_album_view.dart';
import 'package:admin_panel_web/utils/global_extensions.dart';
import 'package:admin_panel_web/utils/table_helpers.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class AlbumsView extends StatefulWidget {
  const AlbumsView({Key? key}) : super(key: key);

  @override
  State<AlbumsView> createState() => _AlbumsViewState();
}

class _AlbumsViewState extends State<AlbumsView>
    with TableFocusNodeMixin<AlbumsView, GalleryMd> {
  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
            enableRowChecked: true,
            title: "Title",
            field: 'title',
            type: PlutoColumnType.text()),
        PlutoColumn(
            title: "Album Cover Image",
            field: 'image',
            width: 80,
            renderer: (rendererContext) {
              return TextButton(
                  onPressed: () {
                    //show image as popup
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: context.pop,
                                      icon: const Icon(Icons.close))
                                ],
                              ),
                              children: [
                                Image(
                                    width: 500,
                                    height: 500,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Text("Error loading image"),
                                      );
                                    },
                                    image: DefaultCachedFirebaseImageProvider(
                                        rendererContext.cell.value)),
                              ]);
                        });
                  },
                  child: const Text("View"));
            },
            type: PlutoColumnType.text()),
        PlutoColumn(
            title: "Images",
            field: 'images',
            width: 80,
            renderer: (rendererContext) {
              return TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                              child: GalleryAlbumImagesView(
                                  model:
                                      rendererContext.cell.value as GalleryMd));
                        });
                  },
                  child: const Text("View Images"));
            },
            type: PlutoColumnType.text()),
        PlutoColumn(
            title: "Created Date",
            field: "createdDate",
            width: 100,
            type: PlutoColumnType.date()),
        PlutoColumn(
          title: "Action",
          field: "action",
          width: 40,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.actionMenuWidget(
              onDelete: () => onDelete(
                  () async => await deleteSelected(rendererContext.row),
                  showError: false),
              onEdit: () {
                onEdit((p0) => NewAlbumView(model: p0),
                    rendererContext.cell.value);
              },
            );
          },
        ),
      ];

  @override
  PlutoRow buildRow(GalleryMd model) {
    return PlutoRow(
      cells: {
        'title': PlutoCell(value: model.title),
        'image': PlutoCell(value: model.image),
        'images': PlutoCell(value: model),
        'createdDate': PlutoCell(value: model.createdAt),
        'action': PlutoCell(value: model),
      },
    );
  }

  @override
  Future<List<GalleryMd>?> fetch() async {
    final res = await DependencyManager.instance.firestore.getAlbums();
    if (res.isLeft) {
      return res.left;
    } else if (res.isRight) {
      context.showError(res.right);
    } else {
      context.showError("Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTable(
      headerEnd: Row(
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red),
              onPressed: () => onDelete(() async => await deleteSelected(null),
                  showError: false),
              child: const Text("Delete Selected")),
          //new album button
          ElevatedButton(
            onPressed: () {
              onEdit((p0) => const NewAlbumView(), null);
            },
            child: const Text("New Album"),
          ),
        ],
      ),
      onLoaded: onLoaded,
      columns: columns,
      rows: rows,
      focusNode: focusNode,
    );
  }

  Future<bool> deleteSelected(PlutoRow? singleRow) async {
    final selected = [...stateManager!.checkedRows];
    if (singleRow != null) {
      selected.clear();
      selected.add(singleRow);
    }
    if (selected.isEmpty) {
      return false;
    }
    final List<String> delFailed = [];
    for (final row in selected) {
      final id = row.cells['action']!.value.id;
      final res = await dependencyManager.firestore.deleteGallery(id);
      if (res.isLeft) {
        delFailed.add(row.cells['title']!.value);
      }
    }
    if (delFailed.isNotEmpty) {
      context.showError("Failed to delete ${delFailed.join(", ")}");
    }
    return delFailed.isEmpty;
  }
}
