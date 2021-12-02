import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future <List<Data>> fetchData() async {
  final response = await http
      .get(Uri.parse('http://localhost/klab/api/members/members.php'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);

    var data = jsonDecode(response.body);

    print(data);

    return jsonResponse.map((data) => new Data.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Data {
  final String member_id;
  final String category_id;
  final String member_lname;
  final String member_fname;

  Data({this.member_id, this.category_id,this.member_fname, this.member_lname});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      member_id: json['member_id'],
      category_id: json['category_id'],
      member_fname: json['member_fname'],
      member_lname: json['member_lname'],
    );
  }
}

// void main() => runApp(Members());

class Members extends StatefulWidget {
  Members({Key key}) : super(key: key);

  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> {
  Future <List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter API and ListView Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Members'),
        ),
        body: Center(
          child: FutureBuilder <List<Data>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Data> data = snapshot.data;
                return
                  ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 75,
                          color: Colors.white,
                          child: Center(child: Text(data[index].member_fname),
                          ),);
                      }
                  );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}