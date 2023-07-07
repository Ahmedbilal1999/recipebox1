// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:recipebox/Constant/dialog_helper.dart';
// import 'package:recipebox/videoWidget.dart';

// import 'Constant/Loadder.dart';
// import 'Constant/Service.dart';
// import 'Model/favoriteget.dart';
// import 'Model/recipeModal.dart';
// import 'baseWidget.dart';

// // class Favorite extends StatefulWidget {
// //   const Favorite({Key? key}) : super(key: key);

// //   @override
// //   State<Favorite> createState() => _FavoriteState();
// // }

// // class _FavoriteState extends State<Favorite> {
// //   List<FavoriteRecipeModel> lst = [];
// //   Future<void> GerRecipesUserAdmin() async {
// //     baseService service = baseService();
// //     // DialogHelper.showLoading(context);
// //     var response = await service.getFavoriteRecipe();
// //     if (response.statusCode == 200) {
// //       print('Favorite ${response.body[1]}');
// //       lst = FavoriteRecipeModel.allMealPlanModelFromJson(response.body);
// //       print('Recipe Steps ${response.body}');
// //       // DialogHelper.hideLoading(context);
// //     } else {
// //       // DialogHelper.hideLoading(context);
// //     }
// //   }

// //   @override
// //   void initState() {
// //     GerRecipesUserAdmin().then((value) {
// //       setState(() {});
// //     });

// //     super.initState();
// //   }

// //   Future<File> _downloadFile(String url, String filename) async {
// //     DialogHelper.showLoading(context);
// //     var httpClient = new HttpClient();
// //     var request = await httpClient.getUrl(Uri.parse(url));
// //     var response = await request.close();
// //     var bytes = await consolidateHttpClientResponseBytes(response);
// //     String dir = (await getApplicationDocumentsDirectory()).path;
// //     File file = new File('$dir/$filename');
// //     await file.writeAsBytes(bytes);
// //     DialogHelper.hideLoading(context);
// //     return file;
// //   }

// //   TextStyle headerTextStyle = TextStyle(
// //       color: Colors.deepOrange, fontWeight: FontWeight.w800, fontSize: 18);

// //   TextStyle headerVal =
// //       TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold);

