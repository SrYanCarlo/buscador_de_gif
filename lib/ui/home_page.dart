import 'dart:convert';
import 'dart:async';

import "package:flutter/material.dart";
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _offset = 0;

  String _search;

  Future<Map> _getGifs() async {
    http.Response response;
    if (_search == null) {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=uGWFXUXECEyQhSstVOSuNwNrgAVTGtPN&limit=25&rating=R");
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=uGWFXUXECEyQhSstVOSuNwNrgAVTGtPN&q=$_search&limit=25&offset=$_offset&rating=R&lang=en");
    }

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 7.5, 10.0, 7.5),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Buscar GIF",
                  labelStyle: TextStyle(color: Colors.white, fontSize: 16.0),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
              style: TextStyle(color: Colors.white, fontSize: 17.5),
              textAlign: TextAlign.center,
              onSubmitted: (text){
                setState(() {
                  _search = text;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createGifTable(context, snapshot);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: snapshot.data["data"].length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Image.network(
            snapshot.data["data"][index]["images"]["fixed_height"]["url"],
            height: 300.0,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
