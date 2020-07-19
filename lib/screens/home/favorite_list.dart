import 'package:flutter/material.dart';
import 'package:flutter_login/models/Dog.dart';

class FavoriteList extends StatefulWidget {

  final VoidCallback onRemoved;

  FavoriteList({this.onRemoved});

  @override
  _FavoriteListState createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  List<String> _favoriteDogs = new List();

  @override
  void initState() {
    super.initState();
    loadFavoriteDogs().then((value) {
      setState(() {
        _favoriteDogs = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your favorite dogs"),
      ),
      body: ListView.builder(
        itemCount: _favoriteDogs.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                      image:
                      DecorationImage(image: NetworkImage(_favoriteDogs[index]))),
                ),
              ),
              Expanded(
                flex: 2,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _favoriteDogs.remove(_favoriteDogs[index]);
                      saveFavoriteDogs(_favoriteDogs);
                      widget.onRemoved();
                    });
                  },
                  icon: Icon(Icons.close),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
