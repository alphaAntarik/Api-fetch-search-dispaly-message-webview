import 'package:assignment/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'detailsProvider.dart';

class ItemDetails extends StatelessWidget {
  static String routeItem = '/detailRoute';

  // final String title;

  // const ItemDetails(this.title);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    var api = args['api'];
    var description = args['description'];
    var auth = args['auth'];
    var https = args['https'];
    var cors = args['cors'];
    var link = args['link'];
    var category = args['category'];

    //final index = Provider.of<int>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('$api'),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category : $category',
              style: (TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text(
                'Description -',
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(description),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('https : $https'),
                SizedBox(
                  width: 40,
                ),
                Text('auth : $auth'),
                SizedBox(
                  width: 40,
                ),
                Text('Cors : $cors')
              ],
            ),
            SizedBox(
              height: 15,
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: 'to ',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                  text: 'know more',
                  style: TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final url = link;
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    })
            ]))
          ],
        ),
      ),
    );
  }
}
