import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyNetworkImage extends StatelessWidget {
  final String imageUrl;

  const MyNetworkImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      imageUrl: imageUrl,
    );
  }
}
