/*
 * Solo agregar funciones para manejar archivos
 */
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

//* Comprimidor de imagenes
Future<File> compressImg(File file) async {
  if (file == null) return null;

  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;

  String name = basename(file.path);
  String fileName = 'compress-' + name.split('.')[0];
  String ext = name.split('.').last;

  String finalPath = appDocPath + '/' + fileName + '.' + ext;

  var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, finalPath,
      quality: 70);
  return result;
}