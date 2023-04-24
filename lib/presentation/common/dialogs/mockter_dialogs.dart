import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context,
    {String title = 'Ocurrio un error',
    String description = 'Ocurrio un error',
    String buttonRight = 'Close'}) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            title,
          ),
          content: Text(description),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(_).pop();
                },
                child: Text(buttonRight))
          ],
        );
      });
}
