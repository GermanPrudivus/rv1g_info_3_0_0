import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rv1g_info/src/components/drawer_app_bar_widget.dart';
import 'package:url_launcher/link.dart';

class ContactInfoPage extends StatelessWidget {
  const ContactInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: DrawerAppBarWidget(
          title: "Kontaktinformācija", 
          add: false, 
          navigateTo: Placeholder(), 
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 60.h, left: 50.w, right: 50.w, bottom: 15.h),
                child: Text(
                  'Ja Jums rodas kādas problēmas, droši dodiet mums ziņu!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.h,
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Link (
                      target: LinkTarget.self,
                      uri: Uri.parse('https://www.instagram.com/rv1g_info/'),
                      builder: (context, followLink) => ElevatedButton(
                        onPressed: followLink,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.w)
                          )
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(241, 244, 251, 1),
                            borderRadius: BorderRadius.circular(10.w)
                          ),
                          child: SizedBox(
                            height: 45.h,
                            width: 210.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/Instagram_icon.png',
                                  height: 25.w,
                                  width: 25.w,
                                ),
                                SizedBox(width: 4.h),
                                Text(
                                  'Mūsu Instagram profils',
                                  style: TextStyle(
                                    fontSize: 13.5.h,
                                    color: Colors.black
                                  ),
                                )
                              ],
                            )
                          )
                        )
                      ),
                    )
                  ],
                )
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Link (
                      target: LinkTarget.self,
                      uri: Uri.parse('https://www.facebook.com/RV1Ginfo/'),
                      builder: (context, followLink) => ElevatedButton(
                        onPressed: followLink,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.w)
                          )
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(241, 244, 251, 1),
                            borderRadius: BorderRadius.circular(10.w)
                          ),
                          child: SizedBox(
                            height: 45.h,
                            width: 210.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/2021_Facebook_icon.png',
                                  height: 25.w,
                                  width: 25.w,
                                ),
                                SizedBox(width: 4.h),
                                Text(
                                  'Mūsu Facebook profils',
                                  style: TextStyle(
                                    fontSize: 13.5.h,
                                    color: Colors.black
                                  ),
                                )
                              ],
                            )
                          )
                        )
                      ),
                    )
                  ],
                )
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Column(
                  children: [
                    Text(
                      'Kā arī Jūs varat rakstīt mums uz e-pastu:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.h,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'rv1g.info@gmail.com',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.h,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}