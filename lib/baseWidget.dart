import 'package:flutter/material.dart';
import 'package:recipebox/sidebar.dart';

class baseWidget extends StatefulWidget {
  // const baseWidget({Key? key}) : super(key: key);

  final String menuTitle;
  final Widget showWidget;
  final Widget? floating;

  baseWidget(
      {required this.menuTitle, required this.showWidget, this.floating});

  @override
  State<baseWidget> createState() => _baseWidgetState();
}

class _baseWidgetState extends State<baseWidget> {
  dynamic userInfo;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.deepOrange,
        title: Text(
          this.widget.menuTitle,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.supervised_user_circle_sharp),
            onPressed: (){
              Navigator.pushNamed(context, '/profile');
            },
          )
        ],
      ),
      drawer: sideBar(),
      body: SafeArea(
        child: this.widget.showWidget,
      ),
      floatingActionButton: this.widget.floating,
    );
  }
}
