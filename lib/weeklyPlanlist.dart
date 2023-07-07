import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipebox/Constant/Helper.dart';
import 'package:recipebox/Constant/dialog_helper.dart';
import 'package:recipebox/videoWidget.dart';

import 'Constant/Loadder.dart';
import 'Constant/Service.dart';
import 'Model/weeklyModelget.dart';
import 'baseWidget.dart';

class weeklyPlanlist extends StatefulWidget {
  const weeklyPlanlist({Key? key}) : super(key: key);

  @override
  State<weeklyPlanlist> createState() => _weeklyPlanlistState();
}

class _weeklyPlanlistState extends State<weeklyPlanlist> {
  List<WeeklyModelGet> lst = [];
  baseService service = baseService();
  Future<void> GerWeeklyRecipes() async {
    // DialogHelper.showLoading(context);
    var response = await service.getWeeklyPlan();
    if (response.statusCode == 200) {
      print('Weekly Data ${response.body}');
      lst = WeeklyModelGet.allMealPlanModelFromJson(response.body);
      // DialogHelper.hideLoading(context);
    } else {
      // DialogHelper.hideLoading(context);
    }
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
  void initState() {
    // TODO: implement initState
    GerWeeklyRecipes().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mdSize = MediaQuery.of(context).size;
    return baseWidget(
      menuTitle: 'Weekly Plan',
      showWidget: Container(
          child: Column(
        children: [
          // VoiceRecognization(
          //   controller: controller,
          //   focusNode: _focusNode,
          //   onChanged: (value) async {
          //     controller.text = value;
          //     await _onSearchTextChanged();
          //
          //     // controller.text = value;
          //   },
          // ),

          // table View Start
          /* Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  child: Card(
                    elevation: 10,
                    child: DataTable(
                      // columnSpacing: 25,
                      //horizontalMargin: 12,
                      //minWidth: 600,
                      columns: [
                        DataColumn(
                          label: Text(
                            'Action',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        DataColumn(
                            label: Text(
                          'Recipe Name',
                          style: TextStyle(color: Colors.black),
                        )),
                        DataColumn(
                            label: Text(
                          'Start Date',
                          style: TextStyle(color: Colors.black),
                        )),
                        DataColumn(
                            label: Text(
                          'End Date',
                          style: TextStyle(color: Colors.black),
                        )),
                        DataColumn(
                            label: Text(
                          'Time',
                          style: TextStyle(color: Colors.black),
                        ))
                      ],
                      rows: [
                        for (var a in lst)
                          DataRow(
                            cells: [
                              DataCell(Container(
                                padding: const EdgeInsets.all(0),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(top: 4),
                                      height: mdSize.height * 0.05,
                                      width: mdSize.width * 0.25,
                                      child: a.recipe != null &&
                                              a.recipe?.recipeVideoId != null
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
                                                if (a.recipe != null &&
                                                    a.recipe?.recipeVideo !=
                                                        null &&
                                                    a.recipe?.recipeVideo
                                                            ?.fileUrl !=
                                                        null) {
                                                  File selectedFile = File(a
                                                          .recipe
                                                          ?.recipeVideo!
                                                          .fileUrl ??
                                                      "");
                                                  var response =
                                                      await _downloadFile(
                                                          selectedFile.path,
                                                          "WeeklyPlane");
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                    builder: (context) {
                                                      return videoWidget(
                                                          response);
                                                    },
                                                  ));
                                                }
                                              },
                                              // onPressed: () async {
                                              //   if (a.recipeVideoId != null &&
                                              //       a.recipeVideo != null &&
                                              //       a.recipeVideo?.fileUrl != null) {
                                              //     File selectedFile = File(
                                              //         a.recipeVideo!.fileUrl ?? "");
                                              //     var response = await _downloadFile(
                                              //         selectedFile.path, "sd");
                                              //     Navigator.push(context,
                                              //         MaterialPageRoute(
                                              //           builder: (context) {
                                              //             return videoWidget(response);
                                              //           },
                                              //         ));
                                              //   }
                                              // },
                                            )
                                          : Container(),
                                    ),
                                  ],
                                ),
                              )),
                              DataCell(Text(
                                  a.recipe != null && a.recipe?.title != null
                                      ? (a.recipe?.title ?? "")
                                      : "")),
                              DataCell(Text(a.startDate != null
                                  ? DateFormat('dd-MMM-yyyy')
                                      .format(a.startDate as DateTime)
                                  : "")),
                              DataCell(Text(a.endDate != null
                                  ? DateFormat('dd-MMM-yyyy')
                                      .format(a.endDate as DateTime)
                                  : "")),
                              DataCell(Text(a.createTime != null
                                  ? DateFormat.jm()
                                      .format(a.createTime as DateTime)
                                  : '-')),
                            ],
                            // onLongPress: () {
                            //   // if (value == true) {
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) => RecipeModal(model: a),
                            //       ));
                            //   // }
                            // },

                            // onSelectChanged: (value) {
                            //   if (value == true) {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) =>
                            //               RecipeModal(model: a),
                            //         ));
                            //   }
                            // },
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),*/
          // table View End

          // Card(
          //     child: Container(
          //       height: 30,
          //       child:  ListView(
          //         scrollDirection: Axis.horizontal,
          //         // shrinkWrap: true,
          //         children: [
          //           Expanded(
          //             child: Container(
          //               child: Text('Roll No',
          //                   style: TextStyle(
          //                       fontSize: 20,
          //                       color: Colors.black26,
          //                       decoration: TextDecoration.none)),
          //             ),
          //           ),
          //           // ),
          //           Expanded(
          //             child: Container(
          //               child: Text('Roll No',
          //                   style: TextStyle(
          //                       fontSize: 20,
          //                       color: Colors.black26,
          //                       decoration: TextDecoration.none)),
          //             ),
          //           ),
          //           Expanded(
          //             child: Container(
          //               child: Text('Roll No',
          //                   style: TextStyle(
          //                       fontSize: 20,
          //                       color: Colors.black26,
          //                       decoration: TextDecoration.none)),
          //             ),
          //           ),
          //           Expanded(
          //             child: Container(
          //               child: Text('Roll No',
          //                   style: TextStyle(
          //                       fontSize: 20,
          //                       color: Colors.black26,
          //                       decoration: TextDecoration.none)),
          //             ),
          //           ),
          //           Expanded(
          //             child: Container(
          //               child: Text('Roll No',
          //                   style: TextStyle(
          //                       fontSize: 20,
          //                       color: Colors.black26,
          //                       decoration: TextDecoration.none)),
          //             ),
          //           ),
          //           Expanded(
          //             child: Container(
          //               child: Text('Roll No',
          //                   style: TextStyle(
          //                       fontSize: 20,
          //                       color: Colors.black26,
          //                       decoration: TextDecoration.none)),
          //             ),
          //           ),
          //           Expanded(
          //             child: Container(
          //               child: Text('Roll No',
          //                   style: TextStyle(
          //                       fontSize: 20,
          //                       color: Colors.black26,
          //                       decoration: TextDecoration.none)),
          //             ),
          //           ),
          //           Expanded(
          //             child: Container(
          //               child: Text('Roll No',
          //                   style: TextStyle(
          //                       fontSize: 20,
          //                       color: Colors.black26,
          //                       decoration: TextDecoration.none)),
          //             ),
          //           ),
          //         ],
          //       ),
          //
          //     ),
          // ),
          //
          // Card(
          //   child: Container(
          //     height: 200,
          //     child: ListView.builder(
          //         itemBuilder: (context, index) {
          //           return Row(
          //           children:[
          //             Text(studentlist[index].toString(),style: TextStyle(color: Colors.black),),
          //             Text(studentlist[index].toString(),style: TextStyle(color: Colors.black),),
          //             Text(studentlist[index].toString(),style: TextStyle(color: Colors.black),),
          //             Text(studentlist[index].toString(),style: TextStyle(color: Colors.black),)
          //           ]
          //           );
          //
          //         },
          //       itemCount:studentlist.length,
          //
          //         )),
          //   )

          // Container(
          //     child: Row(
          //   children: [
          //     //    child: Column(
          //     //       children: [
          //     Expanded(
          //       child: Container(
          //         child: Text('Roll No',
          //             style: TextStyle(
          //                 fontSize: 20,
          //                 color: Colors.white,
          //                 decoration: TextDecoration.none)),
          //       ),
          //     ),
          //     Expanded(
          //       child: Container(
          //         child: Text('Roll No',
          //             style: TextStyle(
          //                 fontSize: 20,
          //                 color: Colors.white,
          //                 decoration: TextDecoration.none)),
          //       ),
          //     ),
          //     Expanded(
          //       child: Container(
          //         child: Text('Roll No',
          //             style: TextStyle(
          //                 fontSize: 20,
          //                 color: Colors.white,
          //                 decoration: TextDecoration.none)),
          //       ),
          //     ),
          //     Expanded(
          //       child: Container(
          //         child: Text('Roll No',
          //             style: TextStyle(
          //                 fontSize: 20,
          //                 color: Colors.white,
          //                 decoration: TextDecoration.none)),
          //       ),
          //     ),
          //     Expanded(
          //       child: Container(
          //         child: Text('Roll No',
          //             style: TextStyle(
          //                 fontSize: 20,
          //                 color: Colors.white,
          //                 decoration: TextDecoration.none)),
          //       ),
          //     ),
          //     Expanded(
          //       child: Container(
          //         child: Text('Roll No',
          //             style: TextStyle(
          //                 fontSize: 20,
          //                 color: Colors.white,
          //                 decoration: TextDecoration.none)),
          //       ),
          //     )
          //   ],
          // )
          //     //   ],
          //     // ),
          //     )

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
                                      child: lst[index].recipe == null &&
                                              lst[index].recipe?.fileUrl == null
                                          ? Image.asset(
                                              'images/defaultimage.jpg')
                                          : Image.network(
                                              "${lst[index].recipe?.fileUrl}"),
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
                                                    lst[index].recipe != null &&
                                                            lst[index]
                                                                    .recipe!
                                                                    .title !=
                                                                null
                                                        ? lst[index]
                                                            .recipe!
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
                                                  'Start : ',
                                                  style: headerTextStyle,
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                    lst[index].startDate != null
                                                        ? DateFormat(
                                                                'dd-MMM-yyyy')
                                                            .format(lst[index]
                                                                    .startDate
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
                                                  'End : ',
                                                  style: headerTextStyle,
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                    lst[index].endDate != null
                                                        ? DateFormat(
                                                                'dd-MMM-yyyy')
                                                            .format(lst[index]
                                                                    .endDate
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
                                      padding: const EdgeInsets.only(top: 4),
                                      height: mdSize.height * 0.05,
                                      width: mdSize.width * 0.25,
                                      child: lst[index].recipe != null &&
                                              lst[index]
                                                      .recipe
                                                      ?.recipeVideoId !=
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
                                                if (lst[index].recipe != null &&
                                                    lst[index]
                                                            .recipe
                                                            ?.recipeVideo !=
                                                        null &&
                                                    lst[index]
                                                            .recipe
                                                            ?.recipeVideo
                                                            ?.fileUrl !=
                                                        null) {
                                                  File selectedFile = File(
                                                      lst[index]
                                                              .recipe
                                                              ?.recipeVideo!
                                                              .fileUrl ??
                                                          "");
                                                  var response =
                                                      await _downloadFile(
                                                          selectedFile.path,
                                                          "WeeklyPlane");
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
                                          : Container(),
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
