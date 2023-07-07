import 'dart:async';

import 'package:flutter/material.dart';

class splashScreeen extends StatefulWidget {
  const splashScreeen({Key? key}) : super(key: key);

  @override
  State<splashScreeen> createState() => _splashScreeenState();
}

class _splashScreeenState extends State<splashScreeen> {
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushNamed(
              context,
              '/login',
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: Image.asset(
                'images/Beige Modern Food Logo.gif',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: RichText(
                  text: TextSpan(
                //text: 'Recipe Box',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.w900,
                    ),
              )),
            )
          ],
        ),
      ),
    );
  }
}
