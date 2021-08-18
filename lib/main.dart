import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

// #docregion MyApp
class MyApp extends StatelessWidget {
  // #docregion build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generador de palabras',
      home: RandomWords(),
    );
  }
  // #enddocregion build
}
// #enddocregion MyApp

// #docregion RWS-var
class _RandomWordsState extends State<RandomWords> {
  List<String> dogImages = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchFive();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //if we are at the bottom of the page
        fetchFive();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  fetch() async {
    var url = Uri.parse(
        "https://palabras-aleatorias-public-api.herokuapp.com/random");
    var client = http.Client();
    var request = await client.get(url);
    setState(() {
      dogImages.add(jsonDecode(request.body)["body"]["Word"].toString());
    });
  }

  fetchFive() {
    for (int i = 0; i < 40; i++) {
      fetch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Palabras Aleatorias"),
        backgroundColor: Colors.brown,
      ),
      body: ListView.builder(
          controller: _scrollController,
          itemCount: dogImages.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                constraints: BoxConstraints.tightFor(height: 50.0),
                child: ListTile(
                  title: Text(dogImages[index]),
                  trailing: Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                ));
          }),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<RandomWords> createState() => _RandomWordsState();
}
