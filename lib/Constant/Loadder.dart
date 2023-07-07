import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final double loaderSize;
  const Loader({
  this.loaderSize = 40,
  super.key,
});

@override
Widget build(BuildContext context) {
  return Center(
    child: Column(
      children: [
        Container(
          child: Text('Please Wait...'),
        ),
        Image.asset(
          'images/double_ring_loading_io.gif',
          height: loaderSize,
        )
      ],
    ),
  );
}
}
