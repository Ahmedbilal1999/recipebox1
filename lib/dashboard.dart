import 'package:flutter/material.dart';
import 'package:recipebox/Constant/Loadder.dart';
import 'package:recipebox/Constant/Service.dart';
import 'package:recipebox/Model/DashboardCount.dart';

import 'baseWidget.dart';

class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  List<DashboardCount> lstDashboardCount = [];
  Future<void> Getdashboard() async {
    baseService service = baseService();
    // DialogHelper.showLoading(context);
    var response = await service.dashboardCount();
    if (response.statusCode == 200) {
      lstDashboardCount =
          DashboardCount.allMealPlanModelFromJson(response.body);
      print('Recipe Steps ${response.body}');
      // DialogHelper.hideLoading(context);
    } else {
      // DialogHelper.hideLoading(context);
    }
  }

  @override
  void initState() {
    Getdashboard().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mdSize = MediaQuery.of(context).size;
    return baseWidget(
        menuTitle: 'Dashboard',
        showWidget: Container(
           decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage('images/background-2068211_640.jpg'),
      fit: BoxFit.cover,
    ),
  ),
          // height: mdSize.height * 0.9,

          child: Column(
            children: [
              SizedBox(height: mdSize.height * 0.1,),
              SingleChildScrollView(
                child: Container(
                  child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 25.0,
                        mainAxisExtent: 230.0,
                        crossAxisSpacing: 10.0
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: lstDashboardCount.length,
                      itemBuilder: (BuildContext context, int index) {
                        return lstDashboardCount.length == 0
                            ? Loader()
                            : Container(
                          child: Card(
                            elevation: 40,
                            shadowColor: const Color.fromARGB(255, 189, 47, 47),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Container(
                              height: mdSize.height * 0.8,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [

                                    Expanded(
                                      child: Container(
                                        child:lstDashboardCount[index].name == 'Videos'
                                            ? Icon(Icons.video_call_rounded,size: 100,
                                          color: Color.fromARGB(255, 4, 119, 139),) : lstDashboardCount[index].name == 'Recipe'
                                            ? Icon(Icons.no_food,size: 100,color: Color.fromARGB(255, 4, 119, 139),) : lstDashboardCount[index].name == 'Recommend' ?
                                        Icon(Icons.recommend,size: 100,color: Color.fromARGB(255, 4, 119, 139),) : lstDashboardCount[index].name == 'Weekly' ?
                                        Icon(Icons.next_week_rounded,size: 100,color: Color.fromARGB(255, 4, 119, 139)) : Icon(Icons.disabled_by_default),
                                      ),
                                    ),
                                    SizedBox(height: mdSize.height*0.08,),
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                            "${lstDashboardCount[index].name}",
                                            style: TextStyle(
                                              color: lstDashboardCount[index].name == 'Videos' ? Color.fromARGB(255, 4, 119, 139):
                                              lstDashboardCount[index].name == 'Recipe' ? Color.fromARGB(255, 4, 119, 139) :
                                              lstDashboardCount[index].name == 'Recommend' ? Color.fromARGB(255, 4, 119, 139) :
                                              lstDashboardCount[index].name == 'Weekly' ? Color.fromARGB(255, 4, 119, 139) :Colors.deepOrange ,
                                                fontSize: 25,
                                              fontWeight: FontWeight.w800
                                            )),
                                      ),),
                                    SizedBox(height: mdSize.height*0.01,),
                                    Expanded(child:
                                    Container(
                                      child: Text(
                                        "${lstDashboardCount[index].count}",
                                        style: TextStyle(
                                            color: lstDashboardCount[index].name == 'Videos' ? Color.fromARGB(255, 4, 119, 139):
                                            lstDashboardCount[index].name == 'Recipe' ? Color.fromARGB(255, 4, 119, 139) :
                                            lstDashboardCount[index].name == 'Recommend' ? Color.fromARGB(255, 4, 119, 139) :
                                            lstDashboardCount[index].name == 'Weekly' ? Color.fromARGB(255, 4, 119, 139) :Color.fromARGB(255, 4, 119, 139) ,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold
                                        ),),
                                    ))
                                  ]),
                            ),
                          ),
                        );
                      }),
                )),
            ],
          )
        ));
  }
}
