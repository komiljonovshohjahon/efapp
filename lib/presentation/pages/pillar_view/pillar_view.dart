import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class PillarView extends StatelessWidget {
  final String collection;
  const PillarView({Key? key, required this.collection}) : super(key: key);

  String get title {
    if (collection == FirestoreDep.pillarOfCloud) {
      return "Pillar of Cloud";
    }
    if (collection == FirestoreDep.pillarOfFire) {
      return "Pillar of Fire";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<PillarMd>>(
      stream: DependencyManager.instance.firestore.fire
          .collection(collection)
          .withConverter<PillarMd>(
        fromFirestore: (snapshot, options) {
          final data = snapshot.data()!;
          return PillarMd.fromMap(data);
        },
        toFirestore: (value, options) {
          return value.toMap();
        },
      ).snapshots(),
      builder: (context, snapshot) {
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        //error
        if (snapshot.hasError) {
          return const Center(
            child: Text("Error"),
          );
        }
        //no data
        if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No data"),
          );
        }
        //data
        final data = snapshot.data!.docs.first.data();
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
                  Html(data: data.description, style: {
                    //change all with bold style to context.colorScheme.primary
                    "strong":
                        Style(color: Theme.of(context).colorScheme.primary),
                  }),
                  _getForm(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _getForm() {
    if (collection == FirestoreDep.pillarOfCloud) {
      return _getPillarOfCloudForm();
    }
    return _getPillarOfFireForm();
  }

  //todo: form later
  Widget _getPillarOfCloudForm() {
    return const SizedBox();
  }

  //todo: form later
  Widget _getPillarOfFireForm() {
    return const SizedBox();
  }
}
