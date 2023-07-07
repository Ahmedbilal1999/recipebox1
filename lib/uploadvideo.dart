import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipebox/Constant/Loadder.dart';
import 'package:recipebox/Constant/Service.dart';
import 'package:recipebox/Model/RecipeVideoModel.dart';
import 'package:recipebox/videoWidget.dart';

import 'Constant/dialog_helper.dart';
import 'baseWidget.dart';

class uploadVideo extends StatefulWidget {
  final VideoRecipeModel model;
  const uploadVideo({required this.model, Key? key}) : super(key: key);

  @override
  State<uploadVideo> createState() => _uploadVideoState(args: model);
}

class _uploadVideoState extends State<uploadVideo> {
  bool isvideoLoad = false;
  final VideoRecipeModel args;
  var recipeName;
  var descriptionVal;
  _uploadVideoState({required this.args});
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  bool chkUser = false;
  Future<File?> pickVideoFromGallery() async {
    print('Vido File var ${videoFile}');
    print('Video var ${video}');
    final picker = ImagePicker();
    var pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }

    return null;
  }

  Widget? video;
  File? videoFile;

  void selectVideoFromGallery() async {
    videoFile = (await pickVideoFromGallery());
    if (videoFile != null) {
      File selectedFile = File(videoFile!.path);
      // print(selectedFile);
      setState(() {
        video = videoWidget(selectedFile);
      });
      // Do something with the selected video file
    }
  }

  snackBarText(txt) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${txt}'),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 1),
    ));
  }

  validateFields() {
    bool validate = false;

    if (video == null) {
      snackBarText('Please upload a video');
      validate = true;
    } else if (nameController.text.isEmpty) {
      snackBarText('Name is required');
      validate = true;
    } else if (descriptionController.text.isEmpty) {
      snackBarText('Description is required');
      validate = true;
    } else {
      validate = false;
    }
    return validate;
  }
  baseService service = baseService();
  saveVideo() {

    var name = nameController.text;
    var description = descriptionController.text;
    DialogHelper.showLoading(context);
    service.RecipeVideo(videoFile, description, name)
        .then((value) => {
              print("Recipe Vieo kl"),
              DialogHelper.hideLoading(context),
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Record saved successfully'),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
      onVisible: (){
        Navigator.pushNamed(context, '/uploadlist');
      },
    ))

            })
        .catchError(() => {DialogHelper.hideLoading(context)});
  }

  @override
  void initState() {
    fillData();
    super.initState();
  }

  fillData() async {
    print('Add Pe chlaa');
    chkUser = await service.CheckUserType();

    if (args !=null && args.id != null && args.id != 0) {
     nameController.text = args.name ?? "";
   recipeName = args.name ?? "";
      descriptionController.text = args.description ?? "";
      descriptionVal = args.description ?? "";
      if (args.fileUrl != null) {
        File selectedFile = File(args.fileUrl ?? "");
        await _downloadFile(selectedFile.path, "sd").then((value) {
          setState(() {
            videoFile = value;
            video = videoWidget(videoFile!);
          });
        });
        print(selectedFile);
      }
    }else{
      setState(() {

      });
    }
  }

  Future<File> _downloadFile(String url, String filename) async {
    isvideoLoad = true;
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    isvideoLoad = false;
    return file;
  }

  EditVideo(int id, BuildContext context) async {
    if (id != 0) {
      DialogHelper.showLoading(context);
      baseService service = baseService();
      var name = nameController.text;
      var description = descriptionController.text;
      try {
        var respone = await service.RecipeVideoEdit(
            videoFile, description, name, id, context);

        if (respone.statusCode == 200) {
          DialogHelper.hideLoading(context);
        return  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Record updated successfully'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
            onVisible: (){
              Navigator.pushNamed(context, '/uploadlist');
            },
          ));
        } else {
          DialogHelper.hideLoading(context);
        }
      } catch (ex) {
        DialogHelper.hideLoading(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var mdSize = MediaQuery.of(context).size;
    return baseWidget(
      menuTitle: 'Upload Video',
      showWidget: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                width: mdSize.width * double.infinity,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text('Upload'),
                  onPressed: () {
                    if(chkUser) {
                      print(chkUser);
                      if (videoFile != null) {
                        setState(() {
                          videoFile = null;
                          video = null;
                        });
                      }
                      selectVideoFromGallery();
                    }
                  },

                ),
              ),
              !isvideoLoad
                  ? Container(
                      color: video != null ? Colors.black : Colors.transparent,
                      child: video != null
                          ? video
                          : Icon(Icons.cloud_upload_rounded, size: 120),
                    )
                  : Loader(),
              SizedBox(
                height: mdSize.height * 0.02,
              ),
              Container(
                width: mdSize.width * 0.9,
                child: TextField(
                  controller: nameController,
                  enabled: chkUser,
                  decoration: InputDecoration(
                    labelText: 'Enter Name',
                    hintText: 'Enter Name',
                  ),
                  onChanged: (value) {
                    recipeName = value;
                  },
                ),
              ),
              SizedBox(
                height: mdSize.height * 0.02,
              ),
              Container(
                width: mdSize.width * 0.9,
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  enabled: chkUser,
                  controller: descriptionController,
                  decoration: InputDecoration(
                      labelText: 'Enter Description',
                      hintText: 'Enter Description',
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.redAccent))),
                  onChanged: (value) {
                    descriptionVal = value;
                  },
                ),
              ),
              SizedBox(
                height: mdSize.height * 0.02,
              ),
              Container(
                padding: const EdgeInsets.only(right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible:chkUser,
                      child: Container(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.save),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                          ),
                          label: args != null && args.id !=null
                              ? Text('Edit')
                              : Text('Save'),
                          onPressed: () {
                            if (!validateFields()) {
                              args != null && args.id !=null
                                  ? EditVideo(args.id!.toInt(), context)
                                  : saveVideo();
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
                          Navigator.pushNamed(context, '/uploadlist');
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
