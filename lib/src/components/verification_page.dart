import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

import '../constants/theme_colors.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          splashRadius: 0.01,
          icon: Icon(
            Icons.chevron_left,
            color: blue, 
            size: 34.h,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 60.h,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      "Verificēšana:",
                      style: TextStyle(
                        fontSize: 22.h,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.only(left: 2.w, right: 2.w),
                  child: StyledText(
                    text: "Nofotografējat Jūsas Rīgas Skolēna kartes aizmuguri! <b>Izdarot to, Jūs atļaujat apstrādāt datus no Jūsu dokumenta!</b>",
                    style: TextStyle(
                      fontSize: 16.w,
                      color: blue
                    ),
                    textAlign: TextAlign.center,
                    tags: {
                      'b': StyledTextTag(style: const TextStyle(fontWeight: FontWeight.bold)),  
                    },
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Jūsu kartes fotogrāfija un informācija no tās netiek nekur glabāta, un tā tiek izmantota tikai vienreizēji!",
                  style: TextStyle(
                    fontSize: 14.w,
                    color: Colors.red
                  ),
                  textAlign: TextAlign.center,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 5.h, bottom: 10.h),
                      decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(15.h),
                        color: Colors.grey.shade400,
                      ),
                      height: 350.h,
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: ElevatedButton(
                    onPressed: () {
                      
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(1.sw, 50.h),
                      backgroundColor: blue,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.h)
                      )
                    ),
                    child: Text(
                      "Nofotografēt",
                      style: TextStyle(
                        fontSize: 17.w,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}