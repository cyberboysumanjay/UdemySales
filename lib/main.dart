import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

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
  @override
  void initState() {
    super.initState();
    this.fetchCourses();
  }

  List courses = [];
  Future<String> fetchCourses() async {
    final response = await http.get("https://sumanjay.vercel.app/udemy");

    setState(() {
      courses = json.decode(response.body);
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                    itemCount: courses == null ? 0 : courses.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Container(
                        child: new Center(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              new Card(
                                child: InkWell(
                                  onTap: () => launch(courses[index]['link']),
                                  child: new Column(children: [
                                    new Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: Image.network(
                                        courses[index]['image'],
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    new Container(
                                      child: new Text(
                                        courses[index]['title'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
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
                    }),
              )
            ]),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
