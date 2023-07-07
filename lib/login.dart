import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recipebox/Constant/dialog_helper.dart';

import 'Constant/Service.dart';
import 'Model/LogInModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Model/LoginToken.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  var lastRecord;
  bool showWithlastReord = false;
  var allUser = [];
  bool showIcon = true;
  String email = '';
  String password = '';

  baseService ser = baseService();

  login(BuildContext context) async {
    DialogHelper.showLoading(context);
    var user = LogInModel(Username: email, Password: password, UserType: 2);
    var res = await ser.logInUser(user);
    if (res.statusCode == 200) {
      var pref = await SharedPreferences.getInstance();
      var jsonDecode = json.decode(res.body);
      pref.setString("Token", jsonDecode["token"]);
      var user = jsonDecode["user"];
      pref.setString("UserFirstName", user?["firstName"]);
      pref.setString("UserLasttName", user?["lastName"]);
      pref.setInt("UserType", user?["userType"]);
      pref.setInt("UserId", user?["id"]);
      pref.setString("UserName", user?["username"]);

      print("login");
      DialogHelper.hideLoading(context);
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login successfully'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        onVisible: () async {
          var chkuserType = await ser.CheckUserType();
          if (chkuserType) {
            Navigator.pushNamed(context, '/dashboard', arguments: res.body);
          } else {
            Navigator.pushNamed(context, '/recipelist', arguments: res.body);
          }
        },
        //   ));
        // }
      ));
    } else {
      var errorDecode = json.decode(res.body);
      DialogHelper.hideLoading(context);
      String error = errorDecode["error"][0];
      // print(error["error"]);
      ser.snackBarTextWhileRegiter(context, error, "Error");
      // print(res.body.toString());
    }
    print(res.body);
    print(res.statusCode);
  }

  onIconClick(icon) {
    return IconButton(
        onPressed: () {
          if (this.password.isNotEmpty) {
            setState(() {
              showIcon = !showIcon;
              print(showWithlastReord);
            });
          }
        },
        icon: Icon(icon));
  }

  String errorText = '';

  snackBarText(txt) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${txt} is required'),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 1),
    ));
  }

  validateFields() {
    bool validate = false;

    if (email.isEmpty) {
      snackBarText('User Name');
      validate = true;
    } else if (password.isEmpty) {
      snackBarText('Password');
      validate = true;
    } else if (password.isNotEmpty && errorText.isNotEmpty) {
      validate = true;
    } else {
      validate = false;
    }
    return validate;
  }

  // Future getdata() async {
  //   _database = await openDB();
  //   var result = await table.getUsers(_database);
  //   if (result != null && result.length > 0) {
  //     this.allUser = result;
  //     if (showWithlastReord) {
  //       var indx = result.length - 1;
  //       lastRecord = result[indx];
  //       print(lastRecord);
  //       if (lastRecord != null) {
  //         email = lastRecord['email'] != null ? lastRecord['email'] : '';
  //         password =
  //         lastRecord['password'] != null ? lastRecord['password'] : '';
  //
  //         print(email);
  //         print(password);
  //       }
  //     }
  //   }
  // }

  @override
  void initState() {
    _askingPermission();
    super.initState();
    showWithlastReord = false;
    lastRecord = null;

    if (!showWithlastReord) {
      // this.getdata();
    }
  }

  Future<String> _askingPermission() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      return "Ok";
    } else {
      return "permission denied or undermined";
    }
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.microphone.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.microphone].request();
      return permissionStatus[Permission.microphone] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  renderControls(mdQuery) {
    return Column(
      children: [
        SizedBox(
          height: mdQuery.height * 0.2,
        ),
        Container(
          // child: Text(
          //   style: TextStyle(
          //     color: Color.fromARGB(255, 4, 119, 139),
          //     fontWeight: FontWeight.bold,
          //     fontSize: 60,
          //   ),
          // ),
        ),
        SizedBox(
          height: mdQuery.height * 0.05,
        ),
        Container(
          height: mdQuery.height * 0.25,
          width: mdQuery.width * 0.9,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(9))),
            elevation: 70,
            shadowColor: Color.fromARGB(255, 255, 255, 255),
            child: Column(
              children: [
                Container(
                  width: mdQuery.width * 0.8,
                  child: TextFormField(
                    initialValue: email,
                    decoration: InputDecoration(
                      hintText: 'Enter User Name',
                      prefixIcon: Icon(Icons.supervised_user_circle_sharp),
                    ),
                    onChanged: (val) {
                      email = val;
                    },
                  ),
                ),
                SizedBox(height: mdQuery.height * 0.04),
                Container(
                  width: mdQuery.width * 0.8,
                  child: TextFormField(
                    // controller: password,
                    onChanged: (value) {
                      password = value;
                      if (password.isNotEmpty) {
                        setState(() {
                          if (password.length < 6) {
                            errorText = 'Minimum 6 characters required';
                          } else {
                            errorText = '';
                          }
                        });
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Enter Password',
                        hintText: 'Enter Password',
                        prefixIcon: Icon(Icons.lock_open),
                        suffixIcon: showIcon
                            ? onIconClick(Icons.remove_red_eye_outlined)
                            : onIconClick(Icons.lock),
                        errorText: errorText.isNotEmpty ? errorText : null),
                    obscureText: showIcon,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: mdQuery.height * 0.025,
        ),
        // Container(
        //   child: TextButton(
        //     child: Text(
        //       'Forgot Password?',
        //       style: TextStyle(color: Colors.grey, fontSize: 15),
        //     ),
        //     onPressed: () {},
        //   ),
        // ),
        SizedBox(
          height: mdQuery.height * 0.03,
        ),
        Container(
          width: mdQuery.width * 0.5,
          height: mdQuery.height * 0.06,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 240, 241, 243),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)))),
            child: Text(
              'Login',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color.fromARGB(255, 4, 119, 139)),
            ),
            onPressed: () async {
              //await insertData();
              if (!validateFields()) {
                login(context);
                // Navigator.pushNamed(context, '/dashboard');
              }
              // var login;
              // if (this.allUser != null && this.allUser.length > 0) {
              //   login = this.allUser.where((element) =>
              //   element['password'] == this.password &&
              //       element['email'] == this.email).toList();
              // }
              // print(login);
              // if (login !=null && login.length > 0) {
              //   // lastRecord = null;
              //   // showWithlastReord = false;
              //   print('sucess hiogya h');
              //   Navigator.pushNamed(context, '/dashboard');
              // }
            },
          ),
        ),
        Container(
          child: TextButton(
            child: Text(
              'Create Account',
              style: TextStyle(
                  color:  Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/signUp');
            },
          ),
        ),
        SizedBox(
          height: mdQuery.height * 0.02,
        ),
        // Container(
        //   child: Text(
        //     'Continue with social media',
        //     style: TextStyle(
        //         color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w400),
        //   ),
        // ),
        // SizedBox(
        //   height: mdQuery.height * 0.03,
        // ),
        // Container(
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       Container(
        //         width: mdQuery.width * 0.4,
        //         height: mdQuery.height * 0.07,
        //         child: ElevatedButton(
        //           style: ElevatedButton.styleFrom(shape: StadiumBorder()),
        //           child: Text('Facebook'),
        //           onPressed: () {},
        //         ),
        //       ),
        //       Container(
        //         width: mdQuery.width * 0.4,
        //         height: mdQuery.height * 0.07,
        //         child: ElevatedButton(
        //           style: ElevatedButton.styleFrom(
        //               shape: StadiumBorder(), backgroundColor: Colors.black),
        //           child: Text('Github'),
        //           onPressed: () {},
        //         ),
        //       )
        //     ],
        //   ),
        // )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // var routerArgument = ModalRoute.of(context)?.settings.arguments != null
    //     ? ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>
    //     : null;
    // if (routerArgument != null) {
    //   // print(routerArgument);
    //   showWithlastReord = routerArgument['fromSignIn'];
    //   if (showWithlastReord) {
    //     print('Lo g login chl gya bhia');
    //   }
    // } else {
    //   print('null hgya hgya h');
    //   showWithlastReord = false;
    //   lastRecord = null;
    // }

    var mdQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
            width: double.infinity,
            // color: Colors.deepOrange,
            decoration: BoxDecoration(
                // color: Color.fromARGB(255, 4, 119, 139),
                image: DecorationImage(
                    image: AssetImage('images/Blue Playful Burger Food Logo.gif'),
                    fit: BoxFit.cover
                    )
                    ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20, top: 80),
                    alignment: Alignment.topLeft,
                    height: mdQuery.height * 0.26,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 90,
                                fontWeight: FontWeight.bold),
                                
                          ),
                        ),
                        // Container(
                        //   child: Text('Welcome Back',
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 20,
                        //           fontWeight: FontWeight.w700)),
                        // )
                      ],
                    ),
                  ),
                  Container(
                    child: Container(
                        decoration: BoxDecoration(
                            // color: Color.fromARGB(255, 47, 111, 196),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(70),
                                topRight: Radius.circular(70))),
                        width: double.infinity,
                        child: showWithlastReord
                            ? FutureBuilder(
                                future: null,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    print('print with future');
                                    return renderControls(mdQuery);
                                  }
                                },
                                // future: lastRecord == null ? getdata(): null,
                              )
                            : renderControls(mdQuery)),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
