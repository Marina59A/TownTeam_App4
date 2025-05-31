// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

void snackShow(BuildContext context, String Message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(Message),
    ),
  );
}
