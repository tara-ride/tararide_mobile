import 'package:flutter/material.dart';

// ignore: must_be_immutable
final class SampleChildWidget extends StatelessWidget {
  String hello;

  SampleChildWidget({super.key, required this.hello});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Text(hello),
      onPressed: () {
        hello = "Hi!";
      },
    );
  }
}
