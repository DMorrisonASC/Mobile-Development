import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _name = 'Loading...';
  int _age = 0;
  String _car = "None";
  String _home = "None";
  String _textFieldValue = '';
  bool _isAppending = false;
  double _currentSliderValue = 20;

  @override
  void initState() {
    super.initState();
    loadUserInfo().then((_) {
      setState(() {}); // Triggers a rebuild with the updated _name and _age
    });
  }

  Future<void> loadUserInfo() async {
    final localData = await readData();
    if (localData.isNotEmpty) {
      final jsonResult = json.decode(localData);
      _name = jsonResult['name'];
      _age = jsonResult['age'];
      _car = jsonResult['car'];
    } else {
      // Load initial data from assets if no local data is found
      final bundleData = await rootBundle.loadString('assets/user_info.json');
      await writeData(bundleData); // Optionally write this data to local storage for future use
      final jsonResult = json.decode(bundleData);
      _name = jsonResult['name'];
      _age = jsonResult['age'];
      _car = jsonResult['car'];
    }
  }

  Future<String> readData() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        return await file.readAsString();
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  Future<File> writeData(String data) async {
    final file = await _localFile;
    return file.writeAsString(data);
  }

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/user_info.json');
  }

  Future<File> writeToLocalJson(String data) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/user_info.json');

    // Check if user wants to append or write
    if (_isAppending) {
      // Read existing JSON data from the file
      String jsonData = await file.readAsString();
      Map<String, dynamic> jsonMap = json.decode(jsonData);

      // Add the 'home' key with the `data`
      jsonMap['home'] = data;

      // Convert the updated JSON map back to a string
      String updatedJsonData = json.encode(jsonMap);

      return file.writeAsString(updatedJsonData);
    } else {
        Map<String, dynamic> jsonData = {
          'name': data,
          'age': 40,
          'car': "BMW",
          'home': "None",
        };

        // Convert the Map to a JSON string
        String jsonString = json.encode(jsonData);

        return file.writeAsString(jsonString);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('User Info'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('Name: $_name, Age: $_age, Car: $_car, Home: $_home', style: TextStyle(fontSize: _currentSliderValue), ),
            ),
            TextField(
              onChanged: (value) {
                _textFieldValue = value;
              },
            ),
            Row(
              children: [
                Radio(
                  value: false,
                  groupValue: _isAppending,
                  onChanged: (value) {
                    setState(() {
                      _isAppending = value!;
                    });
                  },
                ),
                Text('Write'),
                Radio(
                  value: true,
                  groupValue: _isAppending,
                  onChanged: (value) {
                    setState(() {
                      _isAppending = value!;
                    });
                  },
                ),
                Text('Append'),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                await writeToLocalJson('$_textFieldValue $_textFieldValue');
              },
              child: Text("Store String"),
            ),
            ElevatedButton(
              onPressed: () {
                loadUserInfo().then((_) {
                  setState(() {}); // Triggers a rebuild with the updated _name and _age
                });
              },
              child: Text("Load String"),
            ),
            Slider(
              value: _currentSliderValue,
              max: 100,
              label: _currentSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
