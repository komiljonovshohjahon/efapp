import 'dart:convert';

import 'package:cad_audio_service/cad_audio_service.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/manager/ytmusic/ytmusic.dart';
import 'package:efapp/utils/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:youtube_data_api/youtube_data_api.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:http/http.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final usersQuery = FirebaseFirestore.instance.collection('audios');

  final yt = YoutubeExplode();

  static const Map<String, String> endpoints = {
    'search': 'search',
    'browse': 'browse',
    'get_song': 'player',
    'get_playlist': 'playlist',
    'get_album': 'album',
    'get_artist': 'artist',
    'get_video': 'video',
    'get_channel': 'channel',
    'get_lyrics': 'lyrics',
    'search_suggestions': 'music/get_search_suggestions',
    'next': 'next',
  };
  static const filters = [
    'albums',
    'artists',
    'playlists',
    'community_playlists',
    'featured_playlists',
    'songs',
    'videos'
  ];

  static const ytmDomain = 'music.youtube.com';
  static const httpsYtmDomain = 'https://music.youtube.com';
  static const baseApiEndpoint = '/youtubei/v1/';
  static const ytmParams = {
    'alt': 'json',
    'key': 'AIzaSyC9XL3ZjWddXya6X74dJoCTL-WEYFDNX30'
  };

  Future<Map> sendRequest(
      String endpoint, Map body, Map<String, String>? headers,
      {Map? params}) async {
    params ??= {};
    params.addAll(ytmParams);
    final Uri uri = Uri.https(ytmDomain, baseApiEndpoint + endpoint, ytmParams);
    final response = await post(uri, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map;
    } else {
      print('YtMusic returned ${response.statusCode} - ${response.body}');
      print('Requested endpoint: $uri');
      return {};
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      videos.listen((event) {
        print(event.author);
        if (url != null) return;
        url = event.url.toString();
        setState(() {});
      });
    });
  }

  late var videos = yt.playlists.getVideos(
      'https://youtube.com/playlist?list=PL4MsOXaZTTyqklRsxM76su7jy-s9ym-l1');

  String? url;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text('HomeView'),
          ElevatedButton(
              onPressed: () async {
                final YtMusicService ytMusic = YtMusicService();
                final result = await ytMusic
                    .getPlaylistDetails('PLqfqCgIR7_3QXdJmcQbglq__BiZ6N-RRi');
                logger(result['songs']);
                //'PLqfqCgIR7_3QXdJmcQbglq__BiZ6N-RRi'
                // print(result);
                // audioStore.dispatch(PlayFromUrlAction(
                //     "https://rr3---sn-npoeeney.googlevideo.com/videoplayback?expire=1690902745&ei=eczIZOzkIsOrlQT725-ICw&ip=121.167.219.197&id=o-AG2x5GijcxW9cX3OxiIprbNNf1Hf_THxd4b-cP6COmBL&itag=18&source=youtube&requiressl=yes&spc=Ul2Sq7VMVOR1BlS346YhkDDdglXPX2BY-rzSxKQiCQ&vprv=1&svpuc=1&mime=video%2Fmp4&ns=JAKsIEg6MAmzzpHPMLm6qC8O&cnr=14&ratebypass=yes&dur=799.788&lmt=1660442192895426&fexp=24007246,24350018,24363391,51000011&beids=24350018&c=WEB&txp=2318224&n=264EpslhwQ4nRb7caW&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cspc%2Cvprv%2Csvpuc%2Cmime%2Cns%2Ccnr%2Cratebypass%2Cdur%2Clmt&sig=AOq0QJ8wRAIgDdvY7sOCYZeee-ZWx60qfDLsa_wxDKJDosWgf1zEeM4CIG6QxoiljGhdvebRoAo7A0TbB7QG6N0xqF-61xfY1QFr&cm2rm=sn-3u-bh2z77d,sn-3pm6e76&req_id=406010b6cf14a3ee&ipbypass=yes&redirect_counter=2&cms_redirect=yes&cmsv=e&mh=Ni&mm=34&mn=sn-npoeeney&ms=ltu&mt=1690880928&mv=m&mvi=3&pl=18&lsparams=ipbypass,mh,mm,mn,ms,mv,mvi,pl&lsig=AG3C_xAwRQIgLKvzzKcrU1cTsRAH9stRt8PA06DOYQx2WoQl9d-URGsCIQCVJNcfRWX9VRiAMMVLZ6iNvkNTFo3djMpGExfZzgelbg%3D%3D"
                // ));
                return;
                try {
                  final videoResult = yt.playlists
                      .getVideos("PLhiGBbF8BdIxrP5Qv0lHKmGrG8tyUcecU");
                  logger(await videoResult.length);
                  videoResult.forEach((event) async {
                    // logger(event.title);
                    // logger(event.hasWatchPage);
                    // logger(event.duration);
                    // logger(event.id);
                    final vid = await yt.videos.get(event.id.value);
                    logger(vid.watchPage?.playerResponse?.streams.first.url);
                  });
                  // logger((await videoResult).);
                } catch (e) {
                  print(e);
                }
              },
              child: Text('test')),
          TextButton(
              onPressed: () {
                if (url == null) return;
                audioStore.dispatch(PlayFromUrlAction(
                    "https://rr3---sn-npoeeney.googlevideo.com/videoplayback?expire=1690902745&ei=eczIZOzkIsOrlQT725-ICw&ip=121.167.219.197&id=o-AG2x5GijcxW9cX3OxiIprbNNf1Hf_THxd4b-cP6COmBL&itag=18&source=youtube&requiressl=yes&spc=Ul2Sq7VMVOR1BlS346YhkDDdglXPX2BY-rzSxKQiCQ&vprv=1&svpuc=1&mime=video%2Fmp4&ns=JAKsIEg6MAmzzpHPMLm6qC8O&cnr=14&ratebypass=yes&dur=799.788&lmt=1660442192895426&fexp=24007246,24350018,24363391,51000011&beids=24350018&c=WEB&txp=2318224&n=264EpslhwQ4nRb7caW&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cspc%2Cvprv%2Csvpuc%2Cmime%2Cns%2Ccnr%2Cratebypass%2Cdur%2Clmt&sig=AOq0QJ8wRAIgDdvY7sOCYZeee-ZWx60qfDLsa_wxDKJDosWgf1zEeM4CIG6QxoiljGhdvebRoAo7A0TbB7QG6N0xqF-61xfY1QFr&cm2rm=sn-3u-bh2z77d,sn-3pm6e76&req_id=406010b6cf14a3ee&ipbypass=yes&redirect_counter=2&cms_redirect=yes&cmsv=e&mh=Ni&mm=34&mn=sn-npoeeney&ms=ltu&mt=1690880928&mv=m&mvi=3&pl=18&lsparams=ipbypass,mh,mm,mn,ms,mv,mvi,pl&lsig=AG3C_xAwRQIgLKvzzKcrU1cTsRAH9stRt8PA06DOYQx2WoQl9d-URGsCIQCVJNcfRWX9VRiAMMVLZ6iNvkNTFo3djMpGExfZzgelbg%3D%3D"
                    // url!
                    // 'https://actions.google.com/sounds/v1/alarms/alarm_clock.ogg'
                    ));
              },
              child: const Text("Play This song")),
          const PlayButtonWidget(),
          // const BottomPlayer(),
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
