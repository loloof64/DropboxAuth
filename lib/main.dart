import 'dart:convert';

import 'package:dropbox_auth/dropbox_calls.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DropBox Auth',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Dropbox Auth"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Get files"),
              onPressed: () async {
                final oauth2Helper = getDropboxHelper();
                final response = await oauth2Helper.post(
                    'https://api.dropboxapi.com/2/files/list_folder',
                    headers: {
                      "Content-Type": "application/json",
                    },
                    body: jsonEncode({
                      "path": "",
                      "recursive": false,
                    }));
                print(response.body);
              },
            ),
          ],
        ),
      ),
    );
  }
}
