import 'package:flutter/material.dart';
import 'package:recipebox/Constant/Loadder.dart';

class DialogHelper {
  //show error dialog

  static void showLoading(BuildContext context, [String? message]) {
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Loader(),
                  SizedBox(height: 8),
                  Text(message ?? 'Loading...'),
                ],
              ),
            ),
          );
        });
  }

  static void hideLoading(BuildContext context) {
    Navigator.of(context).pop();
  }
}
