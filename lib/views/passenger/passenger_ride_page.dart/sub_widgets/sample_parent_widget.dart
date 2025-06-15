import 'package:flutter/material.dart';

import 'sample_child_widget.dart';

class SampleParentWidget extends StatefulWidget {
  const SampleParentWidget({super.key});

  @override
  State<StatefulWidget> createState() => _SampleParentWidgetState();
}

class _SampleParentWidgetState extends State {
  String hello = "Hello";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SampleChildWidget(
      hello: hello,
    );
  }
}
