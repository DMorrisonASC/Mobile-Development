import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getwidget/getwidget.dart';
import 'DetailsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirebaseAuth.instance.currentUser == null ? SignInScreen() : MyHomePage(),
    );
  }
}

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _signInWithEmailAndPassword(BuildContext context) async {
    try {
      // Sign in with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Navigate to main screen on successful sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } catch (e) {
      // Handle sign-in errors
      print('Sign in failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sign in failed: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _signInWithEmailAndPassword(context),
              child: Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text('No account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _signUpWithEmailAndPassword(BuildContext context) async {
    try {
      // Sign up with email and password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Navigate to main screen on successful sign-up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } catch (e) {
      // Handle sign-up errors
      print('Sign up failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sign up failed: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () => _signUpWithEmailAndPassword(context),
              child: Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
              child: Text('Already have an account? Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}


class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Data: longPress = Delete, tap = details, doubletap = changed "used"'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            },
          ),
        ],
      ),
      body: FirestoreList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

void _showDialog(BuildContext context) {
  String documentName = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter Document Name'),
        content: TextField(
          onChanged: (value) {
            documentName = value;
          },
          decoration: InputDecoration(hintText: 'Document Name'),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Create'),
            onPressed: () {
              FireCollection.createCollectionWithDocument(documentName);
              print('New document created: $documentName');
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class FireCollection {
  static Future<void> createCollectionWithDocument(name) async {
    await FirebaseFirestore.instance.collection('pokemon').add({
      'name': name,
      'used': false,
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

  void deleteDoc(docID) {
    final collection = FirebaseFirestore.instance.collection('pokemon');
    collection.doc(docID).delete();
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
              onLongPress: () => FireCollection().deleteDoc(document.id),
            );
          }).toList(),
        );
      },
    );

  }
}
