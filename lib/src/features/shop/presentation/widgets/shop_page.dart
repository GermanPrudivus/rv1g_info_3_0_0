import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/components/app_bar_widget.dart';

import '../../../../constants/theme_colors.dart';
import '../../domain/models/item.dart';

class ShopPage extends ConsumerStatefulWidget {
  final bool isAdmin;

  const ShopPage({
    required this.isAdmin,
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage> {
  List<Item> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBarWidget(
          title: "Veikals", 
          add: widget.isAdmin, 
          navigateTo: AboutDialog(),
          showDialog: false,
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            items.isEmpty
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: blue),
                  ),
                )
              : Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {},
                    child: ListView.builder(
                      itemCount: items.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container();
                      }
                    ),
                  ),
                )
          ],
        ),
      )
    );
  }
}