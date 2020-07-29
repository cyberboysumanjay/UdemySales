import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      theme: ThemeData.dark(),
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
                              new Card(
                                child: InkWell(
                                  onTap: () =>
                                      launch(snapshot.data[index].link),
                                  child: new Column(children: [
                                    new Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: Image.network(
                                        snapshot.data[index].image,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    new Container(
                                      child: new Text(
                                        snapshot.data[index].title,
                                        style: GoogleFonts.quicksand(),
                                      ),
                                      padding: const EdgeInsets.all(20.0),
                                    ),
                                  ]),
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
