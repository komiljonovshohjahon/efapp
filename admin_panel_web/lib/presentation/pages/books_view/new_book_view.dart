// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:admin_panel_web/presentation/global_widgets/widgets.dart';
import 'package:admin_panel_web/utils/utils.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:file_picker/file_picker.dart';

class NewBookView extends StatefulWidget {
  final BookMd? model;

  const NewBookView({super.key, this.model});

  @override
  State<NewBookView> createState() => _NewBookViewState();
}

class _NewBookViewState extends State<NewBookView>
    with FormsMixin<NewBookView> {
  PlatformFile? image;

  bool get isEdit => widget.model != null;

  final DependencyManager dependencyManager = DependencyManager.instance;

  QuillController controller = QuillController.basic();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (isEdit) {
      controller1.text = widget.model!.title;
      controller2.text = widget.model!.url;
      controller3.text = widget.model!.imageUrl;
    }
    super.initState();
    // WidgetsBinding.instance.endOfFrame.then((value) async {
    //   if (!isEdit) return;
    //   context.futureLoading(() async {
    //     //get images
    //     final imageDataList = await dependencyManager.fireStorage
    //         .getImages("${FirestoreDep.booksCn}/${widget.model!.id}");
    //
    //     if (imageDataList.isRight) {
    //       logger("${FirestoreDep.booksCn}/${widget.model!.id}");
    //       //set images
    //       for (int i = 0; i < imageDataList.right.items.length; i++) {
    //         try {
    //           logger(await imageDataList.right.items[i].getDownloadURL());
    //           // final item = imageDataList.right.items[i];
    //           // final imageData = await item.getData();
    //           // image = PlatformFile(
    //           //   name: item.name,
    //           //   size: imageData!.lengthInBytes,
    //           //   bytes: imageData,
    //           // );
    //         } catch (e) {
    //           logger(e);
    //         }
    //       }
    //
    //       setState(() {});
    //     }
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        //Cancel button
        ElevatedButton(
          onPressed: context.pop,
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          child: const Text("Add"),
          onPressed: () async {
            if (!formKey.currentState!.validate()) return;
            context.futureLoading(() async {
              final res =
                  await DependencyManager.instance.firestore.createOrUpdateBook(
                model: BookMd.init().copyWith(
                  id: widget.model?.id,
                  title: controller1.text,
                  url: controller2.text,
                  imageUrl: controller3.text,
                  createdDate: widget.model?.createdDate,
                ),
                // images: [image?.bytes],
                images: [],
              );

              if (res.isLeft) {
                context.showError(res.left);
              } else {
                context.pop(true);
              }
            });
          },
        ),
      ],
      scrollable: true,
      content: Form(
        key: formKey,
        child: SpacedColumn(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          verticalSpace: 20,
          children: [
            DefaultCard(
              title: isEdit ? 'Edit Daily Devotion' : 'Add Daily Devotion',
              items: [
                DefaultCardItem(
                  title: "Title",
                  controller: controller1,
                  isRequired: true,
                ),
                DefaultCardItem(
                  title: "URL",
                  controller: controller2,
                  isRequired: true,
                ),
                DefaultCardItem(
                  title: "Image URL",
                  controller: controller3,
                ),
                // DefaultCardItem(
                //   customWidget: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       ElevatedButton(
                //         child: const Text("Select Image"),
                //         onPressed: () async {
                //           final result = await FilePicker.platform.pickFiles(
                //               type: FileType.image, allowMultiple: false);
                //           if (result == null) return;
                //           if (isEdit) {
                //             context.futureLoading(() async {
                //               try {
                //                 final res = await DependencyManager
                //                     .instance.fireStorage
                //                     .uploadImage(
                //                         data: result.files.first.bytes!,
                //                         path:
                //                             "${FirestoreDep.booksCn}/${widget.model!.id}/0");
                //                 if (res.isRight) {
                //                   image = result.files.first;
                //                   setState(() {});
                //                 } else {
                //                   context.showError("Failed to upload image");
                //                 }
                //               } catch (e) {
                //                 context.showError("Failed to upload image");
                //               }
                //             });
                //             return;
                //           }
                //           image = result.files.first;
                //           setState(() {});
                //         },
                //       ),
                //       if (image != null)
                //         Image.memory(
                //           image!.bytes!,
                //           width: 200,
                //           height: 200,
                //         ),
                //       if (image != null)
                //         IconButton(
                //           icon: const Icon(Icons.delete),
                //           color: Colors.red,
                //           onPressed: () {
                //             if (isEdit) {
                //               final imagePath =
                //                   "${FirestoreDep.booksCn}/${widget.model!.id}";
                //               try {
                //                 dependencyManager.fireStorage
                //                     .deleteImage(imagePath)
                //                     .then((value) {
                //                   if (value.isRight) {
                //                     image = null;
                //                     setState(() {});
                //                   } else {
                //                     context.showError("Failed to delete image");
                //                   }
                //                 });
                //               } catch (e) {
                //                 context.showError("Failed to delete image");
                //               }
                //               return;
                //             }
                //             image = null;
                //             setState(() {});
                //           },
                //         ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
