import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Api integration',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Applying get request.

  Future<List<GetData>> fetchJSONData() async {
    String url = "https://jsonplaceholder.typicode.com/users";
    final jsonResponse = await http.get(Uri.parse(url));

    final jsonItems =
        json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

    List<GetData> usersList = jsonItems.map<GetData>((json) {
      return GetData.fromJson(json);
    }).toList();

    return usersList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Api integration"),
      ),
      body: FutureBuilder<List<GetData>>(
        future: fetchJSONData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!
                .map(
                  (e) => ListTile(
                    title: Text(e.email),
                    subtitle: Text(e.name),
                    trailing: Text(e.username),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

class GetData {
  int id;
  String name;
  String email;
  String username;

  GetData(
      {required this.id,
      required this.name,
      required this.email,
      required this.username});

  factory GetData.fromJson(Map<String, dynamic> json) {
    return GetData(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        username: json['username']);
  }
}
