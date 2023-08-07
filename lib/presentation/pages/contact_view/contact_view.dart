// ignore_for_file: use_build_context_synchronously

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactView extends StatefulWidget {
  const ContactView({Key? key}) : super(key: key);

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  final formKey = GlobalKey<FormState>();
  final deps = DependencyManager.instance;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        //Header
        const SliverAppBar(
          title: Text("Contact Us"),
          centerTitle: true,
          snap: true,
          floating: true,
        ),
        //Body
        SliverList(
          delegate: SliverChildListDelegate(
            [
              //image
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 56.w),
                child: Image.asset(
                  "assets/images/contact_img.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),

              Container(
                padding: const EdgeInsets.all(8).w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12).r,
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.1),
                  ),
                ),
                margin: const EdgeInsets.all(12).w,
                child: Form(
                  key: formKey,
                  child: SpacedColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    verticalSpace: 20.h,
                    children: [
                      Text(
                        "Get In Touch",
                        style: context.textTheme.titleMedium!
                            .copyWith(color: context.colorScheme.primary),
                      ),
                      DefaultTextField(
                        controller: _nameController,
                        label: "Full Name",
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return "Please enter your full name";
                          }
                          return null;
                        },
                      ),
                      //email
                      DefaultTextField(
                        controller: _emailController,
                        label: "Email",
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return "Please enter your email";
                          }
                          return null;
                        },
                      ),

                      //phone
                      DefaultTextField(
                        controller: _phoneController,
                        label: "Phone",
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return "Please enter your phone number";
                          }
                          return null;
                        },
                      ),

                      //message
                      DefaultTextField(
                        controller: _messageController,
                        label: "Message",
                        maxLines: 5,
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return "Please enter your message";
                          }
                          return null;
                        },
                      ),
                      //submit button
                      ElevatedButton(
                        onPressed: submit,
                        child: const Text("Submit"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void submit() {
    if (!formKey.currentState!.validate()) return;
    context.futureLoading(() async {
      final res = await deps.firestore.createOrUpdateContactedForm(
          model: ContactMd.init().copyWith(
        fullName: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        message: _messageController.text,
      ));
      if (res.isRight) {
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _messageController.clear();
        context.showSuccess("Your message has been sent successfully");
      } else if (res.isLeft) {
        context.showError(res.left);
      } else {
        context.showError("An error occurred");
      }
    });
  }
}
