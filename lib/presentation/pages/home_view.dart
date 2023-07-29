import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/presentation/global_widgets/default_dropdown.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final usersQuery = FirebaseFirestore.instance.collection('audios');

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Text('HomeView'),
        DefaultDropdown(onChanged: (v) {}, items: [
          DefaultMenuItem(id: 1, title: "test"),
          DefaultMenuItem(id: 2, title: "test 2")
        ]),
        DefaultDropdown(
          valueId: 1,
          items: [DefaultMenuItem(id: 1, title: "test", subtitle: "test 2")],
          onChanged: (v) {},
        ),
        SizedBox(
          width: double.infinity,
          height: 500,
          child: FirestoreListView<Map<String, dynamic>>(
            query: usersQuery,
            itemBuilder: (context, snapshot) {
              Map<String, dynamic> user = snapshot.data();
              print(user);
              return Text('User name is ${user['audio_title']}');
            },
          ),
        )
      ],
    ));
  }
}
