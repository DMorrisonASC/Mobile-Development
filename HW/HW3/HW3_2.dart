import 'package:flutter/material.dart';
import 'Book.dart';
import 'DetailsPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // var allBooks = {
  //   1: ["Pikachu's mystery", "John Doe", "Some vague description. Some vague description. Some vague description. "],
  //   2: ["The Communist Manifesto", "Jane Doe", "Some vague description. Some vague description. Some vague description. "],
  // };


  @override
  Widget build(BuildContext context) {
    List<Book> allBooks = [];
    Book book1 = Book(title: "Pikachu's mystery", author: "Satoshi Tajiri", description: "Pokémon is a Japanese media franchise consisting of video games, animated series and films, a trading card game, and other related media.");
    Book book2 = Book(title: "The Communist Manifesto", author: "Karl Marx", description: "The text outlines the relationship between the means of production, relations of production, forces of production, and the mode of production, and posits that changes in society's economic base effect changes in its superstructure.");
    Book book3 = Book(title: "Pro-union", author: "Working class", description: "Joining together in unions enables workers to negotiate for higher wages and benefits and improve conditions in the workplace.");
    allBooks.add(book1);
    allBooks.add(book2);
    allBooks.add(book3);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView(
            children: allBooks.map((entry) {
              Book eachBook = entry;
              return ListTile(
                leading: Icon(Icons.book),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailsPage(book: eachBook)),
                  );
                },
                title: Text(entry.title), // Book Title
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Author: ${entry.author}'), // Author
                    Text('Description: ${entry.description}'), // Description
                  ],
                ),
                  trailing: Icon(Icons.line_style),
                  isThreeLine: true,
              );
            }).toList()
        )
      ),
    );
  }
}
