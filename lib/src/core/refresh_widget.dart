import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/theme_colors.dart';

class RefreshWidget extends StatefulWidget {
  final Widget child;
  final Future Function() onRefresh;

  const RefreshWidget({
    Key? key,
    required this.child,
    required this.onRefresh
  }) : super(key: key);

  @override
  State<RefreshWidget> createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid) {
      return buildAndroidList();
    }else{
      return buildIOSList();
    }
  }

  Widget buildAndroidList() => RefreshIndicator(
    onRefresh: widget.onRefresh,
    color: blue,
    child: widget.child,
  );

  Widget buildIOSList() => CustomScrollView(
    physics: const BouncingScrollPhysics(),
    slivers: [
      CupertinoSliverRefreshControl(
        onRefresh: widget.onRefresh,
      ),
      SliverToBoxAdapter(child: widget.child)
    ],
  );
}