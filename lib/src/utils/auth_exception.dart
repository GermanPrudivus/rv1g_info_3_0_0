import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rv1g_info/src/exceptions/exceptions.dart';

extension AsyncValueSignInUpUI on AsyncValue {
  void showSnackbarOnError(BuildContext context) {
    if (!isRefreshing && hasError) {

      String? displayedError = authExceptions[error.toString()];
      
      displayedError ??= error.toString();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(displayedError)
        ),
      );
    }
  }
}
