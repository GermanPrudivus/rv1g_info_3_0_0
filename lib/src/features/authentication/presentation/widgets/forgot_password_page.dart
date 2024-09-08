import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rv1g_info/src/constants/theme.dart';
import 'package:rv1g_info/src/features/authentication/presentation/components/button.dart';
import 'package:rv1g_info/src/features/authentication/presentation/components/text_form.dart';
import 'package:rv1g_info/src/features/authentication/presentation/controllers/forgot_password_page.dart';
import 'package:rv1g_info/src/features/authentication/presentation/state/forgot_password_state.dart';
import 'package:rv1g_info/src/utils/auth_exception.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    ref.listen<AsyncValue>(
      forgotPasswordScreenControllerProvider,
      (_, state) {
        if(state.isLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator(color: onBackground))
          );
        } else if (state.asData == null){
          context.pop();
        } else {
          context.pop();
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
          child: Padding(
            padding: EdgeInsets.only(top: 20.h, left: 25.w, right: 25.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Icon(
                        Icons.chevron_left,
                        color: onBackground, 
                        size: 34.h,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 70.h),
                SizedBox(
                  height: 180.h,
                  child: SvgPicture.asset('assets/forgot_password.svg'),
                ),
                SizedBox(height: 40.h),
                Row(
                  children: [
                    Text(
                      "Aizmirsi paroli?",
                      style: TextStyle(
                        fontSize: 30.w,
                        color: onBackground,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  "Neuztraucies! Tas gadās. Lūdzu ievadi e-pastu, ar kuru tika reģistrēts profils!",
                  style: TextStyle(
                    fontSize: 15.w,
                    color: surface,    
                  )
                ),
                SizedBox(height: 25.h),
                TextForm(
                  value: ref.watch(emailProvider), 
                  hintText: "E-pasts", 
                  onChanged: (value) => ref.read(emailProvider.notifier).state = value.trim(), 
                  onValidated: (value) => ref.read(hasValidEmailProvider.notifier).state = value
                ),
                SizedBox(height: 40.h),
                Button(
                  text: "Nosūtīt e-pastu", 
                  onPressed: () {
                    ref
                      .read(forgotPasswordScreenControllerProvider.notifier)
                      .resetPassword(emailController.text);
                  }
                )
              ],
            ),
          )
        )
      )
    );
  }
}