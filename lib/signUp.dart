import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipebox/Model/LogInModel.dart';

import 'Constant/Service.dart';

class signUp extends StatefulWidget {
  const signUp({Key? key}) : super(key: key);

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  // Database? _database;
  //
  // Future<Database?> openDBConnection() async {
  //   _database = await DataBasseHandler().openDB();
  //   // table.createTable(_database);
  //   return _database;
  // }
  //
  // SignUpTable table = new SignUpTable();
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  bool showLoader = false;

  String errorText = '';

  baseService ser = baseService();

  // bool validationShow = false;

  registerUser() async {
    var user = LogInModel(
        FirstName: firstName,
        LastName: lastName,
        Username: email,
        Password: password,
        UserType: 2);
    var res = await ser.registerUser(user);
    if (res.statusCode == 200) {
      print(res.body);
      // ser..snackBarTextWhileRegiter(context,'User successfully created',"Success");
      //   CircularProgressIndicator(value: 0.0);
      // Timer(
      //     Duration(seconds: 1),
      //         (){
           return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('User Registered successfully'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
              onVisible: (){
                Navigator.pushNamed(
                  context,
                  '/login',
                );
              },
      ));
    } else {
      // CircularProgressIndicator(value: 0.0);
      var error = json.decode(res.body);
      print(error);
      ser.snackBarTextWhileRegiter(context, res.body, "Error");
      // print(res.body.toString());
    }
    print(res.body);
    print(res.statusCode);
  }

  snackBarText(txt) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${txt} is required'),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 1),
    ));
  }

  validateFields() {
    bool validate = false;

    if (firstName.isEmpty) {
      snackBarText('First Name');
      validate = true;
    } else if (lastName.isEmpty) {
      snackBarText('Last Name');
      validate = true;
    } else if (email.isEmpty) {
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

  // Future<void> inserData() async {
  //   this.showLoader = false;
  //   _database = await openDBConnection();
  //
  //   // table.createTable(_database);
  //
  //   SignUpModel model = new SignUpModel(
  //     firstName,
  //     lastName,
  //     email,
  //     password,
  //   );
  //
  //   var res = await _database?.insert(TablesName().signUptable, model.toMap());
  //   if (res != null && res > 0) {
  //     print("Save Response ${res}");
  //     this.showLoader = true;
  //   }
  //
  //   await _database?.close();
  // }

  var usersList = [];
  // Future<void> getAllUsers() async {
  //   this.showLoader = false;
  //   var res = await table.getUsers(_database);
  //
  //   print('Length of user while creating account ${res.length}');
  //   if (res.isNotEmpty && res.length > 0) {
  //     this.usersList = res;
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool showIcon = true;

  onClickIcon(icon) {
    return IconButton(
        onPressed: () {
          if (password.isNotEmpty) {
            setState(() {
              showIcon = !showIcon;
            });
          }
        },
        icon: Icon(icon));
  }

  @override
  Widget build(BuildContext context) {
    var mdSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
            color: Color.fromARGB(255, 4, 119, 139),
            child: Column(
              children: [
                Container(
                  height: mdSize.height * 0.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: mdSize.height * 0.25,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            // height: mdSize.height * 0.1,
                            // width: mdSize.width * 0.2,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                            // child: CircleAvatar(
                            //   radius: 400,
                            //   child: CircleAvatar(
                            //     radius: 50,
                            //     // backgroundImage: AssetImage(
                            //     //   // 'images/Blue Playful Burger Food Logo.gif',
                            //     // ),
                            //   ),
                            // ),
                          ),
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          'images/Blue Playful Burger Food Logo.gif',
                          // width: 500,
                          // height: 500,
                        ),
                      ),
                      Transform.rotate(
                        angle: 230,
                        // child: Container(
                        //   height: mdSize.height * 0.2,
                        //   width: mdSize.width * 0.23,
                        //   decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius: BorderRadius.only(
                        //           topRight: Radius.circular(70),
                        //           bottomRight: Radius.circular(20))),
                        //   child: Align(
                        //       alignment: Alignment.center,
                        //       child: RotatedBox(
                        //           quarterTurns: 1,
                        //           // child: Text(
                        //           //   // 'Recipe Box',
                        //           //   style: TextStyle(
                        //           //       color: Colors.black,
                        //           //       fontSize: 20,
                        //           //       fontWeight: FontWeight.w900),
                        //           // )
                        //           )),
                        // ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    // height:mdSize.height * 0.7,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 15, 84, 195),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                'Registration',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 4, 119, 139),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 40),
                              ),
                            ),
                            Container(
                              width: mdSize.width * 0.8,
                              child: TextFormField(
                                // controller: firstName,
                                decoration: InputDecoration(
                                  labelText: 'Enter First Name',
                                  hintText: 'Enter First Name',
                                  prefixIcon: Icon(Icons.face),
                                ),
                                onChanged: (value) {
                                  firstName = value.toString();
                                },
                              ),
                            ),
                            SizedBox(
                              height: mdSize.height * 0.03,
                            ),
                            Container(
                              width: mdSize.width * 0.8,
                              child: TextFormField(
                                // controller: lastName,
                                decoration: InputDecoration(
                                  labelText: 'Enter Last Name',
                                  hintText: 'Enter Last Name',
                                  prefixIcon: Icon(Icons.face),
                                ),
                                onChanged: (value) {
                                  lastName = value.toString();

                                  print(lastName);
                                },
                              ),
                            ),
                            SizedBox(
                              height: mdSize.height * 0.03,
                            ),
                            Container(
                              width: mdSize.width * 0.8,
                              child: TextFormField(
                                // controller: email,
                                decoration: InputDecoration(
                                  labelText: 'Enter User Name',
                                  hintText: 'Enter User Name',
                                  prefixIcon:
                                  Icon(Icons.supervised_user_circle_sharp),
                                ),
                                onChanged: (value) {
                                  email = value;
                                },
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            SizedBox(
                              height: mdSize.height * 0.03,
                            ),
                            Container(
                              width: mdSize.width * 0.8,
                              child: TextFormField(
                                // controller: password,
                                onChanged: (value) {
                                  password = value;
                                  if (password.isNotEmpty) {
                                    setState(() {
                                      if (password.length < 6) {
                                        errorText =
                                        'Minimum 6 characters required';
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
                                        ? onClickIcon(
                                        Icons.remove_red_eye_outlined)
                                        : onClickIcon(Icons.lock),
                                    errorText: errorText.isNotEmpty
                                        ? errorText
                                        : null),
                                obscureText: showIcon,
                              ),
                            ),
                            SizedBox(
                              height: mdSize.height * 0.06,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  // margin: EdgeInsets.only(right: 35),
                                  width: mdSize.width * 0.3,
                                  child: ElevatedButton(
                                    child: Text('Back'),
                                    onPressed: () async {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromARGB(255, 4, 119, 139),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                bottomRight:
                                                Radius.circular(20)))),
                                  ),
                                ),
                                Container(
                                  // margin: EdgeInsets.only(right: 35),
                                  width: mdSize.width * 0.3,
                                  child: ElevatedButton(
                                    child: Text('Register'),
                                    onPressed: () async {
                                      if (!validateFields()) {
                                        if (!this.showLoader) {
                                          CircularProgressIndicator(
                                            // backgroundColor: Colors.red,
                                              value: 0.4);
                                          print("Boolean ${this.showLoader}");
                                        }
                                        await registerUser();
                                        // if (this.showLoader) {
                                        //  CircularProgressIndicator(value: 0.0);
                                        // Navigator.pushNamed(context, '/login',);
                                        // }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromARGB(255, 4, 119, 139),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                bottomRight:
                                                Radius.circular(20)))),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
