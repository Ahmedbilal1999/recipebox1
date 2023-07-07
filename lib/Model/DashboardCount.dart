import 'package:flutter/material.dart';
import 'dart:convert';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background-2068211_640.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: DashboardContent(), // Replace with your actual page content
        ),
      ),
    );
  }
}

class DashboardCount {
  int? count;
  String? name;

  DashboardCount({
    this.count,
    this.name,
  });

  DashboardCount copyWith({
    int? count,
    String? name,
  }) {
    return DashboardCount(
      count: count ?? this.count,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'count': count,
      'name': name,
    };
  }

  factory DashboardCount.fromMap(Map<String, dynamic> map) {
    return DashboardCount(
      count: map['count']?.toInt(),
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DashboardCount.fromJson(String source) =>
      DashboardCount.fromMap(json.decode(source));

  static List<DashboardCount> allMealPlanModelFromJson(String str) =>
      List<DashboardCount>.from(
          json.decode(str).map((x) => DashboardCount.fromMap(x)));
}

class DashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Dashboard Content'),
    );
  }
}
