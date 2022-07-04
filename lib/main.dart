import 'package:countries_list_with_graphql/provider/providers.dart';
import 'package:countries_list_with_graphql/screens/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => CountryProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Country Details',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}