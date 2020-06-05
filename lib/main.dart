import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bmicalc/api_backend/api.dart';
import 'package:bmicalc/url/url.dart';

void main() {
  runApp(ISSLoc());
}

class ISSLoc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "ISS Locator",
      home: Scaffold(
        appBar: AppBar(
          title: Text("ISS Locator"),
          backgroundColor: Colors.orange,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.orange,
                ),
                child: Text(
                  "ISS Locator",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('Developer information'),
                onTap: () {
                  launchURL();
                },
              ),
            ],
          ),
        ),
        body: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  createState() => AppLayout();
}

class AppLayout extends State<Home> {
  Future futureAlbum;

  @override
  void initState() {
    super.initState();
    setUpTimedFetch();
  }

  setUpTimedFetch() {
    Timer.periodic(Duration(milliseconds: 5000), (timer) {
      setState(() {
        futureAlbum = fetchAlbum();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureAlbum,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              Card(
                color: Colors.black38,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    launchURL1();
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.swap_horiz, color: Colors.green),
                        title: Text(
                            "Latitude: " + snapshot.data.latitude.toString()),
                      ),
                      ListTile(
                        leading: Icon(Icons.swap_vert, color: Colors.green),
                        title: Text("Longitude : " +
                            snapshot.data.longitude.toString()),
                      ),
                      ListTile(
                        leading:
                            Icon(Icons.remove_red_eye, color: Colors.lightBlue),
                        title: Text("Visibility : " +
                            snapshot.data.visibility.toString()),
                      ),
                      ListTile(
                        leading:
                            Icon(Icons.fast_forward, color: Colors.redAccent),
                        title: Text(
                            "Velocity : " + snapshot.data.velocity.toString()),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.people, color: Colors.amber),
                      title: Text("Number of people aboard ISS : " +
                          snapshot.data.number.toString()),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data.number,
                    itemBuilder: (BuildContext context, index) {
                      return ListTile(
                        leading:
                            Icon(Icons.person_outline, color: Colors.amber),
                        title: Text(snapshot.data.people[index].name),
                      );
                    }),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.my_location,
                      color: Colors.lightGreenAccent, size: 35),
                  title: Text('ISS PASS TIMES OVER INDIA: '),
                  subtitle: Text('(24-Hour Format)'),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (BuildContext context, index) {
                      return ListTile(
                        leading: Icon(Icons.satellite,
                            color: Colors.lightGreenAccent),
                        title: Text(snapshot.data.response[index].risetime),
                      );
                    }),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
