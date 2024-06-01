import 'package:flutter/material.dart';

void showDialogMsg(BuildContext mainContext, String? errorMessage,
    {String title = 'Error'}) {
  showAdaptiveDialog(
    context: mainContext,
    builder: (context) => AlertDialog(
      scrollable: true,
      title: Text(title),
      content: Text(errorMessage ?? 'Terjadi sebuah kesalahan'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.secondary,
          ),
          child: Text(
            "Close",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    ),
  );
}

void showDialogInfo(BuildContext mainContext, Function onYes,
    {String title = 'Info',
    String message = 'Success',
    String errorBtn = 'Ok'}) {
  showAdaptiveDialog(
    context: mainContext,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onYes();
            },
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary),
            child: Text(errorBtn),
          ),
        ],
      );
    },
  );
}

void showDialogConfirmation(
  BuildContext mainContext,
  Function onPositive, {
  String title = 'Confirmation',
  String message = 'Are you sure you want to delete this data?',
  String positiveText = 'Konfirmasi',
  String minusText = 'Batal',
  ButtonStyle? buttonStyle1,
  ButtonStyle? buttonStyle2,
}) {
  showAdaptiveDialog(
    context: mainContext,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            style: buttonStyle1 ??
                TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.outline),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(minusText),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onPositive();
            },
            style: buttonStyle2 ??
                TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error),
            child: Text(positiveText),
          ),
        ],
      );
    },
  );
}

showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}
