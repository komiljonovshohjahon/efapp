import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

YoutubeExplode yt = YoutubeExplode();

Future<Uri> getImageUri(String id) async {
  final tempDir = await getApplicationDocumentsDirectory();
  final file = File('${tempDir.path}/$id.jpg');

  return file.uri;
}

Future<void> saveImage(String id, Uint8List bytes) async {
  final tempDir = await getApplicationDocumentsDirectory();
  final file = File('${tempDir.path}/$id.jpg');
  try {
    await file.writeAsBytes(bytes);
  } catch (err) {
    log(err.toString());
  }
}

Future<String> getSongUrl(
  String id,
) async {
  String quality = 'Medium';

  id = id.replaceFirst('youtube', '');
  return 'http://${InternetAddress.loopbackIPv4.host}:8080?id=$id&q=$quality';
}
