// ignore_for_file: use_build_context_synchronously

import 'package:country_picker/country_picker.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrayerRequestView extends StatefulWidget {
  const PrayerRequestView({Key? key}) : super(key: key);

  @override
  State<PrayerRequestView> createState() => _PrayerRequestViewState();
}

class _PrayerRequestViewState extends State<PrayerRequestView> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  Country? country;
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  int? prayerRequestType;
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8).w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12).r,
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ),
        ),
        margin: const EdgeInsets.all(12).w,
        child: Form(
          key: _formKey,
          child: SpacedColumn(
            verticalSpace: 20.h,
            children: [
              Text(
                "Submit a Prayer Request",
                style: context.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              DefaultTextField(
                label: "Name",
                controller: nameController,
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),
              //email
              DefaultTextField(
                label: "Email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return "Email is required";
                  }
                  if (RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                          .hasMatch(p0) ==
                      false) {
                    return "Invalid email";
                  }
                  return null;
                },
              ),
              DefaultTextField(
                label: "Phone",
                controller: phoneController,
                keyboardType: TextInputType.number,
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return "Phone is required";
                  }
                  return null;
                },
              ),
              DefaultTextField(
                label: "Country",
                controller: country != null
                    ? TextEditingController(
                        text: "${country!.flagEmoji} ${country!.name}")
                    : null,
                enabled: false,
                onTap: () {
                  showCountryPicker(
                      context: context,
                      onSelect: (value) {
                        setState(() {
                          country = value;
                        });
                      });
                },
              ),
              DefaultTextField(
                label: "State",
                controller: stateController,
              ),
              DefaultTextField(
                label: "City",
                controller: cityController,
              ),
              //prayer request type
              DefaultDropdown(
                  items: [
                    for (final item in specialRequestTypes.entries)
                      DefaultMenuItem(id: item.key, title: item.value)
                  ],
                  valueId: prayerRequestType,
                  label: "Prayer Request Type",
                  hasSearchBox: true,
                  onChanged: (value) {
                    setState(() {
                      prayerRequestType = value.id;
                    });
                  }),
              //message
              DefaultTextField(
                label: "Message",
                controller: messageController,
                maxLines: 5,
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return "Message is required";
                  }
                  return null;
                },
              ),

              //submit button
              ElevatedButton(
                child: const Text("Submit"),
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  if (country == null) {
                    context.showError("Please select a country");
                    return;
                  }
                  if (prayerRequestType == null) {
                    context.showError("Please select a prayer request type");
                    return;
                  }
                  _submit();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    context.futureLoading(() async {
      final res = await DependencyManager.instance.firestore
          .createOrUpdatePrayerRequest(
              model: PrayerRequestMd.init().copyWith(
        message: messageController.text,
        email: emailController.text,
        country: country!.name,
        city: cityController.text,
        contactNo: phoneController.text,
        fullname: nameController.text,
        prayerFor: prayerRequestType,
        state: stateController.text,
      ));
      if (res.isRight) {
        //clear form
        nameController.clear();
        emailController.clear();
        phoneController.clear();
        stateController.clear();
        cityController.clear();
        messageController.clear();
        setState(() {
          country = null;
          prayerRequestType = null;
        });
        context.showSuccess("Submitted successfully");
      } else if (res.isLeft) {
        context.showError(res.left);
      } else {
        context.showError("Something went wrong");
      }
    });
  }
}
