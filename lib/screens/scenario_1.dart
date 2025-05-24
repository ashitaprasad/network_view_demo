import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'utils.dart';

class Scenario1Page extends StatefulWidget {
  const Scenario1Page({super.key});
  @override
  State<Scenario1Page> createState() => _Scenario1PageState();
}

class _Scenario1PageState extends State<Scenario1Page> {
  int _counter = 1;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<dynamic> getData() async {
    var response = await http.get(
      Uri.parse("https://jsonplaceholder.typicode.com/photos"),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scenario #1")),
      body: FutureBuilder(
        future: getData(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var data = snapshot.data!;
            return ListView.builder(
              itemCount: _counter,
              itemBuilder: (context, index) {
                var cardData = data[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      replaceUrl(cardData['thumbnailUrl']),
                    ),
                    title: Text(cardData['title']),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
