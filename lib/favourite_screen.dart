import 'package:flutter/material.dart';

class Favourite extends StatelessWidget {
  const Favourite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite bar'),
      ),
      body: Center(
        child: Text('Favourite User Screen'),
      ),
    );
  }
}
