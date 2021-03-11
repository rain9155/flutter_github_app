
import 'package:flutter/material.dart';

/// 可以实现圆角图片的widget
class RoundedImage extends StatelessWidget{

  RoundedImage.asset(String assetName, {
    this.width,
    this.height,
    this.radius,
    this.fit,
    this.loadingBuilder,
    this.errorBuilder
  }) : this.image = AssetImage(assetName);

  RoundedImage.network(String url, {
    this.width,
    this.height,
    this.radius,
    this.fit,
    this.loadingBuilder,
    this.errorBuilder
  }) : this.image = NetworkImage(url);

  final double width;

  final double height;

  final double radius;

  final BoxFit fit;

  final ImageProvider image;

  final ImageLoadingBuilder loadingBuilder;

  final ImageErrorWidgetBuilder errorBuilder;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: Image(
        image: image,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: loadingBuilder,
        errorBuilder: errorBuilder,
      ),
    );
  }

}