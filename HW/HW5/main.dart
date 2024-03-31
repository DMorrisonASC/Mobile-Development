import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getwidget/getwidget.dart';
import 'DetailsPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Firestore Data'),
        ),
        body: FirestoreList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Alert Dialog"),
                    content: Text("Dialog Content"),
                  );
                });
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    String documentName = '';

    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text('Enter Document Name'),
    //       content: TextField(
    //         onChanged: (value) {
    //           documentName = value;
    //         },
    //         decoration: InputDecoration(hintText: 'Document Name'),
    //       ),
    //       actions: <Widget>[
    //         TextButton(
    //           child: Text('Cancel'),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //         TextButton(
    //           child: Text('Create'),
    //           onPressed: () {
    //             print('New document created: $documentName');
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );


    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Submitted Text'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

}

class FireCollection {
  static Future<void> createCollectionWithDocument() async {
    await FirebaseFirestore.instance.collection('notes').add({
      'title': 'First Note',
      'content': 'This is my first note!',
      'created': FieldValue.serverTimestamp(),
    });
  }

  void updateCollection(docID, data) {
    final collection = FirebaseFirestore.instance.collection('pokemon');
    if (data['used'] == true) {
      collection.doc(docID).update({'used': false});
    } else {
      collection.doc(docID).update({'used': true});
    }
  }
}

class FirestoreList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference collection = FirebaseFirestore.instance.collection('pokemon');

    return StreamBuilder<QuerySnapshot>(
      stream: collection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return GestureDetector(
              child: Card(
                child: GFListTile(
                  title: Text(data['name']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailsPage(details: data)),
                    );
                  },
                ),
              ),
              onDoubleTap: () {
                FireCollection().updateCollection(document.id, data);
              },
            );
          }).toList(),
        );
      },
    );

  }


}
