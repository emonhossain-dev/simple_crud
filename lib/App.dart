import 'package:curd_tudo/Screen/UI/home_screen.dart';
import 'package:flutter/material.dart';

import 'Screen/UI/add_Data.dart';
import 'Screen/UI/update_data.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    debugShowCheckedModeBanner: false;
    return MaterialApp(

      initialRoute: HomeScreen.name,
      routes: {

        HomeScreen.name : (context) => const HomeScreen(),
        AddData.name : (context) => const AddData(),
        //UpdateData.name : (context) => const UpdateData(),



      },


    );
  }
}
