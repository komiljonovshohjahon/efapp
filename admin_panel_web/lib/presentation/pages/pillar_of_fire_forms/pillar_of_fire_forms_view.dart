// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_web/presentation/global_widgets/default_table.dart';
import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:admin_panel_web/presentation/pages/blogs_view/new_blog_view.dart';
import 'package:admin_panel_web/utils/global_extensions.dart';
import 'package:admin_panel_web/utils/global_functions.dart';
import 'package:admin_panel_web/utils/table_helpers.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PillarOfFireFormsView extends StatefulWidget {
  const PillarOfFireFormsView({Key? key}) : super(key: key);

  @override
  State<PillarOfFireFormsView> createState() => _PillarOfFireFormsViewState();
}

class _PillarOfFireFormsViewState extends State<PillarOfFireFormsView>
    with TableFocusNodeMixin<PillarOfFireFormsView, PillarMdForm> {
  @override
  Future<List<PillarMdForm>?> fetch() async {
    // final res =
    //     await DependencyManager.instance.firestore.getPillarOfFireForms();
    // if (res.isLeft) {
    //   return res.left;
    // } else if (res.isRight) {
    //   context.showError(res.right);
    // } else {
    //   context.showError('Something went wrong');
    // }
    return null;
  }

  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
          title: "First Name",
          field: "first_name",
          type: PlutoColumnType.text(),
          enableRowChecked: true,
        ),
        PlutoColumn(
          title: "Middle Name",
          field: "middle_name",
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
          title: "Last Name",
          field: "last_name",
          type: PlutoColumnType.text(),
        ),
        //country
        PlutoColumn(
          title: "Country",
          field: "country",
          type: PlutoColumnType.text(),
        ),
        //amount
        PlutoColumn(
          title: "Amount",
          field: "amount",
          type: PlutoColumnType.number(format: "#,###"),
        ),
        //action
        PlutoColumn(
          title: "Action",
          field: "action",
          enableFilterMenuItem: false,
          type: PlutoColumnType.text(),
          width: 40,
          renderer: (rendererContext) {
            return rendererContext.actionMenuWidget(
                // onEdit: () => onEdit(
                //     (p0) => NewBlogView(model: p0), rendererContext.cell.value),
                onDelete: () => onDelete(
                    () async => await deleteSelected(rendererContext.row),
                    showError: false));
          },
        ),
      ];

  @override
  PlutoRow buildRow(PillarMdForm model) {
    return PlutoRow(cells: {
      "first_name": PlutoCell(value: model.firstName),
      "middle_name": PlutoCell(value: model.middleName),
      "last_name": PlutoCell(value: model.lastName),
      "country": PlutoCell(value: model.country),
      "amount": PlutoCell(value: model.amount),
      "action": PlutoCell(value: model),
    });
  }

  String? lastId;

  Future<PlutoLazyPaginationResponse> lazyFetch(
    PlutoLazyPaginationRequest request,
  ) async {
    final totalItems = await DependencyManager.instance.firestore.fire
        .collection(FirestoreDep.pillarOfFireForm)
        .count()
        .get();

    final success =
        await DependencyManager.instance.firestore.getPillarOfFireForms(
      stAt: request.page == 1 ? 1 : request.page * stateManager!.pageSize,
      edAt: request.page * stateManager!.pageSize,
    );

    List<PlutoRow> tempList = [];
    if (success.isLeft) {
      tempList = success.left.map((e) => buildRow(e)).toList();
      lastId = success.left.last.id;
    } else {
      return PlutoLazyPaginationResponse(rows: [], totalPage: 0);
    }

    if (request.sortColumn != null && !request.sortColumn!.sort.isNone) {
      tempList = [...tempList];

      tempList.sort((a, b) {
        final sortA = request.sortColumn!.sort.isAscending ? a : b;
        final sortB = request.sortColumn!.sort.isAscending ? b : a;

        return request.sortColumn!.type.compare(
          sortA.cells[request.sortColumn!.field]!.valueForSorting,
          sortB.cells[request.sortColumn!.field]!.valueForSorting,
        );
      });
    }

    final totalPage = (totalItems.count) / stateManager!.pageSize;

    return Future.value(PlutoLazyPaginationResponse(
      totalPage: totalPage.toInt(),
      rows: tempList.toList(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTable(
      headerEnd: SpacedRow(
        horizontalSpace: 10,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red),
              onPressed: () => onDelete(() async => await deleteSelected(null),
                  showError: false),
              child: const Text("Delete Selected")),
          ElevatedButton(
              onPressed: null,
              // onPressed: () => onEdit((p0) => NewBlogView(model: p0), null),
              child: const Text("Add New")),
        ],
      ),
      onLoaded: onLoaded,
      columns: columns,
      rows: rows,
      createFooter: (p0) {
        return PlutoLazyPagination(
          stateManager: p0,
          fetch: lazyFetch,
          initialPage: 1,
          initialFetch: true,
          fetchWithFiltering: true,
          fetchWithSorting: true,
        );
      },
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
