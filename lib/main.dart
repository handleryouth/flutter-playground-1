import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// This function triggers the build process
void main() {
  runApp(MyApp());
}

/*
The widgets whose state can not be altered once they are built are called stateless widgets.
These widgets are immutable once they are built i.e. any amount of change in the variables, icons, buttons, or retrieving data can not change the state of the app.
*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

/*
  Every widget has a build method, which says  what does this widget contain.
*/
  @override
  Widget build(BuildContext context) {
    /*
ChangeNotifierProvider is the widget that provides an instance of a ChangeNotifier to its descendants. 
It comes from the provider package.
    */
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          // Generate a [ColorScheme] derived from the given seedColor.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        // The widget for the default route of the app
        home: MyHomePage(),
      ),
    );
  }
}

/*
  What change notifier does is like everything that consume a variable or watching that notifier, should update themselves.
*/
/*
The state class extends ChangeNotifier, which means that it can notify others about its own changes. 
For example, if the current word pair changes, some widgets in the app need to know.
*/
/*
MyAppState covered all your state needs. 
That's why all the widgets you have written so far are stateless.

In the stateless widget, 
the build function is called only once which makes the UI of the screen.

*/

/*
ChangeNotifier is a simple class included in the Flutter SDK which provides change notification to its listeners. 
In other words, if something is a ChangeNotifier, you can subscribe to its changes. (It is a form of Observable, for those familiar with the term.)

Change notifier is like state management (like Redux).
*/
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    /*
      It also calls notifyListeners()(a method of ChangeNotifier)that ensures that anyone 
      watching MyAppState is notified.

      another explanation:
       // This call tells the widgets that are listening to this model to rebuild.
    */
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

// Home page
/*
Widgets are the elements from which you build every Flutter app. As you can see, even the app itself is a widget.

*/

/*
The widgets whose state can be altered once they are built are called stateful Widgets.
This simply means the state of an app can change multiple times with different sets of variables, inputs, data.

Stateful widget overrides the createState() method and returns a State.
*/
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
  // class MyHomePage extends StatelessWidget

  //TODO: Uncomment for stateful widget
  // @override
  // Widget build(BuildContext context) {
  // thjis widget watch the MyAppState
  // build every time the app state changes
  // var appState = context.watch<MyAppState>();
  // var pair = appState.current;

  // IconData icon;
  // if (appState.favorites.contains(pair)) {
  //   icon = Icons.favorite;
  // } else {
  //   icon = Icons.favorite_border;
  // }

  // return Scaffold(
  //   body: Row(
  //     children: [
  //       // The SafeArea ensures that its child is not obscured by a hardware notch or a status bar.
  //       SafeArea(
  //         child: NavigationRail(
  //           //You can change the extended: false line in NavigationRail to true. This shows the labels next to the icons.
  //           extended: false,
  //           destinations: [
  //             NavigationRailDestination(
  //                 icon: Icon(Icons.home), label: Text("Home")),
  //             NavigationRailDestination(
  //                 icon: Icon(Icons.favorite), label: Text("Favourites"))
  //           ],
  //           selectedIndex: 0,
  //           onDestinationSelected: (value) {
  //             print('selected: $value');
  //           },
  //         ),
  //       ),
  //       Expanded(
  //           child: Container(
  //         color: Theme.of(context).colorScheme.primaryContainer,
  //         child: GeneratorPage(),
  //       ))
  //     ],
  //   ),
  // Center(
  //   child: Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       // Text('A random AWESOME idea:'),
  //       BigCard(pair: pair),
  //       SizedBox(
  //         height: 10,
  //       ),
  //       Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           ElevatedButton.icon(
  //               onPressed: () {
  //                 appState.toggleFavorite();
  //               },
  //               icon: Icon(icon),
  //               label: Text("Like")),
  //           SizedBox(width: 10),
  //           ElevatedButton(
  //               onPressed: () {
  //                 appState.getNext();
  //               },
  //               child: Text("Next"))
  //         ],
  //       )
  //     ],
  //   ),
  // ),
  //   );
  // }
}

/*
The underscore (_) at the start of _MyHomePageState makes that class private and is enforced by the compiler. 
*/
class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        //Placeholder; a handy widget that draws a crossed rectangle wherever you place it, marking that part of the UI as unfinished.
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // The container for the current page, with its background color
    // and subtle switching animation.

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: false,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                ],
                selectedIndex: selectedIndex, // ← Change to this.
                onDestinationSelected: (value) {
                  // ↓ Replace print with this.
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  // child: GeneratorPage(),
                  child: page),
            ),
          ],
        ),
      );
    });
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    if (appState.favorites.isEmpty) {
      return Center(child: Text("No Favorites yet!."));
    }

    return ListView(
      children: [
        Padding(
            padding: const EdgeInsets.all(20),
            child: Text('You have ${appState.favorites.length} favorites:')),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text('A random AWESOME idea:'),
          BigCard(pair: pair),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text("Like")),
              SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text("Next"))
            ],
          )
        ],
      ),
    );
  }
}

/*
You can refactor to create a new widget by using refactor.
*/
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    // First, the code requests the app's current theme with Theme.of(context).
    final theme = Theme.of(context);

    /*
  By using theme.textTheme, you access the app's font theme. 
  This class includes members such as bodyMedium (for standard text of medium size),
   caption (for captions of images), 
   or headlineLarge (for large headlines).
  */
    final TextStyle style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.onPrimary);
/*
copyWith() on displayMedium returns a copy of the text style with the changes you define. In this case, you're only changing the text's color.
*/

    return Card(
      //the code defines the card's color to be the same as the theme's colorScheme propert
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first}  ${pair.second}",
        ),
      ),
    );
  }
}



/*

Comparing:
Stateless widget vs stateful widget

Stateless widget is useful when the part of the user interface 
you are describing does not depend on anything other than the 
configuration information and the BuildContext 

a Stateful widget is useful when the part of the user interface
you are describing can change dynamically.


*/