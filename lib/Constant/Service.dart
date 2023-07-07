import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipebox/Model/UserFavorite.dart';
import 'package:recipebox/Model/UserRating.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/recipeModal.dart';
import '../Model/weeklyModelsave.dart';

class baseService {
  var baseUrl = 'https://foodbackendrecipe.bsite.net/';
  var headers = {
    "Accept": "application/json",
    "content-type": "application/json"
  };

  Widget noRecordFound =  Container(
                    child: Column(
                      children:
                     [
                      
                      Center(
                        child: Container(child: Text('No record found',style: TextStyle(
                          color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold
                        ),),),
                      )
                    ]),
                  );

  Future<Map<String, String>> GetHeader() async {
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString("Token") as String;
    var headersWithToken = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer " + token,
    };
    return headersWithToken;
  }

  Future<http.Response> registerUser(dynamic user) async {
    var url = Uri.parse(baseUrl + 'api/User');
    print(url);
    var obj = {
      "FirstName": user.FirstName,
      "LastName": user.LastName,
      "Username": user.Username,
      "Password": user.Password,
      "UserType": user.UserType
    };
    print('User Register ${obj}');
    var userPayLoad = json.encode(obj);
    print(userPayLoad);

    var respone = await http.post(url, headers: headers, body: userPayLoad);
    return respone;
  }

  Future<http.Response> logInUser(dynamic user) async {
    var url = Uri.parse(baseUrl + 'api/User/Login');
    print(url);
    var newUser = {"Username": user.Username, "Password": user.Password};
    var userPayLoad = json.encode(newUser);
    print(userPayLoad);

    var respone = await http.post(url, headers: headers, body: userPayLoad);
    return respone;
  }

  Future<void> RecipeVideo(File? file, String description, String name) async {
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString("Token") as String;
    var uri = Uri.parse(baseUrl + "api/RecipeVideo");
    var request = new http.MultipartRequest("POST", uri);
    final fileHeader = {
      "Authorization": "Bearer " + token,
    };
    final paramerts = {
      "name": name,
      "Description": description,
      "date": DateTime.now().toString()
    };
    print(paramerts);
    request.headers.addAll(fileHeader);
    var multipartFile = await http.MultipartFile.fromPath("file", file!.path);
    request.files.add(multipartFile);
    request.fields.addAll(paramerts);

    http.StreamedResponse response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    if (response.statusCode == 200) {
      print("Video uploaded");
    } else {
      print("Video upload failed");
    }

    // listen for response
  }

  Future<http.Response> getRecipeVideo() async {
    var url = Uri.parse(baseUrl + 'api/RecipeVideo');
    var header = await GetHeader();
    var respone = await http.get(url, headers: header);
    return respone;
  }

  Future<http.Response> getRecipeVideoById(int id) async {
    var url = Uri.parse(baseUrl + 'api/RecipeVideo/$id');
    var header = await GetHeader();
    var respone = await http.get(url, headers: header);
    return respone;
  }

  // Future<http.Response> AddRecipe(RecipeModel recipe) async {
  //   var url = Uri.parse(baseUrl + 'api/Recipe');
  //   var header = await GetHeader();
  //   print('Add User Recipe Call ${recipe.date}');
  //   var obje = {
  //     "title": recipe.title,
  //     "discription": recipe.discription,
  //     "date": recipe.date?.toIso8601String(),
  //     "recipeVideoId": recipe.recipeVideoId
  //   };
  //   var obj = json.encode(obje);
  //   print('Add Recipe Call ${obje}');
  //   var respone = await http.post(url, headers: header, body: obj);
  //   return respone;
  // }
  Future<http.StreamedResponse> AddRecipe(File? file, RecipeModel model) async {
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString("Token") as String;
    var uri = Uri.parse(baseUrl + "api/Recipe");
    var request = new http.MultipartRequest("POST", uri);
    final fileHeader = {
      "Authorization": "Bearer " + token,
    };
    final paramerts = {
      "title": "${model.title}",
      "discription": "${model.discription}",
      "date": DateTime.now().toIso8601String(),
      if (model.recipeVideo != null || model.recipeVideo != 0)
        "recipeVideoId": model.recipeVideoId.toString()
    };

    request.headers.addAll(fileHeader);
    if (file != null) {
      var multipartFile = await http.MultipartFile.fromPath("file", file.path);
      request.files.add(multipartFile);
    }
    request.fields.addAll(paramerts);

    http.StreamedResponse response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
    return response;

    // listen for response
  }

  Future<http.StreamedResponse> RecipeEdit(
      File? file, RecipeModel model, BuildContext context) async {
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString("Token") as String;
    var uri = Uri.parse(baseUrl + "api/Recipe/${model.id}");
    var request = new http.MultipartRequest("PUT", uri);
    final fileHeader = {
      "Authorization": "Bearer " + token,
    };
    final paramerts = {
      "id": model.id.toString(),
      "title": model.title ?? "",
      "discription": model.discription ?? "",
      "date": DateTime.now().toIso8601String(),
      if (model.recipeVideo != null || model.recipeVideo != 0)
        "recipeVideoId": model.recipeVideoId.toString()
    };
    // var copy = file!.copySync(file.path);
    request.headers.addAll(fileHeader);

    http.MultipartFile? multipartFile = null;
    if (file != null) {
      multipartFile = await http.MultipartFile.fromPath("file", file.path);
      request.files.add(multipartFile);
    }
    request.fields.addAll(paramerts);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) await file?.delete();

    return response;
  }

  Future<http.Response> DeleteRecipe(dynamic id) async {
    var url = Uri.parse(baseUrl + 'api/Recipe/${id}');
    var header = await GetHeader();
    print('Delete Receipe Id ${id}');
    var respone = await http.delete(url, headers: header);
    return respone;
  }

  Future<http.Response> DeleteVideoRecipe(int id) async {
    var url = Uri.parse(baseUrl + 'api/RecipeVideo/$id');
    var header = await GetHeader();
    var respone = await http.delete(url, headers: header);
    return respone;
  }

  Future<http.StreamedResponse> RecipeVideoEdit(File? file, String description,
      String name, int id, BuildContext context) async {
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString("Token") as String;
    var uri = Uri.parse(baseUrl + "api/RecipeVideo/$id");
    var request = new http.MultipartRequest("PUT", uri);
    final fileHeader = {
      "Authorization": "Bearer " + token,
    };
    final paramerts = {
      "id": id.toString(),
      "name": name,
      "Description": description,
      "date": DateTime.now().toString()
    };
    // var copy = file!.copySync(file.path);
    request.headers.addAll(fileHeader);
    var multipartFile = await http.MultipartFile.fromPath("file", file!.path);
    request.files.add(multipartFile);
    request.fields.addAll(paramerts);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) await file.delete();

    return response;
  }

  snackBarTextWhileRegiter(context, txt, type) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.only(left: 0, bottom: 0),

            // titleTextStyle: TextStyle(
            //   backgroundColor: type == "Error" ? Colors.red : Colors.green
            // ),
            title: Container(
              padding: const EdgeInsets.only(left: 20, bottom: 10, top: 5),
              width: double.infinity,
              color: type == "Error" ? Colors.red : Colors.green,
              child: Text(
                type,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800),
              ),
            ),
            content: Text('${txt}'),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          type == "Error" ? Colors.red : Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: type == "Error" ? Text('Cancel') : Text('Ok'))
            ],
          );
        });
  }

  Future<http.Response> getUserRecipe() async {
    var url = Uri.parse(baseUrl + 'api/Recipe/');
    var header = await GetHeader();
    var respone = await http.get(url, headers: header);
    return respone;
  }

  Future<http.Response> Shuffle() async {
    var url = Uri.parse(baseUrl + 'api/Recipe/Shuffle');
    print('data ${url}');
    var header = await GetHeader();
    var respone = await http.get(url, headers: header);
    return respone;
  }

  Future<http.Response> EditRecipe(RecipeModel model) async {
    var url = Uri.parse(baseUrl + 'api/Recipe/${model.id}');
    print('data ${url}');
    var header = await GetHeader();
    var jsonDecode = json.encode(model.toMap());
    var respone = await http.put(url, headers: header, body: jsonDecode);
    return respone;
  }

  Future<http.Response> SearchRecipe(String filter) async {
    var url = Uri.parse(baseUrl + 'api/Recipe/Search?filter=$filter');
    print('data ${url}');
    var header = await GetHeader();
    var respone = await http.get(url, headers: header);
    return respone;
  }

  Future<http.Response> AddWeeklyRecipe(WeeklyModelSave recipe) async {
    var url = Uri.parse(baseUrl + 'api/WeeklyPlan');
    var header = await GetHeader();
    print('Add User Weeekly Recipe Call ${recipe.recipeId}');
    var obje = {
      "recipeId": recipe.recipeId,
      "startDate": recipe.startDate != null
          ? recipe.startDate?.toIso8601String()
          : DateTime.now().toIso8601String(),
    };
    var obj = json.encode(obje);
    print('Add Weekly Recipe Call ${obje}');
    var respone = await http.post(url, headers: header, body: obj);
    return respone;
  }

  Future<http.Response> getWeeklyPlan() async {
    var url = Uri.parse(baseUrl + 'api/WeeklyPlan');
    print('data Weekly Plan ${url}');
    var header = await GetHeader();
    var respone = await http.get(url, headers: header);
    return respone;
  }

  Future<http.Response> dashboardCount() async {
    var url = Uri.parse(baseUrl + 'api/Recipe/DashboardCount');
    print('data Weekly Plan ${url}');
    var header = await GetHeader();
    var respone = await http.get(url, headers: header);
    return respone;
  }

  Future<http.Response> IsFavorite(UserFavorite userFavorite) async {
    var body = userFavorite.toMap();
    var obj = json.encode(body);
    var url = Uri.parse(baseUrl + 'api/Recipe/UserFavorite');
    print('data Weekly Plan ${url}');
    var header = await GetHeader();
    var respone = await http.post(url, body: obj, headers: header);
    return respone;
  }

  Future<http.Response> Rating(UserRating userFavorite) async {
    var body = userFavorite.toJson();
    var url = Uri.parse(baseUrl + 'api/Recipe/UserRating');
    print('data Weekly Plan ${url}');
    var header = await GetHeader();
    var respone = await http.post(url, body: body, headers: header);
    return respone;
  }

  Future<bool> CheckUserType() async {
    var pref = await SharedPreferences.getInstance();
    bool chkType = false;
    if (pref != null) {
      var user = pref.getInt("UserType");
      if (user == 1) {
        chkType = true;
      } else if (user == 2) {
        chkType = false;
      }
    }
    return chkType;
  }

  Future<http.Response> getFavoriteRecipe() async {
    var url = Uri.parse(baseUrl + 'api/Recipe/GetFavorite');
    print('data Favorite ${url}');
    var header = await GetHeader();
    var respone = await http.get(url, headers: header);
    return respone;
  }
}
