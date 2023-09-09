import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rv1g_info/main.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/theme_colors.dart';

class VerificationPage extends StatefulWidget {
  final String fullName;

  const VerificationPage({
    required this.fullName,
    super.key
  });

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> with WidgetsBindingObserver{
  bool _isPermissionGranted = false;
  CameraController? _cameraController;
  final textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }
  
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
                    text: "Horizontāli nofotografējat Jūsas Rīgas Skolēna kartes aizmuguri! <b>Izdarot to, Jūs atļaujat apstrādāt datus no Jūsu dokumenta!</b>",
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
                      ),
                      alignment: Alignment.center,
                      height: _isPermissionGranted
                        ? 400.h
                        : 320.h,
                      child: _isPermissionGranted
                        ? FutureBuilder<List<CameraDescription>>(
                            future: availableCameras(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                _initCameraController(snapshot.data!);
                                return Center(child: CameraPreview(_cameraController!));
                              } else {
                                return CircularProgressIndicator(color: blue);
                              }
                            },
                          )
                        : Text(
                            "Atļaujiet pieeju Jūsu telefona kamerai, lai turpināt!",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20.w
                            ),
                            textAlign: TextAlign.center,
                          )
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: ElevatedButton(
                    onPressed: _scanImage,
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

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _isPermissionGranted = status == PermissionStatus.granted;
    });
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    // Select the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    await _cameraController!.setFlashMode(FlashMode.off);
    await _cameraController!.setFocusMode(FocusMode.locked);

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _scanImage() async {
    if (_cameraController == null) return;

    try {
      final pictureFile = await _cameraController!.takePicture();

      final file = File(pictureFile.path);

      final inputImage = InputImage.fromFile(file);
      final recognizedText = await textRecognizer.processImage(inputImage);

      String text = recognizedText.text.toLowerCase();
      List<String> fullname = widget.fullName.split(" ");

      if(
        text.contains(fullname[0].toLowerCase()) &&
        text.contains(fullname[1].toLowerCase()) &&
        (
          text.contains("rigas valsts 1. gimn.") ||
          text.contains("rīgas valsts 1. gimn.") ||
          text.contains("rīgas valsts 1. ģimn.") ||
          text.contains("rigas valsts 1. ģimn.") ||
          text.contains("rigas valsts 1, gimn.") ||
          text.contains("rigas valsts 1, gimn") 
        )
      ){
        verifyUser().whenComplete(() {
          showDialog(
            context: context, 
            builder: (context) => FinishVerification(context),
            barrierDismissible: false,
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Kaut kas sagāja greizi! Pamēģiniet vēlreiz!'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Kaut kas sagāja greizi! Pamēģiniet vēlreiz!'),
        ),
      );
    }
  }

  Future<void> verifyUser() async {
    final supabase = Supabase.instance.client;

    final email = await supabase.auth.currentUser!.email;

    await supabase
      .from('users')
      .update({
        'verified':true
      })
      .eq('email', email);
  }

  Widget FinishVerification(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
		    borderRadius: BorderRadius.circular(15.h),
	    ),
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Container(
          width: 1.sw,
          alignment: Alignment.topLeft,
          color: Colors.white,
          margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 30.h, bottom: 30.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      "Jūs esat veiksmīgi verificējušies! Tagad Jums ir pieejams viss lietotnes funkcionāls!",
                      style: TextStyle(
                        fontSize: 17.w,
                        color: blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              SizedBox(height: 15.h),
              CircleAvatar(
                radius: 40.w,
                backgroundColor: blue,
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                  size: 40.w,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.h, left: 30.w, right: 30.w),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => false);
                    Navigator.push(
                      context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage()
                        )
                    );
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
                    "Sapratu",
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
      )
    );
  }
}