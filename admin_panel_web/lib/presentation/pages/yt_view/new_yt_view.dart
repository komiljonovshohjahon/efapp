// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:admin_panel_web/utils/utils.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:file_picker/file_picker.dart';

class NewYtView extends StatefulWidget {
  final YtVideoMd? model;
  const NewYtView({Key? key, this.model}) : super(key: key);

  @override
  State<NewYtView> createState() => _NewYtViewState();
}

class _NewYtViewState extends State<NewYtView> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  PlatformFile? _image;

  bool get isNew => widget.model == null;

  YtVideoMd get model => widget.model ?? YtVideoMd.init();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) async {
      if (!isNew) {
        _titleController.text = model.title;
        _urlController.text = model.url;
      }
    });
  }

  void _submit() {
    if (!formKey.currentState!.validate()) return;
    context.futureLoading(() async {
      // final res = await DependencyManager.instance.firestore.createOrUpdateBlog(
      //   model: model.copyWith(
      //     title: _titleController.text,
      //     description: await _descriptionController.getText(),
      //   ),
      //   images: [_image?.bytes],
      //   sendNotification: true,
      // );
      // if (res.isRight) {
      //   context.pop(true);
      // } else if (res.isLeft) {
      //   context.showError(res.left);
      // } else {
      //   context.showError("Something went wrong");
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      actions: [
        ElevatedButton(
          onPressed: context.pop,
          child: const Text("Cancel"),
        ),
        ElevatedButton(onPressed: _submit, child: const Text("Save"))
      ],
      content: Form(
        key: formKey,
        child: DefaultCard(title: "", items: [
          DefaultCardItem(
              maxLines: 3,
              title: "Title",
              isRequired: true,
              controller: _titleController),
          DefaultCardItem(
              maxLines: 3,
              title: "Video Url",
              isRequired: true,
              controller: _urlController),
        ]),
      ),
    );
  }
}
