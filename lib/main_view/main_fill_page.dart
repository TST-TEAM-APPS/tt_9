import 'package:flutter/material.dart';
import 'package:tt_9/main_view/add_new_opperation_page.dart';

class MainFillPage extends StatefulWidget {
  const MainFillPage({super.key});

  @override
  State<MainFillPage> createState() => _MainFillPageState();
}

class _MainFillPageState extends State<MainFillPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddNewOperationPage()));
                },
                child: Text('awd')),
          )
        ],
      ),
    ));
  }
}