// //   @override
// //   Widget build(BuildContext context) {
// //     var mdSize = MediaQuery.of(context).size;
// //     return baseWidget(
// //         menuTitle: 'Favorite',
// //         showWidget: Container(
// //           child: Column(
// //             children: [
// //               lst == null || lst.length == 0
// //                   ? Loader()
// //                   : Container(
// //                       height: mdSize.height * 0.8,
// //                       child: ListView.builder(
// //                           // itemExtent: 1,
// //                           itemCount: lst.length,
// //                           scrollDirection: Axis.vertical,
// //                           itemBuilder: (context, index) {
// //                             return Container(
// //                               padding: const EdgeInsets.all(3),
// //                               child: Card(
// //                                 shape: RoundedRectangleBorder(
// //                                     borderRadius: BorderRadius.circular(10)),
// //                                 elevation: 10.0,
// //                                 borderOnForeground: true,
// //                                 color: Colors.grey,
// //                                 child: Padding(
// //                                     padding: const EdgeInsets.all(8.0),
// //                                     child: Row(
// //                                       mainAxisAlignment:
// //                                           MainAxisAlignment.spaceBetween,
// //                                       children: [
// //                                         Container(
// //                                           height: mdSize.width * 0.2,
// //                                           width: mdSize.width * 0.2,
// //                                           // pa,
// //                                           child: lst[index].recipe == null &&
// //                                                   lst[index].recipe?.fileUrl ==
// //                                                       null
// //                                               ? Image.asset(
// //                                                   'images/defaultimage.jpg')
// //                                               : Image.network(
// //                                                   "${lst[index].recipe?.fileUrl}"),
// //                                         ),
// //                                         Column(
// //                                           mainAxisAlignment:
// //                                               MainAxisAlignment.start,
// //                                           crossAxisAlignment:
// //                                               CrossAxisAlignment.start,
// //                                           children: [
// //                                             Container(
// //                                               child: Row(
// //                                                 children: [
// //                                                   Container(
// //                                                     child: Text(
// //                                                       'Title : ',
// //                                                       style: headerTextStyle,
// //                                                     ),
// //                                                   ),
// //                                                   Container(
// //                                                     width: mdSize.width * 0.25,
// //                                                     child: Text(
// //                                                         lst[index] != null &&
// //                                                                 lst[index]
// //                                                                         .recipe !=
// //                                                                     null &&
// //                                                                 lst[index]
// //                                                                         .recipe
// //                                                                         ?.title
// //                                                                         .toString() !=
// //                                                                     null
// //                                                             ? lst[index]
// //                                                                     .recipe
// //                                                                     ?.title
// //                                                                 as String
// //                                                             : '-',
// //                                                         style: headerVal,
// //                                                         overflow: TextOverflow
// //                                                             .ellipsis),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                             ),
// //                                             Container(
// //                                               child: Row(
// //                                                 children: [
// //                                                   Container(
// //                                                     child: Text(
// //                                                       'Date : ',
// //                                                       style: headerTextStyle,
// //                                                     ),
// //                                                   ),
// //                                                   Container(
// //                                                     child: Text(
// //                                                         lst[index].createTime !=
// //                                                                 null
// //                                                             ? DateFormat(
// //                                                                     'dd-MMM-yyyy')
// //                                                                 .format(lst[index]
// //                                                                         .createTime
// //                                                                     as DateTime)
// //                                                             : "",
// //                                                         style: headerVal),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                             ),
// //                                             Container(
// //                                                 child: Row(
// //                                               children: [
// //                                                 Container(
// //                                                   child: Text(
// //                                                     'Time : ',
// //                                                     style: headerTextStyle,
// //                                                   ),
// //                                                 ),
// //                                                 Container(
// //                                                   child: Text(
// //                                                       lst[index].createTime !=
// //                                                               null
// //                                                           ? DateFormat.jm()
// //                                                               .format(lst[index]
// //                                                                       .createTime
// //                                                                   as DateTime)
// //                                                           : "",
// //                                                       style: headerVal),
// //                                                 )
// //                                               ],
// //                                             ))
// //                                           ],
// //                                         ),
// //                                         Container(
// //                                           // height:
// //                                           //     MediaQuery.of(context).size.height *
// //                                           //         0.05,
// //                                           // width: MediaQuery.of(context).size.width *
// //                                           //     0.25,
// //                                           child: lst[index].recipe != null &&
// //                                                   lst[index]
// //                                                           .recipe
// //                                                           ?.recipeVideo !=
// //                                                       null &&
// //                                                   lst[index]
// //                                                           .recipe
// //                                                           ?.recipeVideo
// //                                                           ?.fileUrl !=
// //                                                       null
// //                                               ? TextButton.icon(
// //                                                   icon: Icon(
// //                                                     Icons.video_call_rounded,
// //                                                     color: Colors.white,
// //                                                   ),
// //                                                   style: TextButton.styleFrom(
// //                                                       primary: Colors.white,
// //                                                       backgroundColor:
// //                                                           Colors.green,
// //                                                       shape:
// //                                                           RoundedRectangleBorder(
// //                                                               borderRadius:
// //                                                                   BorderRadius
// //                                                                       .circular(
// //                                                                           10))),
// //                                                   label: Text('Watch'),
// //                                                   onPressed: () async {
// //                                                     if (lst[index].recipe !=
// //                                                             null &&
// //                                                         lst[index]
// //                                                                 .recipe
// //                                                                 ?.recipeVideo !=
// //                                                             null &&
// //                                                         lst[index]
// //                                                                 .recipe
// //                                                                 ?.recipeVideo
// //                                                                 ?.fileUrl !=
// //                                                             null) {
// //                                                       File selectedFile = File(
// //                                                           lst[index]
// //                                                                   .recipe
// //                                                                   ?.recipeVideo
// //                                                                   ?.fileUrl ??
// //                                                               "");
// //                                                       var response =
// //                                                           await _downloadFile(
// //                                                               selectedFile.path,
// //                                                               "sd");
// //                                                       Navigator.push(context,
// //                                                           MaterialPageRoute(
// //                                                         builder: (context) {
// //                                                           return videoWidget(
// //                                                               response);
// //                                                         },
// //                                                       ));
// //                                                     }
// //                                                   },
// //                                                 )
// //                                               : SizedBox(),
// //                                         ),
// //                                       ],
// //                                     )),
// //                               ),
// //                             );
// //                           }),
// //                     )
// //             ],
// //           ),
// //         ));
// //   }
// // }



// import 'package:flutter/material.dart';

// void main() {
//   runApp(const FigmaToCodeApp());
// }

// // Generated by: https://www.figma.com/community/plugin/842128343887142055/
// class FigmaToCodeApp extends StatelessWidget {
//   const FigmaToCodeApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
//       ),
//       home: Scaffold(
//         body: ListView(children: [
//           Rectangle1(),
//         ]),
//       ),
//     );
//   }
// }

