import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/presentation/global_widgets/default_dropdown.dart';
import 'package:efapp/presentation/global_widgets/default_text_field.dart';
import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/utils/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final usersQuery = FirebaseFirestore.instance.collection('audios');

  final yt = YoutubeExplode();

  final player = AudioPlayer(); // Create a player
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      video.listen((event) {
        url = event.watchPage?.playerResponse?.streams.first.url;
        setState(() {});
      });
    });
  }

  late var video = yt.playlists.getVideos('PLx0sYbCqOb8TBPRdmBHs5Iftvv9TPboYG');

  String? url;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('HomeView'),
          if (url != null) AudioPlayerWidget(url: url!),
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
