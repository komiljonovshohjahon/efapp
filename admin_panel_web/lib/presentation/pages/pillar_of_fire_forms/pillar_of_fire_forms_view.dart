// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_web/presentation/global_widgets/default_table.dart';
import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:admin_panel_web/utils/global_extensions.dart';
import 'package:admin_panel_web/utils/table_helpers.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PillarOfFireFormsView extends StatefulWidget {
  const PillarOfFireFormsView({Key? key}) : super(key: key);

  @override
  State<PillarOfFireFormsView> createState() => _PillarOfFireFormsViewState();
}

class _PillarOfFireFormsViewState extends State<PillarOfFireFormsView>
    with TableFocusNodeMixin<PillarOfFireFormsView, PillarMdForm> {
  DocumentSnapshot? startAt;
  @override
  Future<List<PillarMdForm>?> fetch() async {
    final res =
        await DependencyManager.instance.firestore.getPillarOfFireForms();
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

  @override
  Widget build(BuildContext context) {
    return DefaultTable(
      headerEnd: ElevatedButton(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.red),
          onPressed: () => onDelete(() async => await deleteSelected(null),
              showError: false),
          child: const Text("Delete Selected")),
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
