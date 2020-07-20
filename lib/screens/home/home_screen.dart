import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/models/Dog.dart';
import 'package:flutter_login/screens/home/favorite_list.dart';
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

  Widget _favoriteButton(String imageUrl) {
    if (_favoriteDogs.contains(imageUrl)) {
      return IconButton(
        onPressed: () {
          setState(() {
            _favoriteDogs.remove(imageUrl);
            saveFavoriteDogs(_favoriteDogs);
          });
        },
        color: Colors.red,
        iconSize: 30.0,
        icon: Icon(Icons.favorite),
      );
    }
    return IconButton(
      onPressed: () {
        setState(() {
          _favoriteDogs.insert(0, imageUrl);
          saveFavoriteDogs(_favoriteDogs);
        });
      },
      icon: Icon(Icons.favorite_border),
      iconSize: 30.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.favorite_border),
          title: Text("Random dog"),
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
                flex: 10,
                child: FutureBuilder(
                    future: _randomDog,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: NetworkImage(snapshot.data.message))),
                        );
                      } else if (snapshot.hasError) {
                        return Container(
                          alignment: Alignment(0, 0),
                          child: Text(snapshot.error.toString()),
                        );
                      }
                      return Container(
                          alignment: Alignment(0, 0), child: Text('No dog'));
                    })),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.teal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FutureBuilder(
                        future: _previousRandomDog,
                        builder: (context, snapshot) {
                          if (_previousRandomDog != null) {
                            return IconButton(
                                onPressed: _getPreviousDog,
                                icon: Icon(Icons.subdirectory_arrow_left),
                                iconSize: 30);
                          }
                          return IconButton(
                              onPressed: null,
                              icon: Icon(Icons.subdirectory_arrow_left),
                              iconSize: 30,
                              color: Colors.white60);
                        }),
                    FutureBuilder(
                      future: _randomDog,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return _favoriteButton(snapshot.data.message);
                        }
                        return _favoriteButton(' ');
                      },
                    ),
                    RaisedButton.icon(
                        onPressed: _getDog,
                        color: Colors.white,
                        icon: Icon(Icons.favorite_border),
                        label: Text("Get random dog"))
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
