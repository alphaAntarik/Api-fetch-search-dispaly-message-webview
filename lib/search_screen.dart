import 'dart:convert';
import 'dart:io';

import 'package:assignment/item_details_screen.dart';
import 'package:assignment/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;

import 'api_screen.dart';
import 'model.dart';

Future<DataModel> createAlbum(String searchk) async {
  final http.Response response = await http.get(
    Uri.parse('https://api.publicapis.org/entries?category=$searchk'),
  );

  if (response.statusCode == 200) {
    return DataModel.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class SearchScreen extends StatefulWidget {
  static String searchRoute = '/searchRoute';
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<DataModel> _futureAlbum;

  @override
  Widget build(BuildContext context) {
    TextEditingController _textController = TextEditingController();
    String _displayText = '';

    @override
    void dispose() {
      _textController.dispose();
      super.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushNamed(ApiScreen.apiRoute),
        ),
      ),
      body: _futureAlbum == null
          ? Container(
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'search',
                    ),
                  )),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _futureAlbum = createAlbum(_textController.text);
                        });
                      },
                    ),
                  ),
                ],
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
