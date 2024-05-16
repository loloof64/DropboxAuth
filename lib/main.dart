import 'dart:convert';

import 'package:dropbox_auth/dropbox_calls.dart';
import 'package:dropbox_auth/models/dropbox_files_fetching.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      debugShowCheckedModeBanner: false,
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
  var _connected = false;
  var _files = <FilesFetchingEntry>[];
  String? _currentPath;

  Future<void> _fetchFiles() async {
    try {
      final oauth2Helper = getDropboxHelper();
      final response = await oauth2Helper.post(
          'https://api.dropboxapi.com/2/files/list_folder',
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "path": _currentPath ?? "",
            "recursive": false,
          }));
      final result = dropboxFilesFetchingFromJson(response.body);
      setState(() {
        _files = [];
      });
      _processFilesResult(result);
      setState(() {
        _connected = true;
      });
    } catch (e) {
      debugPrint("Got error when fetching files : $e");
    }
  }

  Future<void> _goOnFetchingFiles(String cursor) async {
    try {
      final oauth2Helper = getDropboxHelper();
      final response = await oauth2Helper.post(
          'https://api.dropboxapi.com/2/files/list_folder/continue',
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "cursor": cursor,
          }));
      final result = dropboxFilesFetchingFromJson(response.body);
      _processFilesResult(result);
    } catch (e) {
      debugPrint("Got error when fetching files : $e");
    }
  }

  void _processFilesResult(DropboxFilesFetching data) {
    for (var currentData in data.entries) {
      _files.add(currentData);
    }
    if (data.hasMore) {
      _goOnFetchingFiles(data.cursor);
    }
  }

  Future<void> _revoke() async {
    final oauth2Helper = getDropboxHelper();
    await oauth2Helper.removeAllTokens();
    setState(() {
      _connected = false;
    });
  }

  List<FileItem> _getItems() {
    final items = _files.map((currentFile) {
      return FileItem(
        isFolder: currentFile.tag == Tag.folder,
        name: currentFile.name,
      );
    }).toList();
    items.sort((first, snd) {
      if (first.isFolder && !snd.isFolder) {
        return -1;
      } else if (!first.isFolder && snd.isFolder) {
        return 1;
      } else {
        return first.name.compareTo(snd.name);
      }
    });
    return items;
  }

  @override
  void initState() {
    super.initState();
    _fetchFiles().then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    final items = _getItems().map((currentItem) {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FaIcon(
              currentItem.isFolder
                  ? FontAwesomeIcons.folder
                  : FontAwesomeIcons.file,
              color:
                  currentItem.isFolder ? Colors.amber[300] : Colors.blue[300],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(currentItem.name),
          ),
        ],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Dropbox Auth"),
        actions: [
          if (_connected)
            IconButton(
              onPressed: () => _fetchFiles(),
              icon: const FaIcon(FontAwesomeIcons.arrowsRotate),
            ),
          if (_connected)
            IconButton(
              onPressed: _revoke,
              icon: const FaIcon(FontAwesomeIcons.arrowUpFromBracket),
            )
          else
            IconButton(
              onPressed: () => _fetchFiles(),
              icon: const FaIcon(FontAwesomeIcons.dropbox),
            )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: items,
          ),
        ),
      ),
    );
  }
}

class FileItem {
  bool isFolder;
  String name;

  FileItem({
    required this.isFolder,
    required this.name,
  });
}
