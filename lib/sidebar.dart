import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Constant/Service.dart';

class sideBar extends StatefulWidget {
  const sideBar({Key? key}) : super(key: key);
  @override
  State<sideBar> createState() => _sideBarState();
}

class _sideBarState extends State<sideBar> {
  var textStyle = TextStyle(
      color: Colors.deepOrange, fontWeight: FontWeight.w600, fontSize: 20);
  var data;
  String? firstName;
  baseService ser = baseService();
  var chkuserType = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
      chkuserType = await ser.CheckUserType();
      var pref = await SharedPreferences.getInstance();
      firstName = pref.getString("UserFirstName") as String;
      setState(() {

      });
      print(firstName);
    });
  }

  @override
  Widget build(BuildContext context) {
    var mdSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Drawer(
        elevation: 1,
        width: mdSize.width * 0.8,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.black
              // image: DecorationImage(
              //     image: AssetImage(
              //       'images/foodrecipe5.jpg',
              //     ),
              //     fit: BoxFit.cover)
            ),
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                      color: Colors.deepOrange
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 40,
                          child: Text(
                            '${firstName != null ? firstName![0].toUpperCase() : ''}${firstName != null ? firstName![1].toUpperCase() : ''}',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 40),
                          ),
                        ),
                      ),
                      Flexible(
                          child: Container(
                            padding: const EdgeInsets.only(top:10),
                            child: Text(
                              firstName.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800),
                            ),
                          )),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.deepOrange
                    //   gradient: LinearGradient(
                    //       colors: [Colors.deepOrange, Colors.black, Colors.deepOrange]),
                  ),
                  child: Visibility(
                    visible: chkuserType,
                    child: ListTile(
                      title: Text(
                        'Dashboard',
                        style: textStyle,
                      ),
                      leading:
                      Icon(Icons.dashboard, size: 30, color: Colors.white),
                      onTap: () {
                        Navigator.pushNamed(context, '/dashboard');
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 0,
                  height: 2,
                ),
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.deepOrange
                    //   gradient: LinearGradient(
                    //       colors: [Colors.black, Colors.white, Colors.black]),
                  ),
                  child: ListTile(
                    title: Text(
                      chkuserType ? 'Upload Video' : 'All Recipe Video',
                      style: textStyle,
                    ),
                    leading: Icon(Icons.cloud_upload_rounded,
                        size: 30, color: Colors.white),
                    onTap: () {
                      Navigator.pushNamed(context, '/uploadlist');
                    },
                  ),
                ),
                SizedBox(
                  width: 0,
                  height: 2,
                ),
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.deepOrange
                    // gradient: LinearGradient(
                    //     colors: [Colors.black, Colors.white, Colors.black]),
                  ),
                  child: ListTile(
                    title: Text(
                      'Recipes',
                      style: textStyle,
                    ),
                    leading: Icon(Icons.no_food_rounded,
                        size: 30, color: Colors.white),
                    onTap: () {
                      Navigator.pushNamed(context, '/recipelist');
                    },
                  ),
                ),
                SizedBox(
                  width: 0,
                  height: 2,
                ),
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.deepOrange
                    // gradient: LinearGradient(
                    //     colors: [Colors.black, Colors.white, Colors.black]),
                  ),
                  child: ListTile(
                    title: Text(
                      'Recommanded Recipes',
                      style: textStyle,
                    ),
                    leading: Icon(Icons.food_bank_rounded,
                        size: 30, color: Colors.white),
                    onTap: () {
                      Navigator.pushNamed(context, '/recommandedrecipe');
                    },
                  ),
                ),
                SizedBox(
                  width: 0,
                  height: 2,
                ),
                Container(
                  decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //     colors: [Colors.white, Colors.white, Colors.white]),
                  ),
                  child: ListTile(
                    title: Text(
                      'Weekly Plan',
                      style: textStyle,
                    ),
                    leading: Icon(Icons.next_plan_outlined,
                        size: 30, color: Colors.white),
                    onTap: () {
                      Navigator.pushNamed(context, '/weeklyplan');
                    },
                  ),
                ),
                SizedBox(
                  width: 0,
                  height: 2,
                ),
                Container(
                  decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //     colors: [Colors.white, Colors.white, Colors.white]),
                  ),
                  child: ListTile(
                    title: Text(
                      'Favorite',
                      style: textStyle,
                    ),
                    leading: Icon(Icons.favorite_border_outlined,
                        size: 30, color: Colors.white),
                    onTap: () {
                      Navigator.pushNamed(context, '/favorite');
                    },
                  ),
                ),
                SizedBox(
                  width: 0,
                  height: 2,
                ),
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.deepOrange,
                    // gradient: LinearGradient(
                    //     colors: [Colors.white, Colors.white, Colors.white]),
                  ),
                  child: ListTile(
                    title: Text(
                      'Profile',
                      style: textStyle,
                    ),
                    leading: Icon(Icons.supervised_user_circle_rounded, size: 30, color: Colors.white),
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                ),
                SizedBox(
                  width: 0,
                  height: 2,
                ),
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.deepOrange,
                    // gradient: LinearGradient(
                    //     colors: [Colors.white, Colors.white, Colors.white]),
                  ),
                  child: ListTile(
                    title: Text(
                      'Log Out',
                      style: textStyle,
                    ),
                    leading: Icon(Icons.logout, size: 30, color: Colors.white),
                    onTap: ()async {
                      var pref = await SharedPreferences.getInstance();
                      pref.clear();
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
