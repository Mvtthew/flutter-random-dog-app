import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/models/Dog.dart';
import 'package:flutter_login/screens/home/favorite_list.dart';
import 'package:flutter_login/screens/home/photo_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Dog> _randomDog;
  Future<Dog> _previousRandomDog;
  List<String> _favoriteDogs = new List();

  void _getDog() {
    setState(() {
      if (_randomDog != null) {
        _previousRandomDog = _randomDog;
      }
      _randomDog = getRandomDog();
    });
  }

  void _getPreviousDog() {
    setState(() {
      _randomDog = _previousRandomDog;
      _previousRandomDog = null;
    });
  }

  @override
  initState() {
    super.initState();
    loadFavorites();
  }

  loadFavorites() {
    setState(() {
      loadFavoriteDogs().then((value) {
        _favoriteDogs = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RDog"),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FavoriteList(onRemoved: loadFavorites)));
              },
              icon: Icon(Icons.favorite),
              label: Text("Favorites"))
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: FutureBuilder(
                  future: _randomDog,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PhotoScreen(
                                      photoUrl: snapshot.data.message)));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Image.network(snapshot.data.message),
                                  ),
                                ))
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                        alignment: Alignment(0, 0),
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    return Container(
                        alignment: Alignment(0, 0),
                        child: Text('Select "NEXT" and load random dog...'));
                  }))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 70.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FutureBuilder(
                  future: _previousRandomDog,
                  builder: (context, snapshot) {
                    if (_previousRandomDog != null) {
                      return IconButton(
                        onPressed: _getPreviousDog,
                        icon: Icon(Icons.subdirectory_arrow_left),
                      );
                    }
                    return IconButton(
                        onPressed: null,
                        icon: Icon(Icons.subdirectory_arrow_left),
                        color: Colors.white60);
                  }),
              IconButton(
                  onPressed: _getDog,
                  icon: Icon(Icons.subdirectory_arrow_right)),
            ],
          ),
        ),
      ),
      floatingActionButton: FutureBuilder(
        future: _randomDog,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (_favoriteDogs.contains(snapshot.data.message)) {
              return FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _favoriteDogs.remove(snapshot.data.message);
                    saveFavoriteDogs(_favoriteDogs);
                  });
                },
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              );
            } else {
              return FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _favoriteDogs.insert(0, snapshot.data.message);
                    saveFavoriteDogs(_favoriteDogs);
                  });
                },
                child: Icon(Icons.favorite_border),
              );
            }
          }
          return FloatingActionButton(
            onPressed: null,
            child: Icon(Icons.favorite_border),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
