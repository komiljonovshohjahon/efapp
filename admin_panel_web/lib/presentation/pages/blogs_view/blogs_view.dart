// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_web/presentation/global_widgets/default_table.dart';
import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:admin_panel_web/presentation/pages/blogs_view/new_blog_view.dart';
import 'package:admin_panel_web/utils/global_extensions.dart';
import 'package:admin_panel_web/utils/table_helpers.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
    final res = await DependencyManager.instance.firestore.getBlogs(
      substr_date: DateFormat("MMM yyyy").format(selectedDate.value),
    );
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
          renderer: (rendererContext) {
            return Html(data: rendererContext.cell.value);
          },
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
                onDelete: () => onDelete(
                    () async => await deleteSelected(rendererContext.row),
                    showError: false));
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
          monthSelectorWidget,
          //button to add new, delete selected
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red),
              onPressed: () => onDelete(() async => await deleteSelected(null),
                  showError: false),
              child: const Text("Delete Selected")),
          ElevatedButton(
              onPressed: () => onEdit((p0) => NewBlogView(model: p0), null),
              child: const Text("Add New")),
        ],
      ),
      onLoaded: onLoaded,
      columns: columns,
      rows: rows,
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
      final res = await dependencyManager.firestore.deleteBlog(id);
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
