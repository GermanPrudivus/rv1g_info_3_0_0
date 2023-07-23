import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/theme_colors.dart';

class AddSchoolNewsPage extends ConsumerStatefulWidget {
  final bool edit;
  final String text;
  final bool pin;
  final int poll;
  final List<String> images;

  const AddSchoolNewsPage({
    super.key,
    required this.edit,
    required this.text,
    required this.pin,
    required this.poll,
    required this.images
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddSchoolNewsPageState();
}

class _AddSchoolNewsPageState extends ConsumerState<AddSchoolNewsPage> {

  late String text;

  late bool pin;

  @override
  Widget build(BuildContext context) {

    text = widget.text;
    pin = widget.pin;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          size: 28.h,
          color: blue
        ),
        toolbarHeight: 60.h,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.edit
                      ? "Rediģēt ziņu:"
                      : "Pievienot ziņu:",
                      style: TextStyle(
                        fontSize: 22.h,
                      ),
                    ),
                  ],
                ),
              
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5.w),
                        child: Text(
                          "Teksts",
                          style: TextStyle(
                            fontSize: 14.h,
                          ),
                        ),
                      ),
                      TextFormField(
                        initialValue: text,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          fontSize: 14.h
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 2.h,
                              color: Colors.black
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 2.h,
                              color: blue
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Ieraksti ziņas tekstu',
                          hintStyle: TextStyle(
                            fontSize: 14.h
                          )
                        ),
                        minLines: 25,
                        maxLines: 1000,
                        onChanged: (value) {
                          setState(() {
                            text = value;
                          });
                        },
                      ),
                    ],
                  )
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Text(
                    '<b></b> - lai uztaisītu bold tekstu\n<u></u> - lai pasvītrotu tekstu\n<i></i> - lai uztaisītu italic tekstu\n<link href="your_link"></link> - lai pievienotu saiti',
                    style: TextStyle(
                      fontSize: 14.h
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Row(
                    children: [
                      Checkbox(
                        value: pin,
                        checkColor: Colors.white,
                        activeColor: blue,
                        side: BorderSide(
                          width: 1.h,
                          color: blue
                        ),
                        onChanged: (value) {
                          setState(() {
                            pin = value!;
                          });
                        }
                      ),
                      Text(
                        "Piestiprināt ziņu augšā",
                        style: TextStyle(
                          fontSize: 14.h,
                        ),
                      )
                    ],
                  ),
                ),

                Text(
                  "Peivienot aptauju:",
                  style: TextStyle(
                    fontSize: 14.h
                  ),
                ),

                if(widget.poll == 0)
                  GestureDetector(
                    child: Container(
                      color: Colors.white,
                      height: 80.h,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 30.h,
                            color: Colors.black38,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "Pievienot aptauju",
                            style: TextStyle(
                              fontSize: 14.h,
                              color: Colors.black45
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
  
                    },
                  ),
 
                Text(
                  "Peivienot attēlu:",
                  style: TextStyle(
                    fontSize: 14.h
                  ),
                ),
                
                if(widget.images.isNotEmpty)
                  SizedBox(height: 10.h,),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.images.length,
                    itemBuilder: (context, index) {
                      return Image.network(widget.images[index]);
                    }
                  ),

                GestureDetector(
                  child: Container(
                    color: Colors.white,
                    height: widget.images.isEmpty
                      ? 100.h
                      : 80.h,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 30.h,
                          color: Colors.black38,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "Pievienot attēlu",
                          style: TextStyle(
                            fontSize: 14.h,
                            color: Colors.black45
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {

                  },
                ),

                //Button
                Padding(
                  padding: EdgeInsets.only(top: 20.h, bottom: 30.h),
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
                      widget.edit 
                      ? "Rediģēt ziņu"
                      : "Pievienot ziņu",
                      style: TextStyle(
                        fontSize: 16.h,
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