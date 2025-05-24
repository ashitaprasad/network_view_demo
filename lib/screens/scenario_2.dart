import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Scenario2Page extends StatefulWidget {
  const Scenario2Page({super.key});
  @override
  State<Scenario2Page> createState() => _Scenario2PageState();
}

class _Scenario2PageState extends State<Scenario2Page> {
  int _counter = 1;
  late Future<dynamic> _data;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    _data = getData();
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
        future: _data,
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
                    leading: Image.network(cardData['thumbnailUrl']),
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
