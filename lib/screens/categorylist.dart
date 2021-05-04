import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'categorymodel.dart';
import 'package:wall4k/screens/categorytowall.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Future<List<Category>> fetchCat() async {
    var url =
        "https://raw.githubusercontent.com/jatinr333/Wallsapi/main/dark/category.json";
    // Await the http get response, then decode the json-formatted responce.
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      //var jsonResponse = convert.jsonDecode(response.body);
      //print(jsonResponse);

      final result = categoryFromJson(response.body);

      //print("hello");

      return result;
    } else {
      print("Request failed with status: ${response.statusCode}.");

      return null;
    }
  }

  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder(
      future: fetchCat(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print(snapshot.data);
        if (snapshot.data == null) {
          return Center(child: Container(child: CircularProgressIndicator()));
        } else {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Wall(
                                    url: snapshot.data[index].url,
                                    name: snapshot.data[index].name,
                                  )));
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  snapshot.data[index].image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black54,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Center(
                            child: Text(
                              snapshot.data[index].name.toUpperCase(),
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Raleway',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        }
      },
    ));
  }
}
