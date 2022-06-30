import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:developer';

Future<PostResult> connectToAPI(String name, String job) async {
  var apiResult = await http.post(Uri.parse("https://reqres.in/api/users"),
      body: ({
        "name": name,
        "job": job,
      }));

  log("apiResult = ${jsonDecode(apiResult.body)}");
  return PostResult.createPostResult(jsonDecode(apiResult.body));
}

class PostResult {
  String id;
  String name;
  String job;
  String created;

  PostResult({this.id = "", this.name = "", this.job = "", this.created = ""});

  factory PostResult.createPostResult(Map<String, dynamic> json) {
    return PostResult(
      id: json['id'],
      name: json['name'],
      job: json['job'],
      created: json['createdAt'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  Future<PostResult>? postResult;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reqres.in POST Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Reqres.in POST Test'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: "Enter Name"),
              ),
              Container(child: buildFutureBuilder()),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    postResult = connectToAPI(_controller.text, "test");
                  });
                },
                child: Text("POST"),
              )
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<PostResult> buildFutureBuilder() {
    return FutureBuilder<PostResult>(
        future: postResult,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text("id: " +
                snapshot.data!.id +
                "\nname: " +
                snapshot.data!.name +
                "\ncreatedAt: " +
                snapshot.data!.created);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return const CircularProgressIndicator();
        });
  }
}
