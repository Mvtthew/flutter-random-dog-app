import 'package:flutter/material.dart';
import 'package:flutter_login/models/Dog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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

//  Remove item
//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your favorite dogs"),
      ),
      body: ListView.separated(
          itemCount: _favoriteDogs.length,
          itemBuilder: (BuildContext context, int index) {
            return Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Container(
                height: 250.0,
                margin: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: NetworkImage(_favoriteDogs[index]))),
              ),
              secondaryActions: [
                IconSlideAction(
                  caption: "Remove",
                  color: Colors.red,
                  icon: Icons.cancel,
                  onTap: () {
                    setState(() {
                      _favoriteDogs.remove(_favoriteDogs[index]);
                      saveFavoriteDogs(_favoriteDogs);
                      widget.onRemoved();
                    });
                  },
                )
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              height: 0,
            );
          }),
    );
  }
}
