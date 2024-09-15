import 'package:app_usage_rnd_android/db/database_helper.dart';
import 'package:app_usage_rnd_android/models/user_profile_model.dart';
import 'package:flutter/material.dart';

class DbScreen extends StatefulWidget {
  const DbScreen({super.key});

  @override
  State<DbScreen> createState() => _DbScreenState();
}

class _DbScreenState extends State<DbScreen> {
  final dbHelper = DatabaseHelper.instance;
  List<UserProfile> dataViewList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('DB Screen'),
        ),
        body: Center(
            child: Column(
          children: [
            Expanded(
              child: dataViewList.isEmpty
                  ? Text('No Records Found')
                  : ListView.builder(
                      itemCount: dataViewList.length,
                      itemBuilder: (context, index) {
                        final user = dataViewList[index];
                        return ListTile(
                          title: Text(
                              "email: ${user.email}, id: ${user.id}"), // 이메일 출력
                          subtitle: Text(
                              'Age: ${user.age}, Gender: ${user.gender}, Device: ${user.device}, app_usage: ${user.appUsage}, notification: ${user.notifications}, health: ${user.notifications}'),
                        );
                      },
                    ),
            ),
            ElevatedButton(
              onPressed: () async {
                // DB Read
                final allRows = await dbHelper.queryAllUserProfiles();
                setState(() {
                  dataViewList = allRows;
                });
              },
              child: Text('All Records Read'),
            ),
          ],
        )));
  }
}
