import 'package:flutter/material.dart';

void showDialogMsg(BuildContext mainContext, String errorMessage,
    {String title = 'Error'}) {
  showAdaptiveDialog(
    context: mainContext,
    builder: (context) => AlertDialog(
      scrollable: true,
      title: Text(title),
      content: Text(errorMessage),
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

void showDialogConfirmationDelete(
  BuildContext mainContext,
  Function onDelete, {
  String title = 'Confirmation',
  String message = 'Are you sure you want to delete this data?',
  String errorBtn = 'Delete',
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
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
            style: buttonStyle2 ??
                TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error),
            child: Text(errorBtn),
          ),
        ],
      );
    },
  );
}
