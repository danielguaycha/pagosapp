import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget imageNet(String src) {
  return CachedNetworkImage(
    progressIndicatorBuilder: (context, url, progress) =>
        CircularProgressIndicator(
      value: progress.progress,
    ),
    errorWidget: (context, url, error) => new Icon(Icons.error),
    imageUrl:src,
  );
}
