// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_web/presentation/global_widgets/spaced_column.dart';
import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:admin_panel_web/utils/utils.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class NewAlbumView extends StatefulWidget {
  final GalleryMd? model;
  const NewAlbumView({Key? key, this.model}) : super(key: key);

  @override
  State<NewAlbumView> createState() => _NewAlbumViewState();
}

class _NewAlbumViewState extends State<NewAlbumView> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  PlatformFile? image;

  bool get isNew => widget.model == null;

  GalleryMd get model => widget.model ?? GalleryMd.init();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) async {
      if (!isNew) {
        titleController.text = model.title;
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  void _save() {
    if (!formKey.currentState!.validate()) return;
    context.futureLoading(() async {
      final res = await DependencyManager.instance.firestore
          .createOrUpdateGallery(
              model: model.copyWith(title: titleController.text),
              images: [image?.bytes]);
      if (res.isRight) {
        context.pop(true);
      } else if (res.isLeft) {
        context.showError(res.left);
      } else {
        context.showError("Something went wrong");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        //cancel button
        ElevatedButton(
          onPressed: context.pop,
          child: const Text('Cancel'),
        ),

        //save button
        ElevatedButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
      content: Form(
        key: formKey,
        child: DefaultCard(
          title: "",
          items: [
            //title
            DefaultCardItem(
                maxLines: 3,
                title: "Title",
                isRequired: true,
                controller: titleController),
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
                        image = res.files.first;
                      });
                    },
                    child: const Text("Pick Album Image")),
                if (image?.bytes != null)
                  Image.memory(image!.bytes!, width: 200, height: 200)
                else
                  Image(
                    width: 200,
                    height: 200,
                    image: DefaultCachedFirebaseImageProvider(model.image),
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox();
                    },
                  )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