// class Rectangle1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [
//     // Container(
//     //                                       // height:
//     //                                       //     MediaQuery.of(context).size.height *
//     //                                       //         0.05,
//     //                                       // width: MediaQuery.of(context).size.width *
//     //                                       //     0.25,
//     //                                       child: lst[index].recipe != null &&
//     //                                               lst[index]
//     //                                                       .recipe
//     //                                                       ?.recipeVideo !=
//     //                                                   null &&
//     //                                               lst[index]
//     //                                                       .recipe
//     //                                                       ?.recipeVideo
//     //                                                       ?.fileUrl !=
//     //                                                   null
//     //                                           ? TextButton.icon(
//     //                                               icon: Icon(
//     //                                                 Icons.video_call_rounded,
//     //                                                 color: Colors.white,
//     //                                               ),
//     //                                               style: TextButton.styleFrom(
//     //                                                   primary: Colors.white,
//     //                                                   backgroundColor:
//     //                                                       Colors.green,
//     //                                                   shape:
//     //                                                       RoundedRectangleBorder(
//     //                                                           borderRadius:
//     //                                                               BorderRadius
//     //                                                                   .circular(
//     //                                                                       10))),
//     //                                               label: Text('Watch'),
//     //                                               onPressed: () async {
//     //                                                 if (lst[index].recipe !=
//     //                                                         null &&
//     //                                                     lst[index]
//     //                                                             .recipe
//     //                                                             ?.recipeVideo !=
//     //                                                         null &&
//     //                                                     lst[index]
//     //                                                             .recipe
//     //                                                             ?.recipeVideo
//     //                                                             ?.fileUrl !=
//     //                                                         null) {
//     //                                                   File selectedFile = File(
//     //                                                       lst[index]
//     //                                                               .recipe
//     //                                                               ?.recipeVideo
//     //                                                               ?.fileUrl ??
//     //                                                           "");
//     //                                                   var response =
//     //                                                       await _downloadFile(
//     //                                                           selectedFile.path,
//     //                                                           "sd");
//     //                                                   Navigator.push(context,
//     //                                                       MaterialPageRoute(
//     //                                                     builder: (context) {
//     //                                                       return videoWidget(
//     //                                                           response);
//     //                                                     },
//     //                                                   ));
//     //                                                 }
//     //                                               },
//     //                                             )
//     //                                           : SizedBox(),
//     //                                     )
//     ]);
//   }
// }


import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipebox/Constant/dialog_helper.dart';
import 'package:recipebox/videoWidget.dart';
import 'Constant/Loadder.dart';
import 'Constant/Service.dart';
import 'Model/favoriteget.dart';
import 'Model/recipeModal.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Favorite(),
    );
  }
}

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<FavoriteRecipeModel> lst = [];

  Future<void> getFavoriteRecipes() async {
    baseService service = baseService();
    var response = await service.getFavoriteRecipe();
    if (response.statusCode == 200) {
      lst = FavoriteRecipeModel.allMealPlanModelFromJson(response.body);
    } else {
      // Handle error case
    }
    setState(() {}); // Refresh the UI after fetching data
  }

  @override
  void initState() {
    getFavoriteRecipes();
    super.initState();
  }

  Future<File> _downloadFile(String url, String filename) async {
    DialogHelper.showLoading(context);
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    DialogHelper.hideLoading(context);
    return file;
  }

  TextStyle headerTextStyle = TextStyle(
    color: Colors.deepOrange,
    fontWeight: FontWeight.w800,
    fontSize: 18,
  );

  TextStyle headerVal = TextStyle(
    color: Colors.white,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    var mdSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite'),
      ),
      body: Container(
        child: Column(
          children: [
            lst == null || lst.isEmpty
                ? Loader()
                : Expanded(
                    child: ListView.builder(
                      itemCount: lst.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(3),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 10.0,
                            color: Colors.grey,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  A1c82c9164b701(), // Placeholder for image container
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              'Title: ',
                                              style: headerTextStyle,
                                            ),
                                          ),
                                          Container(
                                            width: mdSize.width * 0.25,
                                            child: Text(
                                              lst[index] != null &&
                                                      lst[index].recipe != null &&
                                                      lst[index].recipe?.title
                                                              .toString() !=
                                                          null
                                                  ? lst[index].recipe?.title
                                                      as String
                                                  : '-',
                                              style: headerVal,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              'Date: ',
                                              style: headerTextStyle,
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              lst[index].createTime != null
                                                  ? DateFormat('dd-MMM-yyyy')
                                                      .format(
                                                    lst[index].createTime as DateTime,
                                                  )
                                                  : '',
                                              style: headerVal,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              'Time: ',
                                              style: headerTextStyle,
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              lst[index].createTime != null
                                                  ? DateFormat.jm().format(
                                                      lst[index].createTime as DateTime,
                                                    )
                                                  : '',
                                              style: headerVal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    child: lst[index].recipe != null &&
                                            lst[index].recipe?.recipeVideo !=
                                                null &&
                                            lst[index]
                                                    .recipe
                                                    ?.recipeVideo?.fileUrl !=
                                                null
                                        ? TextButton.icon(
                                            icon: Icon(
                                              Icons.video_call_rounded,
                                              color: Colors.white,
                                            ),
                                            style: TextButton.styleFrom(
                                              primary: Colors.white,
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            label: Text('Watch'),
                                            onPressed: () async {
                                              if (lst[index].recipe != null &&
                                                  lst[index].recipe?.recipeVideo !=
                                                      null &&
                                                  lst[index]
                                                          .recipe
                                                          ?.recipeVideo
                                                          ?.fileUrl !=
                                                      null) {
                                                File selectedFile = File(
                                                  lst[index]
                                                          .recipe
                                                          ?.recipeVideo
                                                          ?.fileUrl ?? '',
                                                );
                                                var response = await _downloadFile(
                                                  selectedFile.path,
                                                  'sd',
                                                );
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        videoWidget(response),
                                                  ),
                                                );
                                              }
                                            },
                                          )
                                        : SizedBox(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class A1c82c9164b701 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66,
      height: 54,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("https://via.placeholder.com/66x54"),
          fit: BoxFit.fill,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
    );
  }
}
