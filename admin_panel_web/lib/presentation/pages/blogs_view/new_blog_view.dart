// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:admin_panel_web/utils/utils.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:file_picker/file_picker.dart';

class NewBlogView extends StatefulWidget {
  final BlogMd? model;
  const NewBlogView({Key? key, this.model}) : super(key: key);

  @override
  State<NewBlogView> createState() => _NewBlogViewState();
}

class _NewBlogViewState extends State<NewBlogView> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final HtmlEditorController _descriptionController = HtmlEditorController();
  PlatformFile? _image;
  DateTime date = DateTime.now();

  bool get isNew => widget.model == null;

  BlogMd get model => widget.model ?? BlogMd.init();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) async {
      if (!isNew) {
        _titleController.text = model.title;
        date = DateTime.tryParse(model.createdAt) ?? DateTime.now();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!formKey.currentState!.validate()) return;
    context.futureLoading(() async {
      final res = await DependencyManager.instance.firestore.createOrUpdateBlog(
        model: model.copyWith(
          title: _titleController.text,
          description: await _descriptionController.getText(),
          createdAt: date,
        ),
        images: [_image?.bytes],
        sendNotification: true,
      );
      if (res.isRight) {
        context.pop(true);
      } else if (res.isLeft) {
        context.showError(res.left);
      } else {
        context.showError("Something went wrong");
      }
    });
  }

  bool hideDescription = false;

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
              customWidget: hideDescription
                  ? SizedBox(height: 300)
                  : DefaultHtmlEditor(
                      controller: _descriptionController,
                      initialValue: model.description,
                    )),
          DefaultCardItem(
              customWidget: Column(
            children: [
              const Text("Image"),
              ElevatedButton(
                  onPressed: () async {
                    final res = await FilePicker.platform
                        .pickFiles(type: FileType.image);
                    if (res == null) return;
                    setState(() {
                      _image = res.files.first;
                    });
                  },
                  child: const Text("Pick Image")),
              if (_image?.bytes != null)
                Image.memory(_image!.bytes!, width: 200, height: 200)
              else
                Image(
                  width: 200,
                  height: 200,
                  image: DefaultCachedFirebaseImageProvider(model.imagePath),
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox();
                  },
                )
            ],
          )),
          DefaultCardItem(
              customWidget: Column(
            children: [
              const Text("Date"),
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      hideDescription = true;
                    });
                    final res = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2025));
                    if (res == null) {
                      setState(() {
                        hideDescription = false;
                      });
                      return;
                    }
                    setState(() {
                      date = res;
                      hideDescription = false;
                    });
                  },
                  child: const Text("Pick Date")),
              Text(DateFormat.yMMMMd().format(date))
            ],
          )),
        ]),
      ),
    );
  }
}
