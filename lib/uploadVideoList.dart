import 'package:flutter/material.dart';
import 'package:recipebox/Constant/DeleteDialog.dart';
import 'package:recipebox/Constant/Loadder.dart';
import 'package:recipebox/Constant/Service.dart';
import 'package:recipebox/Model/RecipeVideoModel.dart';
import 'package:intl/intl.dart';
import 'package:recipebox/uploadvideo.dart';
import 'baseWidget.dart';
import 'package:social_share/social_share.dart';

class uploadVideoList extends StatefulWidget {
  const uploadVideoList({Key? key}) : super(key: key);

  @override
  State<uploadVideoList> createState() => _uploadVideoListState();
}

// Define the handleDelete function

class _uploadVideoListState extends State<uploadVideoList> {
  List<VideoRecipeModel> lst = [];

  TextStyle txtstyle = TextStyle(
    color: Colors.white,
    // overflow: TextOverflow.ellipsis,
  );

  bool chkUser = false;

  var chk = false;
  baseService service = baseService();
  @override
  void initState() {
    GerRecipeVideo().then((value) {
      setState(() {});
    });

    super.initState();
  }

  Future<void> GerRecipeVideo() async {
    // DialogHelper.showLoading(context);
    chkUser = await service.CheckUserType();
    var response = await service.getRecipeVideo();
    if (response.statusCode == 200) {
      lst = VideoRecipeModel.allMealPlanModelFromJson(response.body);
      print(response.body);
      // DialogHelper.hideLoading(context);
    } else {
      // DialogHelper.hideLoading(context);
    }
  }

  showPopupMenu() {
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(25.0, 25.0, 25.0,
          25.0), //position where you want to show the menu on screen
      items: [
        PopupMenuItem<String>(child: const Text('menu option 1'), value: '1'),
        PopupMenuItem<String>(child: const Text('menu option 2'), value: '2'),
        PopupMenuItem<String>(child: const Text('menu option 3'), value: '3'),
      ],
      elevation: 8.0,
    ).then<void>((String? itemSelected) {
      if (itemSelected == null) return;

      if (itemSelected == "1") {
        //code here
      } else if (itemSelected == "2") {
        //code here
      } else {
        //code here
      }
    });
  }

  edit(VideoRecipeModel model) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => uploadVideo(model: model),
        ));
  }

  delete(int id) async {
    baseService service = baseService();
    if (id != 0) {
      var response = await service.DeleteVideoRecipe(id);
      print('Delete ${response.statusCode}');
      if (response.statusCode == 200) {
        Navigator.pushNamed(context, "/uploadlist");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var mdSize = MediaQuery.of(context).size;
    return baseWidget(
      menuTitle: "Video",
      showWidget: Container(
        child: Column(
          children: [
            Visibility(
              visible:chkUser,
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
                  label: Text('Add'),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/upload', (Route<dynamic> route) => false);
                  },
                ),
              ),
            ),
            lst.length == 0
                ?  service.noRecordFound
                : Container(
                    height: mdSize.height * 0.8,
                    child: SingleChildScrollView(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: lst.length,
                        // itemExtent: 2,
                        itemBuilder: (context, index) {
                          return Container(
                            // height: mdSize.height*0.9,
                            child: Card(
                                elevation: 40,
                                shadowColor: Colors.grey,
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  // height: mdSize.height*0.9,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(top: 4),
                                        height: mdSize.height * 0.05,
                                        width: mdSize.width * 0.4,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                              primary: Colors.white,
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20))),
                                          child: Text('Share'),
                                          onPressed: () {
                                            SocialShare.shareOptions(
                                                lst[index].fileUrl.toString());
                                            // SocialShare.shareWhatsapp(lst[index].fileUrl.toString());
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: mdSize.height * 0.005,
                                      ),
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Container(
                                      //       child: IconButton(onPressed: () {},
                                      //           icon: Icon(Icons.favorite_rounded,
                                      //             color: chk ? Colors.white : Colors
                                      //                 .deepOrange,
                                      //             size: 25,)),
                                      //     ),
                                      //    Container(
                                      //         padding: const EdgeInsets.only(right: 5),
                                      //         child: IconButton(
                                      //           onPressed: (){},
                                      //           icon: Icon(Icons.share_sharp,color: Colors.green,
                                      //             size: 25,),
                                      //         ),
                                      //     ),
                                      //   ],
                                      // ),
                                      // Divider(color: Colors.white,),
                                      SingleChildScrollView(
                                        child: Container(
                                          // height: mdSize.height * 0.,
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Column(children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Name : ',
                                                  style: TextStyle(
                                                      color: Colors.deepOrange),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    lst[index].name ?? '-',
                                                    style: txtstyle,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: mdSize.height * 0.005,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Description : ',
                                                  style: TextStyle(
                                                      color: Colors.deepOrange),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                      lst[index].description ??
                                                          "-",
                                                      style: txtstyle,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: mdSize.height * 0.005,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Date : ',
                                                  style: TextStyle(
                                                      color: Colors.deepOrange),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                      lst[index].date != null
                                                          ? DateFormat.yMMMd()
                                                              .format(lst[index]
                                                                      .date
                                                                  as DateTime)
                                                          : '-',
                                                      style: txtstyle,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: mdSize.height * 0.005,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Time : ',
                                                  style: TextStyle(
                                                      color: Colors.deepOrange),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                      lst[index].createTime != null
                                                          ? DateFormat.jm()
                                                              .format(lst[index]
                                                                      .createTime
                                                                  as DateTime)
                                                          : '-',
                                                      style: txtstyle,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                )
                                              ],
                                            ),
                                          ]),
                                        ),
                                      ),
                                      // Divider(color: Colors.white,),
                                      // SizedBox(height: mdSize.height * 0.04,),
                                      Expanded(
  child: Container(
    padding: const EdgeInsets.only(left: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              child: IconButton(
                color: Colors.grey,
                iconSize: 25,
                onPressed: () {
                  edit(lst[index]);
                },
                icon: Icon(Icons.edit),
              ),
            ),
          ),
        ),
        Visibility(
          visible: chkUser,
          child: Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                child: IconButton(
                  color: Colors.grey,
                  iconSize: 25,
                  onPressed: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return DeleteDialog(
                          onPressed: () {
                            delete(lst[index].id ?? 0);
                          },
                          title: lst[index].name ?? '',
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.delete),
                ),
              ),
            ),
          ),
        )
      ],
    ),
  ),
)

                                    ],
                                  ),
                                )),
                          );
                        },
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
