import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:rv1g_info/src/constants/theme.dart';
import 'package:rv1g_info/src/features/authentication/presentation/components/button.dart';
import 'package:rv1g_info/src/features/authentication/presentation/components/text_form.dart';
import 'package:rv1g_info/src/features/authentication/presentation/controllers/sign_in_controller.dart';
import 'package:rv1g_info/src/features/authentication/presentation/state/sign_in_state.dart';
import 'package:rv1g_info/src/utils/auth_exception.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool notVisibility = ref.watch(notVisibleProvider);

    ref.listen<AsyncValue>(
      signInScreenControllerProvider,
      (_, state) {
        if(state.isLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator(color: onBackground))
          );
        } else {
          context.pop();
        }
        state.showSnackbarOnError(context);
      }
    );

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.only(left: 25.w, right: 25.w),
            child: Column(
              children: [
                SizedBox(height: 70.h),
                SvgPicture.asset(
                  "assets/login.svg",
                  height: 150.h,
                ),
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Autorizējies",
                      style: TextStyle(
                        fontSize: 30.w,
                        color: onBackground,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                  ],
                ),
                SizedBox(height: 25.h),
                TextForm(
                  value: ref.watch(emailProvider), 
                  hintText: "E-pasts", 
                  onChanged: (value) => ref.read(emailProvider.notifier).state = value.trim(), 
                  onValidated: (value) => ref.read(hasValidEmailProvider.notifier).state = value
                ),
                SizedBox(height: 10.h),
                TextForm(
                  value: ref.watch(passwordProvider), 
                  hintText: "Parole", 
                  onChanged: (value) => ref.read(passwordProvider.notifier).state = value.trim(), 
                  onValidated: (value) => ref.read(hasValidPasswordProvider.notifier).state = value,
                  visible: notVisibility,
                  suffix: GestureDetector(
                    onTap: () {
                      setState(() {
                        if(notVisibility == false) {
                          ref.read(notVisibleProvider.notifier).state = true;
                        } else {
                          ref.read(notVisibleProvider.notifier).state  = false;
                        }
                      });
                    },
                    child: Icon(notVisibility
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                      color: surface,
                      size: 20.r,
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => context.push('/authentication/forgot-password'),
                      child: Container(
                        height: 30.h,
                        width: 140.w,
                        alignment: Alignment.center,
                        child: Text(
                          "Aizmirsi paroli?",
                          style: TextStyle(
                            color: onBackground, 
                            fontSize: 14.w
                          ),
                        )
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20.h),
                Button(
                  text: "Autorzēties",
                  onPressed: () {
                    if(ref.read(hasValidEmailProvider) && ref.read(hasValidPasswordProvider)){
                      ref
                        .read(signInScreenControllerProvider.notifier)
                        .signIn(ref.read(emailProvider), ref.read(passwordProvider))
                        .whenComplete(() => context.pushReplacement('/'));
                    }
                  },
                ),
                SizedBox(height: 12.5.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 1.h,
                        width: 1.sw/3.5,
                        color: lightGrey,
                      ),
                      Text(
                        "VAI",
                        style: TextStyle(
                          fontSize: 15.w, 
                          color: lightGrey
                        ),
                      ),
                      Container(
                        height: 1.h,
                        width: 1.sw/3.5,
                        color: lightGrey,
                      ),
                    ]
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Jauns skolēns?",
                      style: TextStyle(
                        fontSize: 15.w, 
                        color: lightGrey
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/authentication/sign-up'),
                      child: Container(
                        height: 27.5.h,
                        width: 100.w,
                        alignment: Alignment.center,
                        child: Text(
                          "Reģistrēties",
                          style: TextStyle(
                            color: onBackground, 
                            fontSize: 15.w
                          ),
                        )
                      ),
                    ),
                  ]
                ),
              ],
            ),
          )
        )
      )
    );
  }
}
