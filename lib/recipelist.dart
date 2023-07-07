import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipebox/Constant/Helper.dart';
import 'package:recipebox/Constant/VoiceWidget.dart';
import 'package:recipebox/Model/UserFavorite.dart';
import 'package:recipebox/Model/UserRating.dart';
import 'package:recipebox/Model/recipeModal.dart';
import 'package:recipebox/videoWidget.dart';
import 'package:recipebox/weeklyDialog.dart';
import 'package:social_share/social_share.dart';

import 'Constant/DeleteDialog.dart';
import 'Constant/Loadder.dart';
import 'Constant/Service.dart';
import 'Constant/dialog_helper.dart';
import 'Model/weeklyModelsave.dart';
import 'baseWidget.dart';
import 'recipemodal.dart';

class Recipelist extends StatefulWidget {
  const Recipelist({Key? key}) : super(key: key);

  @override
  State<Recipelist> createState() => _RecipelistState();
}

class _RecipelistState extends State<Recipelist> {
  List<RecipeModel> lst = [];
  baseService service = baseService();
  bool chkUser = false;
  Future<void> GerRecipes() async {
    // DialogHelper.showLoading(context);
    chkUser = await service.CheckUserType();
    var response = await service.getUserRecipe();
    if (response.statusCode == 200) {
      lst = RecipeModel.allMealPlanModelFromJson(response.body);
      print('Recipe Steps ${lst.last.createTime!}Z');
      // DialogHelper.hideLoading(context);
    } else {
      // DialogHelper.hideLoading(context);
    }
  }


  Future<void> DeleteRecipes(id) async {
    DialogHelper.showLoading(context);
    var response = await service.DeleteRecipe(id);
    if (response.statusCode == 200) {
      DialogHelper.hideLoading(context);
      Navigator.pop(context);
      GerRecipes().then((value) {
        setState(() {});
      });
      print('Recipe Deleted suucessfullty ${response.body}');
    } else {
      DialogHelper.hideLoading(context);
    }
  }
var searchVal;
  TextStyle headerTextStyle = TextStyle(
      color: Colors.deepOrange, fontWeight: FontWeight.w800, fontSize: 18);

