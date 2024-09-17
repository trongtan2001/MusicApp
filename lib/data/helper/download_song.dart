import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class DownloadSongHelper {
  static Future<String?> downloadSong(String url, String fileName) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      String filePath = '$appDocPath/$fileName.mp3';

      Dio dio = Dio();
      await dio.download(url, filePath);
      return filePath;
    } catch (e) {
      print("Error dowload: $e");
      return null;
    }
  }
}