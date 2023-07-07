import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipebox/Constant/dialog_helper.dart';
import 'package:recipebox/videoWidget.dart';

import 'Constant/Loadder.dart';
import 'Constant/Service.dart';
import 'Model/recipeModal.dart';
import 'baseWidget.dart';

class RecommandedRecipe extends StatefulWidget {
  const RecommandedRecipe({Key? key}) : super(key: key);

  @override
  State<RecommandedRecipe> createState() => _RecommandedRecipeState();
}

class _RecommandedRecipeState extends State<RecommandedRecipe> {
  List<RecipeModel> lst = [];
  Future<void> GerRecipesUserAdmin() async {
    baseService service = baseService();
    // DialogHelper.showLoading(context);
    var response = await service.Shuffle();
    if (response.statusCode == 200) {
      lst = RecipeModel.allMealPlanModelFromJson(response.body);
      print('Recipe Steps ${response.body}');
      // DialogHelper.hideLoading(context);
    } else {
      // DialogHelper.hideLoading(context);
    }
  }

  @override
  void initState() {
    GerRecipesUserAdmin().then((value) {
      setState(() {});
    });

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
      color: Colors.deepOrange, fontWeight: FontWeight.w800, fontSize: 18);

  TextStyle headerVal =
      TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    var mdSize = MediaQuery.of(context).size;
    return baseWidget(
      menuTitle: 'Recommanded Recipe',
      showWidget: Container(
          child: Column(
        children: [
          // Table View Start
          //
          // Expanded(
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.vertical,
          //     child: SingleChildScrollView(
          //       scrollDirection: Axis.horizontal,
          //       child: Container(
          //         child: Card(
          //           elevation: 10,
          //           child: DataTable(
          //             // columnSpacing: 25,
          //             //horizontalMargin: 12,
          //             //minWidth: 600,
          //             columns: [
          //               DataColumn(label: Text('Action')),
          //               DataColumn(
          //                   label: Text(
          //                 'Title',
          //                 style: TextStyle(color: Colors.black),
          //               )),
          //               DataColumn(
          //                   label: Text(
          //                 'Date',
          //                 style: TextStyle(color: Colors.black),
          //               )),
          //               DataColumn(
          //                   label: Text(
          //                 'Time',
          //                 style: TextStyle(color: Colors.black),
          //               )),
          //             ],
          //             rows: [
          //               // lst.length == 0 ? DataRow(
          //               //     cells:[
          //               //       DataCell(
          //               //           Container(
          //               //             child: Text('No Record Found'),
          //               //           )
          //               //       )
          //               //     ]
          //               // ) :
          //               for (var a in lst)
          //                 DataRow(
          //                     cells: [
          //                       DataCell(Container(
          //                         padding: const EdgeInsets.all(0),
          //                         child: Row(
          //                           // mainAxisAlignment: MainAxisAlignment.start,
          //                           // crossAxisAlignment: CrossAxisAlignment.start,
          //                           children: [
          //                             Container(
          //                               padding: const EdgeInsets.only(top: 4),
          //                               height:
          //                                   MediaQuery.of(context).size.height *
          //                                       0.05,
          //                               width:
          //                                   MediaQuery.of(context).size.width *
          //                                       0.25,
          //                               child: a.recipeVideoId != null &&
          //                                       a.recipeVideo != null
          //                                   ? TextButton.icon(
          //                                       icon: Icon(
          //                                         Icons.video_call_rounded,
          //                                         color: Colors.white,
          //                                       ),
          //                                       style: TextButton.styleFrom(
          //                                           primary: Colors.white,
          //                                           backgroundColor:
          //                                               Colors.green,
          //                                           shape:
          //                                               RoundedRectangleBorder(
          //                                                   borderRadius:
          //                                                       BorderRadius
          //                                                           .circular(
          //                                                               10))),
          //                                       label: Text('Watch'),
          //                                       onPressed: () async {
          //                                         if (a.recipeVideoId != null &&
          //                                             a.recipeVideo != null &&
          //                                             a.recipeVideo?.fileUrl !=
          //                                                 null) {
          //                                           File selectedFile = File(a
          //                                                   .recipeVideo!
          //                                                   .fileUrl ??
          //                                               "");
          //                                           var response =
          //                                               await _downloadFile(
          //                                                   selectedFile.path,
          //                                                   "sd");
          //                                           Navigator.push(context,
          //                                               MaterialPageRoute(
          //                                             builder: (context) {
          //                                               return videoWidget(
          //                                                   response);
          //                                             },
          //                                           ));
          //                                         }
          //                                       },
          //                                     )
          //                                   : Container(),
          //                             ),
          //                           ],
          //                         ),
          //                       )),
          //                       DataCell(Text(a.title != null
          //                           ? a.title.toString()
          //                           : 'hj')),
          //
          //                       DataCell(Text(a.date != null
          //                           ? DateFormat('dd-MMM-yyyy')
          //                               .format(a.date as DateTime)
          //                           : "")),
          //                       DataCell(Text(a.createTime != null
          //                           ? DateFormat.jm()
          //                           .format(a.createTime as DateTime)
          //                           : '-')),
          //                       // DataCell(Checkbox(
          //                       //   value: a.age,
          //                       //   onChanged: null,
          //                       // )),
          //                       // DataCell(Text(a.age !=null ? a.age.toString() : ""))
          //                     ],
          //                     onLongPress: () {
          //                       // Provider.of<TaskProvider>(context,
          //                       //     listen: false)
          //                       //     .openEditModelSetValue(a);
          //                       // openDialog(context, a);
          //                     })
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          //
          // Table View End

          lst == null || lst.length == 0
              ? Loader()
              : Container(
                  height: mdSize.height * 0.8,
                  child: ListView.builder(
                      // itemExtent: 1,
                      itemCount: lst.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(3),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 10.0,
                            borderOnForeground: true,
                            color: Colors.grey,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: mdSize.width * 0.2,
                                      width: mdSize.width * 0.2,
                                      // pa,
                                      child: Image.asset(
                                          'images/defaultimage.jpg'),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Title : ',
                                                  style: headerTextStyle,
                                                ),
                                              ),
                                              Container(
                                                width: mdSize.width * 0.25,
                                                child: Text(
                                                    lst[index] != null &&
                                                            lst[index]
                                                                    .title
                                                                    .toString() !=
                                                                null
                                                        ? lst[index]
                                                            .title
                                                            .toString()
                                                        : '-',
                                                    style: headerVal,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Date : ',
                                                  style: headerTextStyle,
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                    lst[index].date != null
                                                        ? DateFormat(
                                                                'dd-MMM-yyyy')
                                                            .format(
                                                                lst[index].date
                                                                    as DateTime)
                                                        : "",
                                                    style: headerVal),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                            child: Row(
                                          children: [
                                            Container(
                                              child: Text(
                                                'Time : ',
                                                style: headerTextStyle,
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                  lst[index].createTime != null
                                                      ? DateFormat.jm().format(
                                                          lst[index].createTime
                                                              as DateTime)
                                                      : "",
                                                  style: headerVal),
                                            )
                                          ],
                                        ))
                                      ],
                                    ),
                                    Container(
                                      // height:
                                      //     MediaQuery.of(context).size.height *
                                      //         0.05,
                                      // width: MediaQuery.of(context).size.width *
                                      //     0.25,
                                      child: lst[index].recipeVideoId != null &&
                                              lst[index].recipeVideo != null &&
                                              lst[index].recipeVideo?.fileUrl !=
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
                                                          BorderRadius.circular(
                                                              10))),
                                              label: Text('Watch'),
                                              onPressed: () async {
                                                if (lst[index].recipeVideoId !=
                                                        null &&
                                                    lst[index].recipeVideo !=
                                                        null &&
                                                    lst[index]
                                                            .recipeVideo
                                                            ?.fileUrl !=
                                                        null) {
                                                  File selectedFile = File(
                                                      lst[index]
                                                              .recipeVideo!
                                                              .fileUrl ??
                                                          "");
                                                  var response =
                                                      await _downloadFile(
                                                          selectedFile.path,
                                                          "sd");
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                    builder: (context) {
                                                      return videoWidget(
                                                          response);
                                                    },
                                                  ));
                                                }
                                              },
                                            )
                                          : SizedBox(),
                                    ),
                                  ],
                                )),
                          ),
                        );
                      }),
                )
        ],
      )),
    );
  }
}
