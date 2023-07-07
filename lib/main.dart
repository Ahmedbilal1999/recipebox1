import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recipebox/Model/RecipeVideoModel.dart';
import 'package:recipebox/Model/recipeModal.dart';
import 'package:recipebox/proile.dart';
import 'package:recipebox/recommandedRecipe.dart';
import 'package:recipebox/splashscreen.dart';
import 'package:recipebox/uploadVideoList.dart';
import 'package:recipebox/uploadvideo.dart';
import 'package:recipebox/weeklyPlanlist.dart';

// import 'dashboard.dart';
import 'dashboard.dart';
import 'favoriteRecipe.dart';
import 'login.dart';
import 'recipelist.dart';
import 'recipemodal.dart';
import 'signUp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MicrophonePermission();
  runApp(MyApp());
}

MicrophonePermission() async {
  var galleryAccessStatus = await Permission.microphone.status;
  if (!galleryAccessStatus.isGranted) {
    var status = await Permission.microphone.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splashscreen',
      routes: {
        '/splashscreen': (context) => splashScreeen(),
        '/login': (context) => loginPage(),
        '/signUp': (context) => signUp(),
        '/dashboard': (context) => dashboard(),
        '/upload': (context) => uploadVideo(model: VideoRecipeModel()),
        '/uploadlist': (context) => uploadVideoList(),
        '/recipelist': (context) => Recipelist(),
        '/recipemodal': (context) => RecipeModal(model: RecipeModel()),
        '/recommandedrecipe': (context) => RecommandedRecipe(),
        '/profile': (context) => Profile(),
        '/weeklyplan': (context) => weeklyPlanlist(),
        '/favorite': (context) => Favorite()
      },
    );
  }
}
