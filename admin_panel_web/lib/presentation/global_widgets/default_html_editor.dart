import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class DefaultHtmlEditor extends StatelessWidget {
  final String? initialValue;
  final HtmlEditorController controller;
  final String? hint;
  const DefaultHtmlEditor({
    Key? key,
    this.initialValue,
    required this.controller,
    this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HtmlEditor(
      callbacks: Callbacks(
        onInit: () {
          if (initialValue != null) {
            controller.setText(initialValue!);
          }
        },
      ),
      controller: controller,
      htmlEditorOptions: HtmlEditorOptions(hint: hint ?? "Description"),
    );
  }
}
