import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'model.dart';

// class DataProvider extends ChangeNotifier {
//   List<Entry> _data = [];

//   List<Entry> get data => _data;

//   Future<void> fetchData() async {
//     final response =
//         await http.get(Uri.parse('https://api.publicapis.org/entries'));
//     if (response.statusCode == 200) {
//       // If the server did return a 200 OK response,
//       // then parse the JSON.
//       _data = (jsonDecode(response.body) as List<dynamic>);
//       notifyListeners();
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       throw Exception('Failed to load data');
//     }
//   }
// }

class ProductsProvider with ChangeNotifier {
  DataModel _data;

  DataModel get data => _data;

  Future<DataModel> createAlbum() async {
    final http.Response response = await http.get(
      Uri.parse('https://api.publicapis.org/entries'),
    );

    if (response.statusCode == 200) {
      var _data = DataModel.fromJson(json.decode(response.body));
      notifyListeners();
      return _data;
    } else {
      throw Exception('Failed to create album.');
    }
  }
}
