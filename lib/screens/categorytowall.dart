// ignore: import_of_legacy_library_into_null_safe

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

import 'dart:async';

// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

import 'apply2.dart';
import 'model.dart';

class Wall extends StatefulWidget {
  Wall({Key key, this.url, this.name}) : super(key: key);

  final String url;
  final String name;
  @override
  _WallState createState() => _WallState(this.url, this.name);
}

class _WallState extends State<Wall> {
  _WallState(this.url, this.name);

  final String url;
  final String name;
  bool isLoading = false;
  int pageCount = 30;
  ScrollController _scrollController;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _scrollController = new ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
    print(url);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        print("comes to bottom $isLoading");
        isLoading = true;

        if (isLoading) {
          print("RUNNING LOAD MORE");
          pageCount = pageCount + 30;
        }
      });
    }
  }

  Future<List<Walls>> fetchwalls() async {
    //print(url);
    // Await the http get response, then decode the json-formatted responce.
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      //var jsonResponse = convert.jsonDecode(response.body);
      //print(jsonResponse);

      final result = wallsFromJson(response.body);
      //print("hello");

      return result;
    } else {
      print("Request failed with status: ${response.statusCode}.");

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[600],
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: new Text(name),
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchwalls(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print(snapshot.data);
            if (snapshot.data == null) {
              return Center(
                  child: Container(
                      child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              )));
            } else {
              return GridView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: pageCount,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: (0.65), crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return Hero(
                      tag: snapshot.data[index].imgSrc,
                      child: Padding(
                          padding: EdgeInsets.all(9),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImageView(
                                            imgPath:
                                                snapshot.data[index].imgSrc,
                                          )));

                              // print(snapshot.data[index].imgsrc);
                            },
                            child: Container(
                                decoration: new BoxDecoration(
                                    boxShadow: [
                                  BoxShadow(
                                    color: Colors.white12.withOpacity(0.35),
                                    spreadRadius: 1.5,
                                    blurRadius: 2,
                                    offset: Offset(
                                        -3, -6), // changes position of shadow
                                  ),
                                ],
                                    borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(18.0),
                                      bottomRight: const Radius.circular(18.0),
                                    ),
                                    image: new DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            snapshot.data[index].imgThumb),
                                        fit: BoxFit.cover))),
                          )),
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
