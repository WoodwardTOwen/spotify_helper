import 'package:flutter/material.dart';

class SyncScreen extends StatelessWidget {
  static const routeName = '/sync';
  SyncScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Button Test Screen'),
      ),
      body: Center(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
