// ignore: import_of_legacy_library_into_null_safe

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

import 'dart:async';

// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import 'apply2.dart';
import 'model.dart';

class Wall extends StatefulWidget {
  Wall({Key key}) : super(key: key);

  @override
  _WallState createState() => _WallState();
}

class _WallState extends State<Wall> {
  bool isLoading = false;
  int pageCount = 30;
  ScrollController _scrollController;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _scrollController = new ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
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
    var url =
        "https://raw.githubusercontent.com/jatinr333/Wallsapi/main/dark/darkwalls.json";
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

  void status() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      //  _getUsers();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: "Network is not available",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder:
            (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
          if (snapshot != null &&
              snapshot.hasData &&
              snapshot.data != ConnectivityResult.none) {
            return FutureBuilder(
              future: fetchwalls(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                print(snapshot.data);
                if (snapshot.data == null) {
                  return Center(
                      child: Container(child: CircularProgressIndicator()));
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
                                        offset: Offset(-3,
                                            -6), // changes position of shadow
                                      ),
                                    ],
                                        borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(18.0),
                                          bottomRight:
                                              const Radius.circular(18.0),
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
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
            // return Lottie.asset("assets/offline.json",
            //     width: 200, height: 200, fit: BoxFit.cover);
          }
        },
      ),
    );
  }
}
