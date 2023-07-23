import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EklasePage extends ConsumerStatefulWidget {
  const EklasePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EklasePageState();
}

class _EklasePageState extends ConsumerState<EklasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Text(
                "Eklase Page",
                style: TextStyle(
                  fontSize: 24.h
                ),
              ),
            )
          ]
        ),
      ),
    );
  }
}