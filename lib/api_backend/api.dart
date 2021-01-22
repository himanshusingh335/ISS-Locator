import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ISSData {
  var latitude;
  var longitude;
  var velocity;
  var visibility;

  ISSData({this.latitude, this.longitude, this.velocity, this.visibility});

  factory ISSData.fromJson(Map<String, dynamic> json) {
    return ISSData(
      latitude: json['latitude'],
      longitude: json['longitude'],
      velocity: json['velocity'],
      visibility: json['visibility'],
    );
  }
}

class People {
  String craft;
  String name;

  People({this.craft, this.name});

  People.fromJson(Map<String, dynamic> json) {
    craft = json['craft'];
    name = json['name'];
  }
}

class Album2 {
  var number;
  var message;
  List<People> people;

  Album2({this.number, this.people, this.message});

  Album2.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    message = json['message'];
    if (json['people'] != null) {
      people = new List<People>();
      json['people'].forEach((v) {
        people.add(new People.fromJson(v));
      });
    }
  }
}

class Response {
  var risetime;
  var duration;

  Response({this.risetime, this.duration});

  Response.fromJson(Map<String, dynamic> json) {
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(json['risetime'] * 1000);
    risetime = "Day: " +
        dt.day.toString() +
        "/" +
        dt.month.toString() +
        "/" +
        dt.year.toString() +
        " Time: " +
        dt.hour.toString() +
        ":" +
        dt.minute.toString() +
        ":" +
        dt.second.toString();
    duration = json['duration'];
  }
}

class Album3 {
  List<Response> response;

  Album3({this.response});

  Album3.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = new List<Response>();
      json['response'].forEach((v) {
        response.add(new Response.fromJson(v));
      });
    }
  }
}

class Album {
  var latitude;
  var longitude;
  var velocity;
  var visibility;

  var number;
  List<People> people;

  List<Response> response;

  Album(this.latitude, this.longitude, this.velocity, this.visibility,
      this.number, this.people, this.response);
}

Future<Album> fetchAlbum() async {
  ISSData a1;
  Album2 a2;
  Album3 a3;
  Album a;

  final response1 = await http.get(
    'https://api.wheretheiss.at/v1/satellites/25544',
  );
  if (response1.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final jsonresponse1 = json.decode(response1.body);
    a1 = ISSData.fromJson(jsonresponse1);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album 1');
  }
  final response2 = await http.get(
    'http://api.open-notify.org/astros.json',
  );
  if (response2.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final jsonresponse2 = json.decode(response2.body);
    a2 = Album2.fromJson(jsonresponse2);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album 2');
  }

  final response3 = await http.get(
    'http://api.open-notify.org/iss-pass.json?lat=20.5937&lon=78.9629',
  );
  if (response3.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final jsonresponse3 = json.decode(response3.body);
    a3 = Album3.fromJson(jsonresponse3);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album 1');
  }

  a = Album(a1.latitude, a1.longitude, a1.velocity, a1.visibility, a2.number,
      a2.people, a3.response);
  return a;
}
