import 'dart:convert';
import 'dart:io';

import 'package:assignment/item_details_screen.dart';
import 'package:assignment/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;

import 'main.dart';
import 'model.dart';

Future<DataModel> createAlbum() async {
  final http.Response response = await http.get(
    Uri.parse('https://api.publicapis.org/entries'),
  );

  if (response.statusCode == 200) {
    return DataModel.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class ApiScreen extends StatefulWidget {
  static String apiRoute = '/apiRoute';
  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  Future<DataModel> _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Api fetch"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          },
        ),
      ),
      body: _futureAlbum == null
          ? Center(
              child: TextButton(
                child: Text("Fetch Data"),
                onPressed: () {
                  setState(() {
                    _futureAlbum = createAlbum();
                  });
                },
              ),
            )
          : Center(
              child: Column(
                children: [
                  Expanded(
                    child: FutureBuilder<DataModel>(
                      future: _futureAlbum,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Center(
                            child: ListView.builder(
                                itemCount: snapshot.data.count,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    elevation: 2,
                                    child: Column(
                                      children: [
                                        ListTile(
                                            leading: const Icon(Icons.list),
                                            trailing: Text(
                                              "${snapshot.data.entries[index].category}",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 15),
                                            ),
                                            title: Text(
                                              "${snapshot.data.entries[index].api}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            //Text("${snapshot.data.entries[index].description}"),
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          ItemDetails.routeItem,
                                                          arguments: {
                                                        'index': index,
                                                        'api': snapshot.data
                                                            .entries[index].api,
                                                        'description': snapshot
                                                            .data
                                                            .entries[index]
                                                            .description,
                                                        'auth': snapshot
                                                            .data
                                                            .entries[index]
                                                            .auth,
                                                        'https': snapshot
                                                            .data
                                                            .entries[index]
                                                            .https,
                                                        'cors': snapshot
                                                            .data
                                                            .entries[index]
                                                            .cors,
                                                        'link': snapshot
                                                            .data
                                                            .entries[index]
                                                            .link,
                                                        'category': snapshot
                                                            .data
                                                            .entries[index]
                                                            .category
                                                      });
                                                },
                                                icon: Icon(Icons.more))
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          );
                        } else if (snapshot.hasError) {
                          return CircularProgressIndicator();
                        }

                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(SearchScreen.searchRoute);
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