  TextStyle headerVal =
      TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold);

  @override
  void initState() {
    GerRecipes().then((value) {
      setState(() {});
    });
    super.initState();
    controller.addListener(_onSearchTextChanged);
  }

  openDialog(BuildContext context, dynamic stuObj) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: RecipeModal(model: RecipeModel()),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            alignment: Alignment.center,
            title: Text(
              'Recipe',
              style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        });
  }

  TextEditingController controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      // TextField lost focus, user finished editing
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    controller.dispose();
    _focusNode.dispose();
    super.dispose();
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

  Future<void> _onSearchTextChanged() async {
    if (!searchVal) {
      baseService service = baseService();
      var response = await service.SearchRecipe(controller.text);
      if (response.statusCode == 200) {
        setState(() {
          lst = RecipeModel.allMealPlanModelFromJson(response.body);
        });
      }
    } else {
      GerRecipes().then((value) {
        setState(() {});
      });
    }
  }

  Future<bool> IsFav(int recipeId, bool isFav) async {
    DialogHelper.showLoading(context);
    UserFavorite userFav = UserFavorite(recipeId: recipeId, isFavorite: isFav);

    baseService service = baseService();

    var response = await service.IsFavorite(userFav);

    if (response.statusCode == 200) {
      var decodeBody = json.decode(response.body);
      DialogHelper.hideLoading(context);
      return decodeBody as bool;
    } else {
      DialogHelper.hideLoading(context);
      return false;
    }
  }

  Future<int> Rating(int recipeId, double rating) async {
    UserRating userRating =
        UserRating(recipeId: recipeId, recipeRating: rating);

    baseService service = baseService();

    var response = await service.Rating(userRating);

    if (response.statusCode == 200) {
      var decodeBody = json.decode(response.body);
      return decodeBody as int;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    var mdSize = MediaQuery.of(context).size;
    return baseWidget(
      menuTitle: 'Recipe',
      showWidget: Container(
          child: Column(
        children: [
          VoiceRecognization(
            controller: controller,
            focusNode: _focusNode,
            onChanged: (value) async {
              searchVal = value;
              await _onSearchTextChanged();

              // controller.text = value;
            },
          ),
          Visibility(
            visible: chkUser,
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.topLeft,
              child: ElevatedButton.icon(
                icon: Icon(Icons.add),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: StadiumBorder(),
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.all(Radius.circular(50))),
                ),
                label: Text('Add Recipe'),
                onPressed: () {
                  Navigator.pushNamed(context, '/recipemodal');
                },
              ),
            ),
          ),

          // Table View Start
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
          //               DataColumn(
          //                 label: Text(
          //                   'Action',
          //                   style: TextStyle(color: Colors.black),
          //                 ),
          //               ),
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
          //                   cells: [
          //                     DataCell(Container(
          //                       padding: const EdgeInsets.all(0),
          //                       child: Row(
          //                         // mainAxisAlignment: MainAxisAlignment.start,
          //                         // crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                           Container(
          //                             child: Visibility(
          //                               visible: chkUser,
          //                               child: IconButton(
          //                                 icon: Icon(
          //                                   Icons.delete_forever,
          //                                   color: Colors.black,
          //                                 ),
          //                                 onPressed: () {
          //                                   showDialog(
          //                                     barrierDismissible: false,
          //                                     context: context,
          //                                     builder: (contDeleteDialogext) {
          //                                       return DeleteDialog(
          //                                         onPressed: () {
          //                                           DeleteRecipes(a.id);
          //                                         },
          //                                         title: a.title,
          //                                       );
          //                                     },
          //                                   );
          //                                 },
          //                               ),
          //                             ),
          //                           ),
          //                           Container(
          //                             child: IconButton(
          //                               icon: Icon(
          //                                 Icons.add_box_rounded,
          //                                 color: Colors.black,
          //                               ),
          //                               onPressed: () {
          //                                 showDialog(
          //                                   barrierDismissible: false,
          //                                   context: context,
          //                                   builder: (contDeleteDialogext) {
          //                                     return weeklyModal(
          //                                         title: a.title,
          //                                         recipeId: a.id,
          //                                         onSaved: () {},
          //                                         onCancel: () {
          //                                           Navigator
          //                                               .pushNamedAndRemoveUntil(
          //                                                   context,
          //                                                   '/recipelist',
          //                                                   (route) => false);
          //                                         });
          //                                   },
          //                                 );
          //                               },
          //                             ),
          //                           ),
          //                           a.recipeVideoId != null &&
          //                                   a.recipeVideo != null
          //                               ? Container(
          //                                   padding:
          //                                       const EdgeInsets.only(top: 4),
          //                                   height: mdSize.height * 0.05,
          //                                   width: mdSize.width * 0.25,
          //                                   child: TextButton.icon(
          //                                     icon: Icon(
          //                                       Icons.video_call_rounded,
          //                                       color: Colors.white,
          //                                     ),
          //                                     style: TextButton.styleFrom(
          //                                         primary: Colors.white,
          //                                         backgroundColor: Colors.green,
          //                                         shape: RoundedRectangleBorder(
          //                                             borderRadius:
          //                                                 BorderRadius.circular(
          //                                                     10))),
          //                                     label: Text('Watch'),
          //                                     onPressed: () async {
          //                                       if (a.recipeVideoId != null &&
          //                                           a.recipeVideo != null &&
          //                                           a.recipeVideo?.fileUrl !=
          //                                               null) {
          //                                         File selectedFile = File(
          //                                             a.recipeVideo!.fileUrl ??
          //                                                 "");
          //                                         var response =
          //                                             await _downloadFile(
          //                                                 selectedFile.path,
          //                                                 "sd");
          //                                         Navigator.push(context,
          //                                             MaterialPageRoute(
          //                                           builder: (context) {
          //                                             return videoWidget(
          //                                                 response);
          //                                           },
          //                                         ));
          //                                       }
          //                                     },
          //                                   ),
          //                                 )
          //                               : Container(),
          //                         ],
          //                       ),
          //                     )),
          //                     DataCell(Text(
          //                         a.title != null ? a.title.toString() : 'hj')),
          //                     DataCell(Text(a.date != null
          //                         ? DateFormat('dd-MMM-yyyy')
          //                             .format(a.date as DateTime)
          //                         : "")),
          //                     DataCell(Text(a.createTime != null
          //                         ? DateFormat.jm()
          //                             .format(a.createTime as DateTime)
          //                         : '-')),
          //                     // DataCell(Checkbox(
          //                     //   value: a.age,
          //                     //   onChanged: null,
          //                     // )),
          //                     // DataCell(Text(a.age !=null ? a.age.toString() : ""))
          //                   ],
          //                   onLongPress: () {
          //                     // if (value == true) {
          //                     Navigator.push(
          //                         context,
          //                         MaterialPageRoute(
          //                           builder: (context) => RecipeModal(model: a),
          //                         ));
          //                     // }
          //                   },
          //
          //                   // onSelectChanged: (value) {
          //                   //   if (value == true) {
          //                   //     Navigator.push(
          //                   //         context,
          //                   //         MaterialPageRoute(
          //                   //           builder: (context) =>
          //                   //               RecipeModal(model: a),
          //                   //         ));
          //                   //   }
          //                   // },
          //                 )
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // Table View End

          lst == null || lst.length == 0
              ? Loader()
              : Container(
                  height: mdSize.height * 0.7,
                  child: SingleChildScrollView(
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, childAspectRatio: 0.63),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: lst.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Card(
                                elevation: 40,
                                shadowColor: Colors.white,
                                color: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          (lst[index].favoriteUser != null &&
                                                  lst[index]
                                                      .favoriteUser!
                                                      .isFavorite)
                                              ? IconButton(
                                                  onPressed: () async {
                                                    var res = await IsFav(
                                                        lst[index].id!, false);

                                                    setState(() {
                                                      lst[index]
                                                          .favoriteUser!
                                                          .isFavorite = res;
                                                    });
                                                  },
                                                  icon: Icon(
                                                      Icons.favorite_rounded,
                                                      color: Colors.deepOrange))
                                              : IconButton(
                                                  onPressed: () async {
                                                    var res = await IsFav(
                                                        lst[index].id!, true);
                                                    setState(() {
                                                      if (lst[index]
                                                              .favoriteUser ==
                                                          null) {
                                                        lst[index]
                                                                .favoriteUser =
                                                            UserFavorite(
                                                                isFavorite: res,
                                                                recipeId:
                                                                    lst[index]
                                                                        .id);
                                                      } else {
                                                        lst[index]
                                                            .favoriteUser!
                                                            .isFavorite = res;
                                                      }
                                                    });
                                                  },
                                                  icon: Icon(
                                                      Icons
                                                          .favorite_border_outlined,
                                                      color:
                                                          Colors.deepOrange)),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                right: 10, top: 8),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            child: (lst[index].fileUrl !=
                                                        null &&
                                                    lst[index].fileUrl != "")
                                                ? Image.network(lst[index]
                                                    .fileUrl
                                                    .toString())
                                                : Image.asset(
                                                    'images/defaultimage.jpg'),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: mdSize.height * 0.02,
                                      ),
                                      Container(
                                        // height:300,
                                        child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Container(
                                                // height: mdSize.height * 0.,
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Column(children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Title : ',
                                                        style: headerTextStyle,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          lst[index].title ??
                                                              '-',
                                                          style: headerVal,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        mdSize.height * 0.01,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Date : ',
                                                        style: headerTextStyle,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          lst[index].date !=
                                                                  null
                                                              ? DateFormat(
                                                                      'dd-MMM-yyyy')
                                                                  .format(lst[index]
                                                                          .date
                                                                      as DateTime)
                                                              : "",
                                                          style: headerVal,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        mdSize.height * 0.01,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Time : ',
                                                        style: headerTextStyle,
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          lst[index].createTime !=
                                                                  null
                                                              ? DateFormat.jm()
                                                                  .format(lst[index]
                                                                          .createTime
                                                                      as DateTime)
                                                              : "",
                                                          style: headerVal,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        mdSize.height * 0.01,
                                                  ),
                                                ]))),
                                      ),
                                      RatingBar.builder(
                                        itemSize: 25,
                                        initialRating:
                                            lst[index].ratingUser != null
                                                ? lst[index]
                                                    .ratingUser!
                                                    .recipeRating
                                                : 0,
                                        maxRating: 5,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: false,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        itemBuilder: (context, ind) => Icon(
                                          Icons.star_border_outlined,
                                          color: Colors.yellowAccent,
                                        ),
                                        onRatingUpdate: (rating) async {
                                          await Rating(lst[index].id!, rating);
                                        },
                                      ),
                                      // Row(
                                      //   children: [
                                      //     Container(
                                      //         width: 25,
                                      //         decoration: BoxDecoration(
                                      //             shape: BoxShape.circle),
                                      //         child: lst[index]
                                      //                         .ratingUser ==
                                      //                     null &&
                                      //                 (lst[index]
                                      //                             .ratingUser
                                      //                             ?.recipeRating !=
                                      //                         1 ||
                                      //                     lst[index]
                                      //                             .ratingUser
                                      //                             ?.recipeRating !=
                                      //                         2 ||
                                      //                     lst[index]
                                      //                             .ratingUser
                                      //                             ?.recipeRating !=
                                      //                         3 ||
                                      //                     lst[index]
                                      //                             .ratingUser
                                      //                             ?.recipeRating !=
                                      //                         4 ||
                                      //                     lst[index]
                                      //                             .ratingUser
                                      //                             ?.recipeRating !=
                                      //                         5)
                                      //             ? IconButton(
                                      //                 splashColor:
                                      //                     Colors.transparent,
                                      //                 onPressed: () async {
                                      //                   await Rating(
                                      //                       lst[index].id!, 1);
                                      //                 },
                                      //                 icon: Icon(
                                      //                   Icons.star_border,
                                      //                   color:
                                      //                       Colors.deepOrange,
                                      //                 ),
                                      //               )
                                      //             : IconButton(
                                      //                 splashColor:
                                      //                     Colors.transparent,
                                      //                 onPressed: () async {
                                      //                   await Rating(
                                      //                       lst[index].id!, 1);
                                      //                 },
                                      //                 icon: Icon(
                                      //                   Icons.star_outlined,
                                      //                   color:
                                      //                       Colors.deepOrange,
                                      //                 ),
                                      //               )),
                                      //     Container(
                                      //         width: 25,
                                      //         decoration: BoxDecoration(
                                      //             shape: BoxShape.circle),
                                      //         child: lst[index]
                                      //                         .ratingUser ==
                                      //                     null &&
                                      //                 (lst[index]
                                      //                             .ratingUser
                                      //                             ?.recipeRating !=
                                      //                         2 ||
                                      //                     lst[index]
                                      //                             .ratingUser
                                      //                             ?.recipeRating !=
                                      //                         3 ||
                                      //                     lst[index]
                                      //                             .ratingUser
                                      //                             ?.recipeRating !=
                                      //                         4 ||
                                      //                     lst[index]
                                      //                             .ratingUser
                                      //                             ?.recipeRating !=
                                      //                         5)
                                      //             ? IconButton(
                                      //                 splashColor:
                                      //                     Colors.transparent,
                                      //                 onPressed: () async {
                                      //                   await Rating(
                                      //                       lst[index].id!, 2);
                                      //                 },
                                      //                 icon: Icon(
                                      //                   Icons.star_border,
                                      //                   color:
                                      //                       Colors.deepOrange,
                                      //                 ),
                                      //               )
                                      //             : IconButton(
                                      //                 splashColor:
                                      //                     Colors.transparent,
                                      //                 onPressed: () async {
                                      //                   await Rating(
                                      //                       lst[index].id!, 2);
                                      //                 },
                                      //                 icon: Icon(
                                      //                   Icons.star_outlined,
                                      //                   color:
                                      //                       Colors.deepOrange,
                                      //                 ),
                                      //               )),
                                      //     Container(
                                      //         width: 25,
                                      //         decoration: BoxDecoration(
                                      //             shape: BoxShape.circle),
                                      //         child: lst[index]
                                      //                         .ratingUser ==
                                      //                     null &&
                                      //                 (lst[index]
                                      //                             .ratingUser
                                      //                             ?.recipeRating !=
                                      //                         3 ||
                                      //                     lst[index]
                                      //                             .ratingUser
                                      //                             ?.recipeRating !=
                                      //                         4 ||
                                      //                     lst[index]
                                      //                             .ratingUser
                                      //                             ?.recipeRating !=
                                      //                         5)
                                      //             ? IconButton(
                                      //                 splashColor:
                                      //                     Colors.transparent,
                                      //                 onPressed: () async {
                                      //                   await Rating(
                                      //                       lst[index].id!, 3);
                                      //                 },
                                      //                 icon: Icon(
                                      //                   Icons.star_border,
                                      //                   color:
                                      //                       Colors.deepOrange,
                                      //                 ),
                                      //               )
                                      //             : IconButton(
                                      //                 splashColor:
                                      //                     Colors.transparent,
                                      //                 onPressed: () async {
                                      //                   await Rating(
                                      //                       lst[index].id!, 3);
                                      //                 },
                                      //                 icon: Icon(
                                      //                   Icons.star_outlined,
                                      //                   color:
                                      //                       Colors.deepOrange,
                                      //                 ),
                                      //               )),
                                      //     Container(
                                      //         width: 25,
                                      //         decoration: BoxDecoration(
                                      //             shape: BoxShape.circle),
                                      //         child: lst[index].ratingUser ==
                                      //                     null &&
                                      //                 (lst[index]
                                      //                             .ratingUser
                                      //                             ?.recipeRating !=
                                      //                         4 ||
                                      //                     lst[index]
                                      //                             .ratingUser
                                      //                             ?.recipeRating !=
                                      //                         5)
                                      //             ? IconButton(
                                      //                 splashColor:
                                      //                     Colors.transparent,
                                      //                 onPressed: () async {
                                      //                   await Rating(
                                      //                       lst[index].id!, 4);
                                      //                 },
                                      //                 icon: Icon(
                                      //                   Icons.star_border,
                                      //                   color:
                                      //                       Colors.deepOrange,
                                      //                 ),
                                      //               )
                                      //             : IconButton(
                                      //                 splashColor:
                                      //                     Colors.transparent,
                                      //                 onPressed: () async {
                                      //                   await Rating(
                                      //                       lst[index].id!, 4);
                                      //                 },
                                      //                 icon: Icon(
                                      //                   Icons.star_outlined,
                                      //                   color:
                                      //                       Colors.deepOrange,
                                      //                 ),
                                      //               )),
                                      //     Container(
                                      //         width: 25,
                                      //         decoration: BoxDecoration(
                                      //             shape: BoxShape.circle),
                                      //         child: lst[index].ratingUser ==
                                      //                     null &&
                                      //                 lst[index]
                                      //                         .ratingUser
                                      //                         ?.recipeRating !=
                                      //                     5
                                      //             ? IconButton(
                                      //                 splashColor:
                                      //                     Colors.transparent,
                                      //                 onPressed: () async {
                                      //                   await Rating(
                                      //                       lst[index].id!, 5);
                                      //                 },
                                      //                 icon: Icon(
                                      //                   Icons.star_border,
                                      //                   color:
                                      //                       Colors.deepOrange,
                                      //                 ),
                                      //               )
                                      //             : IconButton(
                                      //                 splashColor:
                                      //                     Colors.transparent,
                                      //                 onPressed: () async {
                                      //                   await Rating(
                                      //                       lst[index].id!, 5);
                                      //                 },
                                      //                 icon: Icon(
                                      //                   Icons.star_outlined,
                                      //                   color:
                                      //                       Colors.deepOrange,
                                      //                 ),
                                      //               )),
                                      //   ],
                                      // ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.add_box_rounded,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder:
                                                      (contDeleteDialogext) {
                                                    return weeklyModal(
                                                        title: lst[index].title,
                                                        recipeId: lst[index].id,
                                                        onSaved: () {},
                                                        onCancel: () {
                                                          Navigator
                                                              .pushNamedAndRemoveUntil(
                                                                  context,
                                                                  '/recipelist',
                                                                  (route) =>
                                                                      false);
                                                        });
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          Container(
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: Colors.black,
                                                  size: 25,
                                                ),
                                                // style: TextButton.styleFrom(
                                                //     primary: Colors.white,
                                                //     backgroundColor:
                                                //         Colors.green,
                                                //     shape: RoundedRectangleBorder(
                                                //         borderRadius:
                                                //             BorderRadius
                                                //                 .circular(
                                                //                     10))),
                                                onPressed: () async {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            RecipeModal(
                                                                model:
                                                                    lst[index]),
                                                      ));
                                                }),
                                          ),
                                          Container(
                                            child: Visibility(
                                              visible: chkUser,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.delete_forever,
                                                  color: Colors.black,
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder:
                                                        (contDeleteDialogext) {
                                                      return DeleteDialog(
                                                        onPressed: () {
                                                          DeleteRecipes(
                                                              lst[index].id);
                                                        },
                                                        title: lst[index].title,
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              child: lst[index].recipeVideoId !=
                                                          null &&
                                                      lst[index].recipeVideo !=
                                                          null &&
                                                      lst[index]
                                                              .recipeVideo
                                                              ?.fileUrl !=
                                                          null
                                                  ? IconButton(
                                                      icon: Icon(
                                                        Icons
                                                            .video_call_rounded,
                                                        color:
                                                            Colors.green[800],
                                                        size: 30,
                                                        weight: 0.5,
                                                      ),
                                                      // style: TextButton.styleFrom(
                                                      //     primary: Colors.white,
                                                      //     backgroundColor:
                                                      //         Colors.green,
                                                      //     shape: RoundedRectangleBorder(
                                                      //         borderRadius:
                                                      //             BorderRadius
                                                      //                 .circular(
                                                      //                     10))),
                                                      onPressed: () async {
                                                        if (lst[index].recipeVideoId != null &&
                                                            lst[index]
                                                                    .recipeVideo !=
                                                                null &&
                                                            lst[index]
                                                                    .recipeVideo
                                                                    ?.fileUrl !=
                                                                null) {
                                                          File selectedFile =
                                                              File(lst[index]
                                                                      .recipeVideo!
                                                                      .fileUrl ??
                                                                  "");
                                                          var response =
                                                              await _downloadFile(
                                                                  selectedFile
                                                                      .path,
                                                                  "sd");
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                            builder: (context) {
                                                              return videoWidget(
                                                                  response);
                                                            },
                                                          ));
                                                        }
                                                      },
                                                    )
                                                  : SizedBox()),
                                          Container(
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.share,
                                                color: Colors.green[800],
                                                size: 30,
                                                weight: 0.5,
                                              ),
                                              onPressed: () {
                                                SocialShare.shareOptions(
                                                    lst[index]
                                                        .fileUrl
                                                        .toString());
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                          );
                        }),
                  ),
                )
        ],
      )),
    );
  }
}
