import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String text;
  const ErrorView({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text),
    );
  }
}
