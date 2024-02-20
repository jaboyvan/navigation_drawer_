import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profiles'),
      ),
      body: Center(
        child: Text(
          'Profile Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
