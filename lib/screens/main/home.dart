import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/app-usage');
              },
              child: Text('App Usage'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/health-connect');
              },
              child: Text('Health Connect'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/notification');
              },
              child: Text('Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
