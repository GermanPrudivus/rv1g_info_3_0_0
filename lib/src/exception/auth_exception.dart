import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueSignInUI on AsyncValue {
  void showSnackbarOnError(BuildContext context) {
    if (!isRefreshing && hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(error.toString())
        ),
      );
    }
  }
}
