import 'dart:convert';

import 'package:assignment/item_details_screen.dart';
import 'package:assignment/model.dart';
import 'package:assignment/search_screen.dart';
import 'package:assignment/welcome_screen.dart';
import 'package:assignment/wenview_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'api_screen.dart';
import 'detailsProvider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ProductsProvider(),
    child: MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
      ),
      home: MyApp(),
      routes: {
        ItemDetails.routeItem: (context) => ItemDetails(),
        SearchScreen.searchRoute: (context) => SearchScreen(),
        ApiScreen.apiRoute: (context) => ApiScreen()
      },
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Map<String, Object>> _pages;

  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    _pages = [
      {
        'page': ApiScreen(),
        'title': 'Api fetch',
      },
      {
        'page': WelcomeScreen(),
        'title': 'Welcome',
      },
      {
        'page': WebviewScreen(),
        'title': 'Webview',
      },
    ];
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedPageIndex]['page'],
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          backgroundColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.white,
          selectedItemColor: Theme.of(context).accentColor,
          currentIndex: _selectedPageIndex,
          type: BottomNavigationBarType.shifting,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.api),
              label: 'api Fetch',
            ),
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.message),
              label: 'welcome',
            ),
            BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.web),
              label: 'web view',
            ),
          ],
        ));
  }
}
