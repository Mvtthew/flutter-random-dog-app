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
  List<String> _favoriteDogs = new List();

  void _getDog() {
    setState(() {
      _randomDog = getRandomDog();
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
        icon: Icon(Icons.favorite),
      );
    }
    return IconButton(
      onPressed: () {
        setState(() {
          _favoriteDogs.add(imageUrl);
          saveFavoriteDogs(_favoriteDogs);
        });
      },
      icon: Icon(Icons.favorite_border),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FavoriteList(onRemoved: loadFavorites)));
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
                    RaisedButton.icon(
                        onPressed: _getDog,
                        color: Colors.white,
                        icon: Icon(Icons.favorite_border),
                        label: Text("Get random dog")),
                    FutureBuilder(
                      future: _randomDog,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return _favoriteButton(snapshot.data.message);
                        }
                        return _favoriteButton(' ');
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
