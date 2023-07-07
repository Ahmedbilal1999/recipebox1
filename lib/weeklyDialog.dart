import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Constant/Service.dart';
import 'Constant/dialog_helper.dart';
import 'Model/weeklyModelsave.dart';
class weeklyModal extends StatefulWidget {
  const weeklyModal({required this.title,required this.recipeId,required this.onSaved,required this.onCancel});
  final String? title;
  final int? recipeId;
final VoidCallback? onSaved;
final VoidCallback? onCancel;
  @override
  State<weeklyModal> createState() => _weeklyModalState();
}

class _weeklyModalState extends State<weeklyModal> {

  static final noww = new DateTime.now();
  String currentdate = DateFormat('yMd').format(noww);
  DateTime? date;

  baseService ser = baseService();

  saveWeeklyPlan()async{
    var obj = WeeklyModelSave(
        recipeId:widget.recipeId,
        startDate: date != null ? date : DateTime.tryParse(currentdate.toString()));
    print('Before Date ${date}');
    print('Current Before Date ${DateTime.tryParse(currentdate.toString())}');
    DialogHelper.showLoading(context);
    var res = await ser.AddWeeklyRecipe(obj);
    if (res.statusCode == 200) {
      print('Save Weekly Recipe ${res.body}');
      DialogHelper.hideLoading(context);
      print(res.body);
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Recipe has been successfully added to weekly'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
        onVisible: (){
          Navigator.pushNamed(context, '/recipelist');
        },
      ));
    }else{
      DialogHelper.hideLoading(context);
      print('Weekly Recipe Error ${res.body}');
      var errorDecode = json.decode(res.body);
      String error = errorDecode["errors"][0];
      ser.snackBarTextWhileRegiter(context, error, "Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    var mdSize = MediaQuery.of(context).size;
    return Dialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: Text('Add Weekly Plan',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25,color: Colors.deepOrange ),),
              ),
              Divider(),
              Container(
                padding: const EdgeInsets.only(left:20),
                child: Row(
                  children:[
                    Container(
                      child:Text('Recipe',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: Colors.deepOrange ),)
                    ),
                    Container(
                        padding: const EdgeInsets.only(left: 25),
                        child:Text(widget.title.toString())
                    )
                  ]
                )
              ),
              Container(
                padding: const EdgeInsets.only(top: 25,left:10,right: 10),
                width: mdSize.width * 0.9,
                child: ElevatedButton(
                    child: date != null
                        ? Text(DateFormat('yMd').format(date as DateTime))
                        : Text(currentdate),
                    onPressed: () {
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
                    }),
              ),
              SizedBox(height: mdSize.height*0.01,),
              Container(
                padding: const EdgeInsets.only(right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.save),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(50))),
                        ),
                        label:Text('Save'),
                        onPressed: saveWeeklyPlan,
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
                        onPressed: (){
                          Navigator.pop(context);
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
    );
  }
}
