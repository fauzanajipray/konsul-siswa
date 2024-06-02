import 'package:flutter/material.dart';

class ErrorDataNotFoundPage extends StatefulWidget {
  const ErrorDataNotFoundPage(this.errMsg, {super.key});

  final String? errMsg;
  @override
  State<ErrorDataNotFoundPage> createState() => _ErrorDataNotFoundPageState();
}

class _ErrorDataNotFoundPageState extends State<ErrorDataNotFoundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Text(
          widget.errMsg ?? 'Data Not Found',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
