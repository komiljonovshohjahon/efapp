import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/presentation/global_widgets/default_dropdown.dart';
import 'package:efapp/presentation/global_widgets/default_text_field.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final usersQuery = FirebaseFirestore.instance.collection('audios');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('HomeView'),
          DefaultDropdown(hasSearchBox: true, onChanged: (v) {}, items: [
            DefaultMenuItem(id: 1, title: "test"),
            DefaultMenuItem(id: 2, title: "test 2")
          ]),
          const SizedBox(height: 20),
          DefaultDropdown(
            valueId: 1,
            items: [DefaultMenuItem(id: 1, title: "test", subtitle: "test 2")],
            onChanged: (v) {},
          ),
          const SizedBox(height: 20),

          DefaultTextField(
            label: "test",
          ),
          const SizedBox(height: 20),

          DefaultTextField(initialValue: "test"),

          const SizedBox(height: 20),
          ElevatedButton(onPressed: () {}, child: Text("test")),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: null, child: Text("test disabled")),
          const SizedBox(height: 20),
          Radio(value: false, groupValue: 0, onChanged: (value) {}),
          const SizedBox(height: 20),
          Radio(value: 0, groupValue: 0, onChanged: (value) {}),
          const SizedBox(height: 20),
          Radio(value: true, groupValue: 0, onChanged: null),
          const SizedBox(height: 20),
          Checkbox(value: false, onChanged: (value) {}),
          const SizedBox(height: 20),
          Switch(value: false, onChanged: null),
          // SizedBox(
          //   width: double.infinity,
          //   height: 300,
          //   child: FirestoreListView<Map<String, dynamic>>(
          //     query: usersQuery,
          //     itemBuilder: (context, snapshot) {
          //       Map<String, dynamic> user = snapshot.data();
          //       return Text('User name is ${user['audio_title']}');
          //     },
          //   ),
          // )
        ],
      ),
    );
  }
}
