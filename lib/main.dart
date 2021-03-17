import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Udemy Sales',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Udemy Sales'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Courses>> _getCourses() async {
    final data = await http.get("https://sumanjay.vercel.app/udemy");
    var jsonData = json.decode((data.body));
    List<Courses> courses = [];

    for (var u in jsonData) {
      Courses course =
      Courses(u['description'], u['image'], u['link'], u['title']);
      courses.add(course);
    }
    print(courses.length);
    return courses;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: (widget.title),
      theme: ThemeData.light(),
      home: Scaffold(
        body: Container(
          child: FutureBuilder(
            future: _getCourses(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
                    child: SpinKitWave(
                      color: Colors.red,
                      size: 30.0,
                    ));
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Container(
                        child: new Center(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 8.0),
                                child: new Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.0),
                                  ),
                                  elevation: 8.0,
                                  child: InkWell(
                                    onTap: () =>
                                        launch(snapshot.data[index].link),
                                    child: new Column(children: [
                                      new Container(
                                        width:
                                        MediaQuery.of(context).size.width,
                                        child: Image.network(
                                          snapshot.data[index].image,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      new Container(
                                        child: new Text(
                                          snapshot.data[index].title
                                              .replaceAll("[100% OFF]", ""),
                                          style: GoogleFonts.quicksand(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            20.0, 20.0, 20.0, 5.0),
                                      ),
                                      new Container(
                                        child: new Text(
                                          snapshot.data[index].description,
                                          style: GoogleFonts.quicksand(
                                              fontSize: 10,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            20.0, 0.0, 20.0, 20.0),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20.0, 0.0, 20.0, 20.0),
                                        child: Row(
                                          children: <Widget>[
                                            Text("100% OFF",style: TextStyle(fontWeight: FontWeight.bold, color:Colors.green)),
                                            Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                print(
                                                    '${snapshot.data[index].link}');
                                                Share.share(
                                                    'Check out this Udemy Course ${snapshot.data[index].link}', subject: '${snapshot.data[index].title}');
                                              },
                                              child: Icon(Icons.share,color:Colors.grey,size:20),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
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
          ),
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Courses {
  final String description;
  final String image;
  final String link;
  final String title;

  Courses(this.description, this.image, this.link, this.title);
}
