// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_project/screens/login.dart';
import 'package:flutter_project/screens/qr_screens/displaydata.dart';
import 'package:flutter_project/screens/qr_screens/generatepage.dart';
import 'package:flutter_project/screens/qr_screens/scanpage.dart';

class Tes extends StatefulWidget {
  const Tes({super.key});

  @override
  State<Tes> createState() => _TesState();
}

class _TesState extends State<Tes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landing Page'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: 250,
              width: 250,
              child: Image.asset("assets/images/menu.png"),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  caption: 'Item List',
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => DisplayDataPage()));
                  },
                  imgAssetPath: ("assets/images/list.png"),
                ),
                CustomButton(
                  caption: 'Scan QR',
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (builder) => ScanPage()));
                  },
                  imgAssetPath: ("assets/images/scan.png"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  caption: 'Generate QR',
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => GeneratePage()));
                  },
                  imgAssetPath: ("assets/images/qr.png"),
                ),
                CustomButton(
                  caption: 'Logout',
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (builder) => LoginPage()));
                  },
                  imgAssetPath: ("assets/images/logout.png"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatefulWidget {
  const CustomButton({
    Key? key,
    required this.caption,
    required this.onPressed,
    required this.imgAssetPath, // Image asset path
  }) : super(key: key);

  final String caption;
  final VoidCallback onPressed;
  final String imgAssetPath; // Image asset path

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: InkWell(
          onTap: widget.onPressed,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                width: 1,
                color: Color.fromARGB(255, 25, 7, 187),
                style: BorderStyle.solid,
              ),
              color: _isHovered
                  ? Color.fromARGB(255, 100, 220, 241)
                  : null, // Change background color on hover
              image: DecorationImage(
                image: AssetImage(
                    widget.imgAssetPath), // Use AssetImage for local assets
                fit: BoxFit.fitHeight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.caption,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
