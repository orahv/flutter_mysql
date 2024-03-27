// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class pagethree extends StatefulWidget {
  const pagethree({super.key});

  @override
  State<pagethree> createState() => _pagethreeState();
}

class _pagethreeState extends State<pagethree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text('Page One'),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      leading: Icon(Icons.abc),
      centerTitle: true,
      titleTextStyle: TextStyle(color: Colors.blue, fontSize: 24),
      actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
    ));
  }
}
