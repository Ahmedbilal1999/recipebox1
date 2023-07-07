import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:recipebox/Constant/Service.dart';
import 'package:recipebox/Constant/dialog_helper.dart';
import 'package:recipebox/Model/RecipeVideoModel.dart';
import 'Model/recipeModal.dart';
import 'baseWidget.dart';
import 'constantFile.dart';

class RecipeModal extends StatefulWidget {
  final RecipeModel model;
  const RecipeModal({required this.model, Key? key}) : super(key: key);

  @override
  State<RecipeModal> createState() => _RecipeModalState(model: model);
}

class _RecipeModalState extends State<RecipeModal> {
  final RecipeModel model;
  _RecipeModalState({required this.model});

  static final noww = new DateTime.now();
  String currentdate = DateFormat('yMd').format(noww);
  final GlobalKey<QuillHtmlEditorState> htmlKey =
      GlobalKey<QuillHtmlEditorState>();

  String? title;
  DateTime? date;
  VideoRecipeModel? selectedValueModel;
  int? recipeVideoId;
  String? recipeVideoName;
  bool chkUser = false;
  File? imageFile;
  Future<void> getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(
      source: source,
    );

    if (file?.path != null) {
      setState(() {
        imageFile = File(file?.path ?? "");
        model.fileUrl = "";
      });
    }
  }

  baseService ser = baseService();

  snackBarText(txt) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${txt} is required'),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 1),
    ));
  }

  validateFields(desc) {
    bool validate = false;
    print('Validate ${desc}');
    var d = DateTime.now();
    date = (date == null ? d : date);
    if (title == null || title == "") {
      snackBarText('Title');
      validate = true;
    } else if (desc.isEmpty) {
      snackBarText('Description');
      validate = true;
    } else if (date == null) {
      snackBarText('Date');
      validate = true;
    } else {
      validate = false;
    }
    return validate;
  }

  saveRecipe() async {
    DialogHelper.showLoading(context);
    var des = await htmlKey.currentState?.getText();
    print(
        'Date ${date != null ? date : DateTime.tryParse(currentdate.toString())}');
    var obj = RecipeModel(
        title: title,
        discription: des,
        recipeVideoId: recipeVideoId,
        date: date != null ? date : DateTime.tryParse(currentdate.toString()));
    print('Recipe Object ${obj.date}');
    var res = await ser.AddRecipe(imageFile, obj);
    print('Recipe Status ${res.statusCode}');
    if (res.statusCode == 200) {
      DialogHelper.hideLoading(context);

      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Record saved successfully'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        onVisible: () {
          Navigator.pushNamed(context, '/recipelist');
        },
      ));
    } else {
      DialogHelper.hideLoading(context);
      res.stream.transform(utf8.decoder).listen((value) {
        var errorDecode = json.decode(value);
        String error = errorDecode["errors"][0];
        ser.snackBarTextWhileRegiter(context, error, "Error");
      });
    }
  }

  List<VideoRecipeModel> videoRecipe = [];

  Future<List<VideoRecipeModel>?> getVideo() async {
    baseService servive = baseService();

    var response = await servive.getRecipeVideo();
    if (response.statusCode == 200) {
      videoRecipe = VideoRecipeModel.allMealPlanModelFromJson(response.body);
      return videoRecipe;
    }
    return null;
  }

  EditRecipe() async {
    DialogHelper.showLoading(context);
    var des = await htmlKey.currentState?.getText();
    print(
        'Date ${date != null ? date : DateTime.tryParse(currentdate.toString())}');
    var obj = RecipeModel(
        id: model.id,
        title: title,
        discription: des,
        recipeVideoId: recipeVideoId,
        date: date != null ? date : DateTime.tryParse(currentdate.toString()));
    print('Recipe Object ${obj.date}');
    print('Edit Recipe ${obj.discription}');
    var res = await ser.RecipeEdit(imageFile, obj, context);
    print('Recipe Status ${res.statusCode}');
    if (res.statusCode == 200) {
      res.stream.transform(utf8.decoder).listen((value) {
        print("value: $value");
      });
      DialogHelper.hideLoading(context);
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Record saved successfully'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        onVisible: () {
          Navigator.pushNamed(context, '/recipelist');
        },
      ));
    } else {
      DialogHelper.hideLoading(context);
      res.stream.transform(utf8.decoder).listen((value) {
        var errorDecode = json.decode(value);
        String error = errorDecode["errors"][0];
        ser.snackBarTextWhileRegiter(context, error, "Error");
      });
    }
  }

  @override
  void initState() {
    enableOrDisableControls();
    getVideo().then((value) {
      setState(() {});
    });
    fillData();

    super.initState();
  }

  setEtx(String txt) async {
    await Future.delayed(Duration(seconds: 2));
    await htmlKey.currentState?.setText(txt);
  }

  enableOrDisableControls() async {
    chkUser = await ser.CheckUserType();
    setState(() {});
  }

  Future<void> fillData() async {
    if (model.id != null && model.id != 0) {
      title = model.title ?? "";
      date = model.date;
      recipeVideoName = model.recipeVideo?.name;
      var desc = model.discription;

      if (model.fileUrl != null && model.fileUrl!.isNotEmpty) {
        // imageFile = File(model.fileUrl!);
      }

      // print('Hello ${editorState}');
      Timer(Duration(milliseconds: 500), () async {
        await setEtx(desc ?? "");
      });
      // htmlDKey=desc;
    }
  }

  @override
  Widget build(BuildContext context) {
    var mdSize = MediaQuery.of(context).size;
    return baseWidget(
      menuTitle: "Recipe",
      showWidget: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Visibility(
                      visible: chkUser,
                      child: ElevatedButton(
                        onPressed: () {
                          getImage(source: ImageSource.gallery);
                        },
                        child: Text("Select Image"),
                      ),
                    ),
                    if (imageFile == null && model.fileUrl == null)
                      Icon(
                        Icons.camera_alt,
                        size: MediaQuery.of(context).size.width * .2,
                      ),
                    if (imageFile != null || model.fileUrl != null)
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.width * .3,
                            width: MediaQuery.of(context).size.width * .5,
                            child: model.fileUrl != null && model.fileUrl != ""
                                ? Image.network(model.fileUrl!)
                                : Image.file(imageFile!),
                          ),
                        ],
                      )
                  ],
                ),
                Container(
                  width: mdSize.width * 0.9,
                  child: MyTextFormField(
                    enable: chkUser,
                    initialVa: title,
                    dec: inputDec.copyWith(hintText: "Enter Title"),
                    inputChagedValue: (val) => {title = val},
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black),
                  width: mdSize.width * 0.6,
                  child: QuillHtmlEditor(
                    hintText: 'Enter Description',
                    editorKey: htmlKey,
                    height: mdSize.height * 0.64,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: mdSize.width * 0.9,
                  child: ElevatedButton(
                      child: date != null
                          ? Text(DateFormat('yMd').format(date as DateTime))
                          : Text(currentdate),
                      onPressed: () {
                        if (chkUser) {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1887, 1),
                                  lastDate: DateTime(3050, 12))
                              .then((value) {
                            if (value != null) {
                              setState(() {
                                currentdate = DateFormat('yMd').format(value);
                                date = DateTime.tryParse(value.toString());
                              });
                            }
                          });
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Container(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        isExpanded: true,
                        hint: Row(
                          children: [
                            Icon(
                              Icons.list,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Text(
                                recipeVideoName ?? 'Select Item',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: videoRecipe.map((VideoRecipeModel map) {
                          return DropdownMenuItem(
                            value: map.id,
                            child: Text(map.name ?? "",
                                style: TextStyle(color: Colors.black)),
                          );
                        }).toList(),

                        // videoRecipe
                        //     .map((item) => DropdownMenuItem<VideoRecipeModel>(
                        //           value: item,
                        //           child: Text(
                        //             item.name!,
                        //             style: const TextStyle(
                        //               fontSize: 14,
                        //               fontWeight: FontWeight.bold,
                        //               color: Colors.white,
                        //             ),
                        //             overflow: TextOverflow.ellipsis,
                        //           ),
                        //         ))
                        //     .toList(),
                        value: recipeVideoId,
                        onChanged: (value) {
                          setState(() {
                            recipeVideoId = value;
                            print(recipeVideoId);
                          });
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: 160,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.black26,
                            ),
                            color: Colors.blue,
                          ),
                          elevation: 2,
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_forward_ios_outlined,
                          ),
                          iconSize: 14,
                          iconEnabledColor: Colors.white,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            width: 200,
                            padding: null,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.blue,
                            ),
                            elevation: 8,
                            offset: const Offset(-20, 0),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all(6),
                              thumbVisibility: MaterialStateProperty.all(true),
                            )),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: chkUser,
                        child: Container(
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.save),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                            ),
                            label: model.id != null && model.id != 0
                                ? Text("Edit")
                                : Text('Save'),
                            onPressed: () async {
                              var desc;
                              await htmlKey.currentState!
                                  .getText()
                                  .then((value) => desc = value);
                              if (!validateFields(desc)) {
                                model.id != null && model.id != 0
                                    ? EditRecipe()
                                    : saveRecipe();
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: mdSize.width * 0.02,
                      ),
                      Container(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.close),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                          ),
                          label: Text('Close'),
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigator.pushNamed(context, '/recipelist');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyTextFormField extends StatelessWidget {
  // const MyTextFormField({Key? key}) : super(key: key);
  InputDecoration? dec;
  final Function inputChagedValue;
  final dynamic initialVa;
  final bool enable;
  MyTextFormField(
      {this.initialVa,
      this.dec,
      required this.inputChagedValue,
      required this.enable});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        enabled: enable,
        initialValue: initialVa,
        decoration: dec,
        onChanged: (val) {
          inputChagedValue(val);
        },
      ),
    );
  }
}
