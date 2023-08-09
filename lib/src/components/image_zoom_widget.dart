import 'package:flutter/material.dart';

Widget buildImageZoom(BuildContext context, String url) {
  return AlertDialog(
    backgroundColor: Colors.transparent,
    contentPadding: EdgeInsets.zero,
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InteractiveViewer(
            child: Image.network(
              url,
              fit: BoxFit.fill,
            )
          )
        ],
      ),
    )
  );
}