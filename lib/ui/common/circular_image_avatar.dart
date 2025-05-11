import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:starter_template/utils/extension_functions.dart';

class CircularImageAvatar extends StatelessWidget {
  const CircularImageAvatar({
    super.key,
    required this.avatar,
    this.size = 64.0,
    this.hasStroke = false,
    this.strokeWidth = 2.0,
    this.strokeColor = Colors.white,
    this.onTap,
  });

  /// [avatar] might be url or assets or file path
  final String avatar;
  final double size;
  final bool hasStroke;
  final double strokeWidth;
  final Color strokeColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = hasStroke ? (size / 2) - strokeWidth : size / 2;

    final circleAvatar = CircleAvatar(
      radius: radius,
      backgroundColor: context.theme.cardColor,
      foregroundImage: avatar.isUrl
          ? CachedNetworkImageProvider(avatar)
          : avatar.isFilePath
              ? FileImage(File(avatar))
              : avatar.startsWith("assets/")
                  ? AssetImage(avatar)
                  : null,
    );

    return GestureDetector(
      onTap: onTap,
      child: hasStroke
          ? Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size),
                border: Border.all(
                  width: strokeWidth,
                  color: strokeColor,
                ),
              ),
              child: Center(
                child: circleAvatar,
              ),
            )
          : circleAvatar,
    );
  }
}
