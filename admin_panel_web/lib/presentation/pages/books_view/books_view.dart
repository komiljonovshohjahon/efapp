// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:html';

import 'package:admin_panel_web/presentation/global_widgets/default_table.dart';
import 'package:admin_panel_web/presentation/global_widgets/spaced_row.dart';
import 'package:admin_panel_web/presentation/pages/books_view/new_book_view.dart';
import 'package:admin_panel_web/utils/global_extensions.dart';
import 'package:admin_panel_web/utils/table_helpers.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:pluto_grid/pluto_grid.dart';

class BooksView extends StatefulWidget {
  const BooksView({super.key});

  @override
  State<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView>
    with TableFocusNodeMixin<BooksView, BookMd> {
  @override
  Widget build(BuildContext context) {
    return DefaultTable(
        headerEnd: SpacedRow(
          horizontalSpace: 10,
          children: [
            //button to add new, delete selected
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.red),
                onPressed: () {
                  onDelete(() async {
                    return await deleteSelected(null);
                  }, showError: false);
                },
                child: const Text("Delete Selected")),
            ElevatedButton(
                onPressed: () {
                  onEdit((p0) => NewBookView(model: p0), null);
                },
                child: const Text("Add New")),
          ],
        ),
        focusNode: focusNode,
        onLoaded: onLoaded,
        columns: columns,
        rows: rows);
  }

  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
            enableRowChecked: true,
            title: "Title",
            field: "title",
            type: PlutoColumnType.text()),
        PlutoColumn(
            title: "Date",
            field: "date",
            width: 100,
            type: PlutoColumnType.date()),
        PlutoColumn(
          title: "URL",
          field: "url",
          width: 80,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return TextButton(
                onPressed: () {
                  window.open(rendererContext.cell.value, 'new tab');
                },
                child: const Text("Open"));
          },
        ),
        PlutoColumn(
          title: "Action",
          field: "action",
          width: 80,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.actionMenuWidget(
              onEdit: () {
                onEdit(
                    (p0) => NewBookView(model: p0), rendererContext.cell.value);
              },
              onDelete: () {
                onDelete(() async {
                  return await deleteSelected(rendererContext.row);
                }, showError: false);
              },
            );
          },
        ),
      ];

  @override
  PlutoRow buildRow(BookMd model) {
    return PlutoRow(cells: {
      "title": PlutoCell(value: model.title),
      "date": PlutoCell(value: model.createdDate),
      "url": PlutoCell(value: model.url),
      "action": PlutoCell(value: model),
    });
  }

  @override
  Future<List<BookMd>?> fetch() async {
    final success = await dependencyManager.firestore.getBooks();
    if (success.isLeft) {
      return success.left;
    } else {
      context.showError("Something went wrong");
    }
    return null;
  }

  Future<bool> deleteSelected(PlutoRow? singleRow) async {
    // final selected = [...stateManager!.checkedRows];
    // if (singleRow != null) {
    //   selected.clear();
    //   selected.add(singleRow);
    // }
    // if (selected.isEmpty) {
    //   return false;
    // }
    // final List<String> delFailed = [];
    // for (final row in selected) {
    //   final id = row.cells['action']!.value.id;
    //   final res = await dependencyManager.firestore.deleteDailyDevotion(id);
    //   if (res.isLeft) {
    //     delFailed.add(row.cells['title']!.value);
    //   }
    // }
    // if (delFailed.isNotEmpty) {
    //   context.showError("Failed to delete ${delFailed.join(", ")}");
    // }
    // return delFailed.isEmpty;
    return false;
  }
}
