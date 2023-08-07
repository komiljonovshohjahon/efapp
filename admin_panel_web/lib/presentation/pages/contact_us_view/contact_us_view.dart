// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_web/presentation/global_widgets/default_table.dart';
import 'package:admin_panel_web/utils/global_extensions.dart';
import 'package:admin_panel_web/utils/table_helpers.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({Key? key}) : super(key: key);

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView>
    with TableFocusNodeMixin<ContactUsView, ContactMd> {
  @override
  List<PlutoColumn> get columns => [
        //full name
        PlutoColumn(
          title: 'Full Name',
          field: 'fullName',
          type: PlutoColumnType.text(),
          enableRowChecked: true,
        ),
        //email
        PlutoColumn(
          title: 'Email',
          field: 'email',
          width: 100,
          type: PlutoColumnType.text(),
        ),
        //phone
        PlutoColumn(
          title: 'Phone',
          field: 'phone',
          width: 100,
          type: PlutoColumnType.text(),
        ),
        //message
        PlutoColumn(
          title: 'Message',
          field: 'message',
          type: PlutoColumnType.text(),
        ),
        //date
        PlutoColumn(
          title: 'Date',
          field: 'date',
          width: 100,
          type: PlutoColumnType.date(format: 'yyyy-MM-dd'),
        ),
        //action
        PlutoColumn(
          title: 'Action',
          field: 'action',
          width: 40,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.actionMenuWidget(
              onDelete: () =>
                  onDelete(() => deleteSelected(rendererContext.row)),
            );
          },
        ),
      ];

  @override
  PlutoRow buildRow(ContactMd model) {
    return PlutoRow(cells: {
      'fullName': PlutoCell(value: model.fullName),
      'email': PlutoCell(value: model.email),
      'phone': PlutoCell(value: model.phone),
      'message': PlutoCell(value: model.message),
      'date': PlutoCell(value: model.createdAt),
      'action': PlutoCell(value: model),
    });
  }

  @override
  Future<List<ContactMd>?> fetch() async {
    final res = await DependencyManager.instance.firestore.getContactedForms();
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
  Widget build(BuildContext context) {
    return DefaultTable(
        headerEnd: Row(
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                onDelete(() => deleteSelected(null));
              },
              icon: const Icon(Icons.delete),
              label: const Text('Delete Selected'),
            ),
            //create new button
          ],
        ),
        onLoaded: onLoaded,
        columns: columns,
        rows: rows,
        focusNode: focusNode);
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
      final res = await dependencyManager.firestore.deleteContactedForm(id);
      if (res.isLeft) {
        delFailed.add(row.cells['fullName']!.value);
      }
    }
    if (delFailed.isNotEmpty) {
      context.showError("Failed to delete ${delFailed.join(", ")}");
    }
    return delFailed.isEmpty;
  }
}
