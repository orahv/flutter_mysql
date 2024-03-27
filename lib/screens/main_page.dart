import 'package:flutter/material.dart';
import 'package:flutter_project/dump_page/pageOne.dart';
import 'package:flutter_project/dump_page/pagerTwo.dart';
import 'package:flutter_project/dump_page/pagethree.dart';
import 'package:flutter_project/dump_page/mini_menu.dart';
import 'package:flutter_project/screens/login.dart';
import 'package:flutter_project/screens/qr_screens/displaydata.dart';
import 'package:flutter_project/screens/qr_screens/generatepage.dart';
import 'package:flutter_project/screens/qr_screens/scanpage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Main Menu',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => DisplayDataPage()));
                  },
                  child: Text('Display Data')),
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (builder) => ScanPage()));
                  },
                  child: Text('QR Scan')),
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => GeneratePage()));
                  },
                  child: Text('QR Generate')),
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (builder) => Tes()));
                  },
                  child: Text('Logout')),
            ),
          ],
        ),
      ),
    );
  }
}
