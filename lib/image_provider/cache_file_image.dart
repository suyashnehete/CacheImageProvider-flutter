import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:customimageprovider/media.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class CacheFileImage {
  ///Gets the MD5 value of the URL string
  static String getUrlMd5(String url) {
    var content = const Utf8Encoder().convert(url);
    var digest = md5.convert(content);
    return digest.toString();
  }

  ///Get image cache path
  Future<String> getCachePath() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Directory cachePath = Directory('${dir.path}/imagecache/');
    if (!cachePath.existsSync()) {
      cachePath.createSync();
    }
    return cachePath.path;
  }

  ///Determine whether there is a corresponding image cache file
  Future<Uint8List?> getFileBytes(String url) async {
    String cacheDirPath = await getCachePath();
    String urlMd5 = getUrlMd5(url);
    File file = File('$cacheDirPath$urlMd5');
    if (file.existsSync()) {
      log('-----------------------Reading-------------------------');
      log('${file.lengthSync()/1024}');
      log('${(await file.length())/1024}');
      return await file.readAsBytes();
    }

    return null;
  }

  ///Cache the downloaded image data to the specified file
  Future saveBytesToFile(String url, Uint8List bytes) async {
    String cacheDirPath = await getCachePath();
    String urlMd5 = getUrlMd5(url);
    File file = File('$cacheDirPath$urlMd5');
      file.createSync();
      await file.writeAsBytes(bytes);
      log('-----------------------Writing-------------------------');
      log('${file.lengthSync()/1024}');
      log('${(await file.length())/1024}');
  }

  ///Delete Cache file
  Future clearCache(String url) async {
    String cacheDirPath = await getCachePath();
    String urlMd5 = getUrlMd5(url);
    File file = File('$cacheDirPath$urlMd5');
    if (file.existsSync()) {
      await file.delete();
    }
  }
}
