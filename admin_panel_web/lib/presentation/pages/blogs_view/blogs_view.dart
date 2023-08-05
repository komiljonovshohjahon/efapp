// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_web/presentation/global_widgets/default_table.dart';
import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:admin_panel_web/presentation/pages/blogs_view/new_blog_view.dart';
import 'package:admin_panel_web/utils/global_extensions.dart';
import 'package:admin_panel_web/utils/table_helpers.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pluto_grid/pluto_grid.dart';

class BLogsView extends StatefulWidget {
  const BLogsView({Key? key}) : super(key: key);

  @override
  State<BLogsView> createState() => _BLogsViewState();
}

class _BLogsViewState extends State<BLogsView>
    with TableFocusNodeMixin<BLogsView, BlogMd> {
  @override
  Future<List<BlogMd>?> fetch() async {
    final res = await DependencyManager.instance.firestore.getBlogs();
    if (res.isLeft) {
      return res.left;
    } else if (res.isRight) {
      context.showError(res.right);
    } else {
      context.showError('Something went wrong');
    }
    return null;
  }

  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
          title: "Title",
          field: "title",
          type: PlutoColumnType.text(),
          enableRowChecked: true,
          width: 100,
        ),
        //description
        PlutoColumn(
          title: "Description",
          field: "description",
          type: PlutoColumnType.text(),
        ),
        //date
        PlutoColumn(
          title: "Date",
          field: "date",
          type: PlutoColumnType.date(format: "yyyy-MM-dd"),
          width: 50,
        ),
        //action
        PlutoColumn(
          title: "Action",
          field: "action",
          type: PlutoColumnType.text(),
          width: 40,
          renderer: (rendererContext) {
            return rendererContext.actionMenuWidget(
              onEdit: () => onEdit(
                  (p0) => NewBlogView(model: p0), rendererContext.cell.value),
              onDelete: () {
                // onDelete(() async {
                //   return await deleteSelected(rendererContext.row);
                // }, showError: false);
              },
            );
          },
        ),
      ];

  @override
  PlutoRow buildRow(BlogMd model) {
    return PlutoRow(cells: {
      "title": PlutoCell(value: model.title),
      "description": PlutoCell(value: model.description),
      "date": PlutoCell(value: model.createdAt),
      "action": PlutoCell(value: model),
    });
  }

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
                  // onDelete(() async {
                  // return await deleteSelected(null);
                  // }, showError: false);
                },
                child: const Text("Delete Selected")),
            ElevatedButton(
                onPressed: () => onEdit((p0) => NewBlogView(model: p0), null),
                child: const Text("Add New")),
          ],
        ),
        onLoaded: onLoaded,
        columns: columns,
        rows: rows,
        focusNode: focusNode);
  }
}
