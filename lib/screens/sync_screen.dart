import 'package:flutter/material.dart';

class SyncScreen extends StatelessWidget {
  static const routeName = '/sync';
  const SyncScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Button Test Screen'),
      ),
      body: Center(
        child: Container(
          child: ElevatedButton(
            onPressed: () => null,
            child: Text("Sync Me"),
          ),
        ),
      ),
    );
  }
}
