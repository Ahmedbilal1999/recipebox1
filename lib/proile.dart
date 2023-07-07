import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'baseWidget.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  TextStyle lbel = TextStyle(
      color: Colors.deepOrange, fontSize: 24, fontWeight: FontWeight.bold);

  TextStyle txt =
      TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500);

  String? firstName;
  String? lastName;
  String? userName;
  int? userType;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var pref = await SharedPreferences.getInstance();
      firstName = pref.getString("UserFirstName") as String;
      lastName = pref.getString("UserLasttName") as String;
      userType = pref.getInt("UserType") as int?;
      userName = pref.getString("UserName") as String;
      setState(() {});
      print(firstName);
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    var mdSize = MediaQuery.of(context).size;
    return baseWidget(
      menuTitle: 'Profile',
      showWidget: Container(
        height: mdSize.height * 0.8,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 62),
                  height: mdSize.height * 0.6,
                  width: mdSize.width * double.infinity,
                  child: Card(
                      elevation: 40,
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        padding: const EdgeInsets.only(top: 65, left: 20),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'FirstName',
                                    style: lbel,
                                  ),
                                ),
                                SizedBox(
                                  height: mdSize.height * 0.04,
                                ),
                                Container(
                                  child: Text(
                                    'LastName',
                                    style: lbel,
                                  ),
                                ),
                                SizedBox(
                                  height: mdSize.height * 0.04,
                                ),
                                Container(
                                  child: Text(
                                    'UserName',
                                    style: lbel,
                                  ),
                                ),
                                SizedBox(
                                  height: mdSize.height * 0.04,
                                ),
                                Container(
                                  child: Text(
                                    'User Type',
                                    style: lbel,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              width: mdSize.width * 0.13,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    firstName.toString(),
                                    style: txt,
                                  ),
                                ),
                                SizedBox(
                                  height: mdSize.height * 0.04,
                                ),
                                Container(
                                  child: Text(
                                    lastName.toString(),
                                    style: txt,
                                  ),
                                ),
                                SizedBox(
                                  height: mdSize.height * 0.04,
                                ),
                                Container(
                                  child: Text(
                                    userName.toString(),
                                    style: txt,
                                  ),
                                ),
                                SizedBox(
                                  height: mdSize.height * 0.04,
                                ),
                                Container(
                                  child: Text(
                                    (userType != null && userType == 2
                                        ? 'User'
                                        : userType != null && userType == 1
                                            ? 'Admin'
                                            : ''),
                                    style: txt,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    backgroundColor: Colors.deepOrange,
                    radius: 60,
                    child: Text(
                      '${firstName != null ? firstName![0].toUpperCase() : ''}${firstName != null ? firstName![1].toUpperCase() : ''}',

                      ///'${firstName != null ? firstName![0].toUpperCase() : ''}${firstName != null ? firstName![1].toUpperCase() : ''}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 40),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
