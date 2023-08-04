// ignore_for_file: use_build_context_synchronously

import 'package:country_picker/country_picker.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/presentation/global_widgets/default_dropdown.dart';
import 'package:efapp/presentation/global_widgets/default_text_field.dart';
import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/utils/global_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PillarView extends StatefulWidget {
  final String collection;
  const PillarView({Key? key, required this.collection}) : super(key: key);

  @override
  State<PillarView> createState() => _PillarViewState();
}

class _PillarViewState extends State<PillarView> {
  bool get isCloud => widget.collection == FirestoreDep.pillarOfCloud;
  String get title {
    if (isCloud) {
      return "Pillar of Cloud";
    }
    return "Pillar of Fire";
  }

  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final amountController = TextEditingController();
  int? prayerHours;
  Country? country;

  PillarMd? pillarMd;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) async {
      fetchPillarMd();
    });
  }

  void fetchPillarMd() {
    context.futureLoading(() async {
      try {
        final res = await DependencyManager.instance.firestore.fire
            .collection(widget.collection)
            .withConverter<PillarMd>(
          fromFirestore: (snapshot, options) {
            final data = snapshot.data()!;
            return PillarMd.fromMap(data);
          },
          toFirestore: (value, options) {
            return value.toMap();
          },
        ).get();
        if (res.docs.isEmpty) {
          context.pop();
          context.showError("No data found");
          return;
        }
        setState(() {
          pillarMd = res.docs.first.data();
        });
      } catch (e) {
        context.pop();
        context.showError(e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        //Header
        SliverAppBar(
          title: Text(title),
          centerTitle: true,
          snap: true,
          floating: true,
        ),
        //Body
        SliverList(
          delegate: SliverChildListDelegate(
            [
              if (pillarMd != null)
                Html(data: pillarMd!.description, style: {
                  //change all with bold style to context.colorScheme.primary
                  "strong": Style(color: Theme.of(context).colorScheme.primary),
                }),
              _getForm(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getForm() {
    return Container(
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
            //title => I would like to become a Pillar of Cloud of Your Minstry!
            Text(
              "I would like to become a Pillar of Cloud of Your Minstry!",
              style: context.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            DefaultTextField(
              label: "First Name",
              controller: firstNameController,
              validator: (p0) {
                if (p0!.isEmpty) {
                  return "First name is required";
                }
                return null;
              },
            ),
            //middle name
            DefaultTextField(
              label: "Middle Name",
              controller: middleNameController,
            ),
            DefaultTextField(
              label: "Last Name",
              controller: lastNameController,
              validator: (p0) {
                if (p0!.isEmpty) {
                  return "Last name is required";
                }
                return null;
              },
            ),
            DefaultTextField(
              label: "Email",
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (p0) {
                if (p0!.isEmpty) {
                  return "Email is required";
                }
                if (RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(p0) ==
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
            if (!isCloud)
              DefaultTextField(
                label: "Amount",
                controller: amountController,
                keyboardType: TextInputType.number,
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return "Amount is required";
                  }
                  return null;
                },
              ),
            if (isCloud)
              //prayer time in hours
              DefaultDropdown(
                label: "Prayer Time (in hours)",
                items: [
                  for (int i = 1; i <= 60; i++)
                    DefaultMenuItem(id: i, title: i.toString())
                ],
                valueId: prayerHours,
                onChanged: (value) {
                  setState(() {
                    prayerHours = value.id;
                  });
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
                _submit();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    context.futureLoading(() async {
      final res = await DependencyManager.instance.firestore
          .createOrUpdatePillarForm(
              model: PillarMdForm.init().copyWith(
                  prayerHours: prayerHours?.toString(),
                  phone: phoneController.text,
                  amount: amountController.text,
                  country: country!.name,
                  email: emailController.text,
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  middleName: middleNameController.text),
              isCloud: isCloud);
      if (res.isRight) {
        //clear form
        firstNameController.clear();
        middleNameController.clear();
        lastNameController.clear();
        emailController.clear();
        phoneController.clear();
        amountController.clear();
        setState(() {
          country = null;
          prayerHours = null;
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
